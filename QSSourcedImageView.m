//
//  QSSourcedImageView.m
//  NextManga
//
//  Created by Mike Ho on 3/15/11.
//  Copyright 2011 Quasidea Development, LLC. All rights reserved.
//

#import "QSControls.h"

@implementation QSSourcedImageView

- (QSSourcedImageView *)initWithPath:(NSString *)strPath Url:(NSString *)strUrl NullImageName:(NSString *)strNullImageName InvalidImageName:(NSString *)strInvalidImageName {
	UIImage * imgToUse;
	if ([[NSFileManager defaultManager] fileExistsAtPath:strPath isDirectory:false]) {
		imgToUse = [UIImage imageWithContentsOfFile:strPath];
	} else {
		imgToUse = [UIImage imageNamed:strNullImageName];
	}

	if ([super initWithImage:imgToUse]) {
		_strLocalPath = strPath;
		_strUrl = strUrl;
		_strNullImageName = strNullImageName;
		_strInvalidImageName = strInvalidImageName;
		
		[_strLocalPath retain];
		[_strUrl retain];
		[_strNullImageName retain];
		[_strInvalidImageName retain];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:strPath isDirectory:false]) {
			// Go Ahead and Download the Image
			_objHttpClient = [(QSHttpClient *)[QSHttpClient alloc] initWithUrl:strUrl HttpMethod:@"GET"];
			[_objHttpClient setDelegate:self];
			[_objHttpClient sendString:@""];
		}
		
		return self;
	}

	return nil;
}

- (void)httpClient:(QSHttpClient *)objHttpClient ErrorReceived:(NSString *)strError {
	[self setImage:[UIImage imageNamed:_strInvalidImageName]];
	[_objHttpClient setDelegate:nil];
	[_objHttpClient release];
	_objHttpClient = nil;
}

- (void)httpClientResponseReceived:(QSHttpClient *)objHttpClient {
	[[NSFileManager defaultManager] createFileAtPath:_strLocalPath contents:[objHttpClient getResponseAsRawData] attributes:nil];
	[self setImage:[UIImage imageWithContentsOfFile:_strLocalPath]];
	[_objHttpClient setDelegate:nil];
	[_objHttpClient release];
	_objHttpClient = nil;
}

-(void)dealloc {
	[_strLocalPath release];
	[_strUrl release];
	[_strNullImageName release];
	[_strInvalidImageName release];
	if (_objHttpClient) {
		[_objHttpClient setDelegate:nil];
		[_objHttpClient release];
		_objHttpClient = nil;
	}
	[super dealloc];
}

@end

