//
//  Buttons.h
//  iVQ
//
//  Created by Mike Ho on 9/24/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum ButtonBackgroundType {
	ButtonBackgroundTypeWhite,
	ButtonBackgroundTypeGrey,
	ButtonBackgroundTypeGreen,
	ButtonBackgroundTypeRed
};

@interface Buttons : NSObject {

}
+ (void)setHeight:(CGFloat)fltHeight ForButton:(UIButton *)btnButton;
+ (UIButton *)createButtonWithText:(NSString *)strText Background:(NSInteger)intType Frame:(CGRect)objFrame;
+ (UIButton *)createButtonWithText:(NSString *)strText Background:(NSInteger)intType Width:(NSInteger)intWidth Top:(NSInteger)intTop;
+ (void)setToMultiline:(UIButton *)btnButton;

@end
