//
//  ActivityIndicators.h
//  iVQ
//
//  Created by Mike Ho on 9/24/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface ActivityIndicators : NSObject {

}

+ (UIAlertView *)displayAsAlertWithText:(NSString *)strText;
+ (UIView *)createFullScreenWithText:(NSString *)strText;
@end
