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

@implementation QSModalHttpClient

@synthesize _strUrl;
@synthesize _strHttpMethod;
@synthesize _intTimeoutInterval;

@synthesize _strMessage;
@synthesize _strMessageDuringUpload;

@synthesize _intHttpStatusCode;
@synthesize _objResponseData;



- (QSModalHttpClient *)initWithUrl:(NSString *)strUrl HttpMethod:(NSString *)strHttpMethod {
	if ([self init]) {
		[self setUrl:strUrl];
		[self setHttpMethod:strHttpMethod];
		[self setTimeoutInterval:60];

//		_objCurrentLoop = CFRunLoopGetCurrent();

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
}

- (void)sendString:(NSString *)strRequest {
	// Cleanup from Previous Requests (if applicable)
	[self cleanupFromPreviousRequests];

	// Setup the Response Data Placeholder
	_objResponseData = [[NSMutableData alloc] init];

	// Show the Alert View
	NSString * strMessage;
	if (_strMessageDuringUpload == nil) {
		if (_strMessage == nil)
			strMessage = @"Please wait...";
		else
			strMessage = _strMessage;
	} else
		strMessage = _strMessageDuringUpload;

	_objAlertView = [[UIAlertView alloc] initWithTitle:strMessage message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[_objAlertView show];

	// Generate the Request
	NSURL * objUrl = [[NSURL alloc] initWithString:_strUrl];
	NSMutableURLRequest * objRequest = [[NSMutableURLRequest alloc] initWithURL:objUrl];
	[objRequest setTimeoutInterval:_intTimeoutInterval];
	[objRequest setHTTPMethod:_strHttpMethod];

	[objRequest setHTTPBody:[strRequest dataUsingEncoding:NSUTF8StringEncoding]];
	NSURLConnection * objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self];
	
	// Perform the Request
	[objConnection start];

	CFRunLoopRun();

	// Cleanup
	[objUrl release];
	[objRequest release];
	[objConnection release];
//	
//	NSArray * objPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
//	NSString * objDocumentsDirectory = [objPaths objectAtIndex:0];
//	NSString * objWriteableDbPath = [objDocumentsDirectory stringByAppendingPathComponent:@"verifacts_ios.db"];
//	
//	[objRequest setHTTPBodyStream:[NSInputStream inputStreamWithFileAtPath:objWriteableDbPath]];
//	
//	
//	//		[objRequest setHTTPBody:[[NSString stringWithFormat:@"<loginRequest username=\"%@\" password=\"%@\"/>",
//	//								 [objUsername Value], [objPassword Value]] dataUsingEncoding:NSUTF8StringEncoding]];
//	NSURLConnection * objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self];
//	
//	[objConnection start];
//	[objUrl release];
//	[objRequest release];
//	[objConnection release];
}

- (void)sendFile:(NSString *)strPath {
}

#pragma mark -
#pragma mark Server Connection

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[_objAlertView dismissWithClickedButtonIndex:0 animated:false];
	[_objAlertView release];
	_objAlertView = nil;

	UIAlertView * objAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
														message:@"Could not connect to the\nVeriFacts Server."
													   delegate:nil
											  cancelButtonTitle:@"Okay"
											  otherButtonTitles:nil];
	[objAlert show];
	[objAlert release];

	CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//	NSMutableString * strResponse =	[[NSMutableString alloc] initWithData:_objData encoding:NSASCIIStringEncoding];
//	
//	// Remove the Wait Icon
//	[_objAlertView dismissWithClickedButtonIndex:0 animated:false];
//	
//	// Process Successful Status Code
//	if ((_intStatusCode >= 200) && (_intStatusCode < 300)) {
//		NSInteger intUserId = 0;
//		NSString * strError = nil;
//		NSString * strCoachName = nil;
//		CXMLDocument *objXmlDocument = [[CXMLDocument alloc] initWithXMLString:strResponse options:0 error:nil];
//		
//		if (objXmlDocument != nil) {
//			CXMLElement * objNode = (CXMLElement *)[objXmlDocument nodeForXPath:@"//loginResponse" error:nil];
//			intUserId = [[[objNode attributeForName:@"userId"] stringValue] intValue];
//			strCoachName = [[objNode attributeForName:@"coachName"] stringValue];
//			strError = [[objNode attributeForName:@"error"] stringValue];
//		}
//		
//		[objXmlDocument release];
//		
//		// Valid Credentials?
//		if (intUserId > 0) {
//			// Save Cached Credentials
//			TextFieldFormItem * objUsername = (TextFieldFormItem *)[_objForm getFormItemWithKey:@"username"];
//			TextFieldFormItem * objPassword = (TextFieldFormItem *)[_objForm getFormItemWithKey:@"password"];
//			
//			[[IosPreference get] Username:[objUsername Value]];
//			[[IosPreference get] CoachName:strCoachName];
//			[[IosPreference get] PasswordCache:[objPassword Value]];
//			[[IosPreference get] DateLastPasswordUpdate:[NSDate date]];
//			[[IosPreference get] save];
//			
//			[self processSuccessfulLogin];
//			
//			// Invalid -- display Error
//		} else {
//			UIAlertView * objAlert = [[UIAlertView alloc] initWithTitle:@"Login Error"
//																message:strError
//															   delegate:nil
//													  cancelButtonTitle:@"Okay"
//													  otherButtonTitles:nil];
//			[objAlert show];
//			[objAlert release];
//		}
//		
//		// Process INVALID HTTP Status Code
//	} else {
//		UIAlertView * objAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
//															message:[NSString stringWithFormat:@"Received error status code '%d' from the VeriFacts Server.", _intStatusCode]
//														   delegate:nil
//												  cancelButtonTitle:@"Okay"
//												  otherButtonTitles:nil];
//		[objAlert show];
//		[objAlert release];
//	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if (![response respondsToSelector:@selector(statusCode)]) {
		_intHttpStatusCode = 0;
	} else {
		_intHttpStatusCode = [(NSHTTPURLResponse *)response statusCode];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_objResponseData appendData:data];
}

#pragma mark -
#pragma mark Class Lifecycle

- (void)dealloc {
	[self setUrl:nil];
	[self setHttpMethod:nil];
	[self setMessage:nil];
	[self setMessageDuringUpload:nil];

	[_objResponseData release];
	[_objAlertView release];

	[super dealloc];
}

@end