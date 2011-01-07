//
//  Labels.h
//  iVQ
//
//  Created by Mike Ho on 9/28/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Labels : NSObject {

}

+ (void)trimFrameHeightForLabel:(UILabel *)lblLabel;
+ (void)trimFrameHeightForLabel:(UILabel *)lblLabel WithMinHeight:(CGFloat)fltMinHeight;
+ (CGFloat)addLabelTextPairForView:(UIView *)objView AtCurrentY:(CGFloat)fltCurrentY WithTitleText:(NSString *)strTitle ContentText:(NSString *)strContent;
@end
