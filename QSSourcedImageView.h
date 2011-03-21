//
//  QSSourcedImageView.h
//  NextManga
//
//  Created by Mike Ho on 3/15/11.
//  Copyright 2011 Quasidea Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSHttpClient.h"

@interface QSSourcedImageView : UIImageView <QSHttpClientDelegate> {
	NSString * _strLocalPath;
	NSString * _strUrl;
	NSString * _strNullImageName;
	NSString * _strInvalidImageName;
}

-(QSSourcedImageView *)initWithPath:(NSString *)strPath Url:(NSString *)strUrl NullImageName:(NSString *)strNullImageName InvalidImageName:(NSString *)strInvalidImageName;
@end
