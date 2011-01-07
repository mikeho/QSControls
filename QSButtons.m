/**
 * QSButtons.m
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

@implementation QSButtons

+ (void)setToMultiline:(UIButton *)btnButton {
	[[btnButton titleLabel] setLineBreakMode:UILineBreakModeWordWrap];
	[[btnButton titleLabel] setFont:[UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]]];
	[[btnButton titleLabel] setTextAlignment:UITextAlignmentCenter];
}

+ (UIButton *) createButtonWithText:(NSString *)strText Background:(NSInteger)intType Width:(NSInteger)intWidth Top:(NSInteger)intTop {
	CGRect objFrame;
	if (intWidth) {
		objFrame = CGRectMake(([UIScreen mainScreen].bounds.size.width - intWidth) / 2.0, intTop,intWidth, 40);
	} else {
		objFrame = CGRectMake(kSideMargin, intTop, [UIScreen mainScreen].bounds.size.width - kSideMargin*2, 40);
	}

	return [Buttons createButtonWithText:strText Background:intType Frame:objFrame];
}

+ (void)setHeight:(CGFloat)fltHeight ForButton:(UIButton *)btnButton {
	CGRect objFrame = CGRectMake(btnButton.frame.origin.x, btnButton.frame.origin.y, btnButton.frame.size.width, fltHeight);
	[btnButton setFrame:objFrame];
}

+ (UIButton *) createButtonWithText:(NSString *)strText Background:(NSInteger)intType Frame:(CGRect)objFrame {
	UIButton * btnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnButton setFrame:objFrame];
	[btnButton setTitle:strText forState:UIControlStateNormal];

	switch (intType) {
		case ButtonBackgroundTypeGreen:
			[btnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[btnButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
			break;
			
		case ButtonBackgroundTypeRed:
			[btnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[btnButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
			break;

		case ButtonBackgroundTypeWhite:
			break;
			
		case ButtonBackgroundTypeGrey:
			[btnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			[btnButton setBackgroundImage:[[UIImage imageNamed:@"greyButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
			break;
			
		default:
			NSAssert1(false, @"Invalid ButtonBackgroundType: %d", intType);
			break;
	}

	return btnButton;
}

@end
