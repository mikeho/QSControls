/**
 * QSModalHttpClient.m
 * 
 * Copyright (c) 2010 - 2011, Quasidea Development, LLC
 * For more information, please go to http://www.quasidea.com/
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "QSControls.h"
#import "QSUtilities.h"

@interface QSModalHttpClient (private) 
- (bool)sendWithData:(id)objRequestContent StreamFlag:(bool)blnStreamFlag;
- (void)dismissAlertView;
- (void)adjustAlertView;
@end

@implementation QSModalHttpClient

@synthesize _strUrl;
@synthesize _strHttpMethod;
@synthesize _intTimeoutInterval;

@synthesize _strMessage;
@synthesize _strMessageDuringUpload;

@synthesize _intHttpStatusCode;
@synthesize _objResponseData;

@synthesize _strStringTag;
@synthesize _intPrimaryTag;
@synthesize _intSecondaryTag;
@synthesize _objDelegate;

#pragma mark -
#pragma mark Initializers and Housekeeping


- (QSModalHttpClient *)initWithUrl:(NSString *)strUrl HttpMethod:(NSString *)strHttpMethod {
	if ([self init]) {
		[self setUrl:strUrl];
		[self setHttpMethod:strHttpMethod];
		[self setTimeoutInterval:5];

		return self;
	}

	return nil;
}

- (void)cleanupFromPreviousRequests {
	if (_objAlertView != nil) {
		[_objAlertView release];
		_objAlertView = nil;
	}
	
	if (_objResponseData != nil) {
		[_objResponseData release];
		_objResponseData = nil;
	}

	_intHttpStatusCode = 0;
}

#pragma mark -
#pragma mark Pubic Execution Methods

- (bool)sendString:(NSString *)strRequest {
	return [self sendWithData:[strRequest dataUsingEncoding:NSUTF8StringEncoding] StreamFlag:false];
}

- (bool)sendFile:(NSString *)strFilePath {
	_intRequestDataSize = [QSFileManager fileSize:strFilePath];
	return [self sendWithData:[NSInputStream inputStreamWithFileAtPath:strFilePath] StreamFlag:true];
}

- (bool)sendData:(NSData *)objData {
	_intRequestDataSize = [objData length];
	return [self sendWithData:objData StreamFlag:false];
}

#pragma mark -
#pragma mark Private Helpers


- (bool)sendWithData:(id)objRequestContent StreamFlag:(bool)blnStreamFlag {
	// Can only be used once
	if (_objConnection != nil) {
		NSAssert(false, @"QSModalHttpClient instance already used");
	}
	
	// Setup the Response Data Placeholder
	_objResponseData = [[NSMutableData alloc] init];
	
	// Show the Alert View
	NSString * strMessage;
	if (_strMessageDuringUpload == nil) {
		if (_strMessage == nil)
			strMessage = NSLocalizedString(@"Please wait...", nil);
		else
			strMessage = _strMessage;
	} else
		strMessage = _strMessageDuringUpload;
	
	_objAlertView = [[UIAlertView alloc] initWithTitle:strMessage message:@"\n" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[_objAlertView show];
	
	// Add the "Spinner"
	UIActivityIndicatorView * objWaitIcon = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[objWaitIcon setTag:kWaitScreenSpinner];
	objWaitIcon.center = CGPointMake(_objAlertView.bounds.size.width / 2.0f, _objAlertView.bounds.size.height - 70.0f);
	[objWaitIcon startAnimating];
	[_objAlertView addSubview:objWaitIcon];
	[objWaitIcon release];
	
	// Add Progress Bar
	UIProgressView * objProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	[objProgressView setTag:kHttpProgressView];
	[objProgressView setFrame:CGRectMake(20, _objAlertView.bounds.size.height - 40, _objAlertView.bounds.size.width - 40, 90)];
	[_objAlertView addSubview:objProgressView];
	[objProgressView release];
	
	// Adjust
	[self performSelector:@selector(adjustAlertView) withObject:nil afterDelay:0.25];
	[self performSelector:@selector(adjustAlertView) withObject:nil afterDelay:0.65];
	
	// Generate the Request
	_objUrl = [[NSURL alloc] initWithString:_strUrl];
	_objRequest = [[NSMutableURLRequest alloc] initWithURL:_objUrl];
	[_objRequest setTimeoutInterval:_intTimeoutInterval];
	[_objRequest setHTTPMethod:_strHttpMethod];
	
	if (blnStreamFlag) {
		[_objRequest setHTTPBodyStream:objRequestContent];
	} else {
		[_objRequest setHTTPBody:objRequestContent];
	}
	
	_objConnection = [[NSURLConnection alloc] initWithRequest:_objRequest delegate:self];

#ifdef QSCONTROLS_LOG
	NSLog(@"Submitting Request of Size: %i To Location: %@", _intRequestDataSize, _strUrl);
#endif

	// Perform the Request
	[_objConnection start];

	return false;
}

- (void)adjustAlertView {
	if (_objAlertView) {
		UIActivityIndicatorView * objWaitIcon = (UIActivityIndicatorView *) [_objAlertView viewWithTag:kWaitScreenSpinner];
		UIProgressView * objProgressView = (UIProgressView *) [_objAlertView viewWithTag:kHttpProgressView];

		if (objWaitIcon) objWaitIcon.center = CGPointMake(_objAlertView.bounds.size.width / 2.0f, _objAlertView.bounds.size.height - 70.0f);
		if (objProgressView) [objProgressView setFrame:CGRectMake(20, _objAlertView.bounds.size.height - 40, _objAlertView.bounds.size.width - 40, 90)];
	}
}

- (void)dismissAlertView {
	if (_objAlertView != nil) {
		for (UIView * objView in [_objAlertView subviews]) {
			[objView removeFromSuperview];
		}

		[_objAlertView dismissWithClickedButtonIndex:0 animated:true];
		[_objAlertView release];
		_objAlertView = nil;
	}
}

#pragma mark -
#pragma mark Response Getters

- (bool)isSuccessful {
	return (_intHttpStatusCode >= 200) && (_intHttpStatusCode < 300);
}

- (NSString *)getResponseAsString {
	return [[[NSString alloc] initWithData:_objResponseData encoding:NSUTF8StringEncoding] autorelease];
}

- (NSData *)getResponseAsRawData {
	return [NSData dataWithData:_objResponseData];
}

#pragma mark -
#pragma mark Server Connection Delegate Handler

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self dismissAlertView];

	UIAlertView * objAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Error", nil)
														message:NSLocalizedString(@"Could not connect to the server.", nil)
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Okay", nil)
											  otherButtonTitles:nil];
	[objAlert show];
	[objAlert release];
	
	[_objDelegate httpClientComplete:self];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	UIProgressView * objProgressView = (UIProgressView *)[_objAlertView viewWithTag:kHttpProgressView];

	// Calculate Completion Percentage
	CGFloat fltComplete = 0;
	if (totalBytesExpectedToWrite > 0) {
		fltComplete = (1.0 * totalBytesWritten) / (1.0 * totalBytesExpectedToWrite);
	} else if (_intRequestDataSize > 0) {
		fltComplete = (1.0 * totalBytesWritten) / (1.0 * _intRequestDataSize);
	}

	[objProgressView setProgress:fltComplete];

#ifdef QSCONTROLS_LOG
	NSLog(@"UPLOAD: %i / %i or %i", totalBytesWritten, totalBytesExpectedToWrite, _intRequestDataSize);
#endif //QSCONTROLS_LOG
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// Cleanup
	[self dismissAlertView];
	
	// Check Status Code
	if ((_intHttpStatusCode >= 200) && (_intHttpStatusCode < 300)) {
		// Looks good!
		// At this point, we don't need to do anything
	} else {
		// Oops -- an HTTP status code indicating an issue / error
		UIAlertView * objAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Error", nil)
															message:[NSString stringWithFormat:NSLocalizedString(@"Received error status code '%d' from the server.", nil), _intHttpStatusCode]
														   delegate:nil
												  cancelButtonTitle:NSLocalizedString(@"Okay", nil)
												  otherButtonTitles:nil];
		[objAlert show];
		[objAlert release];
	}

	[_objDelegate httpClientComplete:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if (![response respondsToSelector:@selector(statusCode)]) {
		_intHttpStatusCode = 0;
	} else {
		_intHttpStatusCode = [(NSHTTPURLResponse *)response statusCode];
	}

	if (![response respondsToSelector:@selector(expectedContentLength)]) {
		_intResponseDataSize = 0;
	} else {
		_intResponseDataSize = [response expectedContentLength];
	}
	
	// Update Messaging
	if (_strMessage == nil)
		[_objAlertView setTitle:NSLocalizedString(@"Please wait...", nil)];
	else
		[_objAlertView setTitle:_strMessage];

	// Update Progress
	UIProgressView * objProgressView = (UIProgressView *)[_objAlertView viewWithTag:kHttpProgressView];
	[objProgressView setProgress:0.0f];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_objResponseData appendData:data];

	// Update Progress
	CGFloat fltComplete = 0;
	if (_intResponseDataSize > 0) {
		fltComplete = (1.0 * [_objResponseData length]) / (1.0 * _intResponseDataSize);
	}

	UIProgressView * objProgressView = (UIProgressView *)[_objAlertView viewWithTag:kHttpProgressView];
	[objProgressView setProgress:fltComplete];

#ifdef QSCONTROLS_LOG
	NSLog(@"DOWNLOAD: %i / %i", [_objResponseData length], _intResponseDataSize);
#endif //QSCONTROLS_LOG
}

#pragma mark -
#pragma mark Class Lifecycle

- (void)dealloc {
	[self setStringTag:nil];

	[self setUrl:nil];
	[self setHttpMethod:nil];
	[self setMessage:nil];
	[self setMessageDuringUpload:nil];

	[_objResponseData release];
	_objResponseData = nil;
	
	[self dismissAlertView];
	[_objAlertView release];
	_objAlertView = nil;
	
	[_objConnection release];
	_objConnection = nil;
	
	[_objUrl release];
	_objUrl = nil;
	
	[_objRequest release];
	_objRequest = nil;
	
	[super dealloc];
}

@end