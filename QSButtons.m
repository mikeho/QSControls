//
//  Buttons.m
//  iVQ
//
//  Created by Mike Ho on 9/24/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import "Buttons.h"
#import "Constants.h"


@implementation Buttons

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
