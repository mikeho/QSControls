/**
 * QSModalHttpClient.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface QSModalHttpClient : NSObject {
@private
	NSString * _strUrl;
	NSString * _strHttpMethod;
	NSInteger _intTimeoutInterval;
	
	NSString * _strMessage;
	NSString * _strMessageDuringUpload;

	NSInteger _intHttpStatusCode;
	NSMutableData * _objResponseData;

	NSInteger _intRequestDataSize;
	NSInteger _intResponseDataSize;
	UIAlertView * _objAlertView;
}

@property (nonatomic, retain, getter=url, setter=setUrl) NSString * _strUrl;
@property (nonatomic, retain, getter=httpMethod, setter=setHttpMethod) NSString * _strHttpMethod;
@property (nonatomic, assign, getter=timeoutInterval, setter=setTimeoutInterval) NSInteger _intTimeoutInterval;

@property (nonatomic, retain, getter=message, setter=setMessage) NSString * _strMessage;
@property (nonatomic, retain, getter=messageDuringUpload, setter=setMessageDuringUpload) NSString * _strMessageDuringUpload;

@property (nonatomic, assign, getter=httpStatusCode) NSInteger _intHttpStatusCode;
@property (nonatomic, retain, getter=responseData) NSData * _objResponseData;

- (QSModalHttpClient *)initWithUrl:(NSString *)strUrl HttpMethod:(NSString *)strHttpMethod;

- (void)cleanupFromPreviousRequests;

- (bool)sendString:(NSString *)strRequest;
- (bool)sendFile:(NSString *)strFilePath;

- (NSString *)getResponseAsString;
- (NSData *)getResponseAsRawData;

@end
