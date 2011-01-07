//
//  Labels.m
//  iVQ
//
//  Created by Mike Ho on 9/28/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//


#import "Labels.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@implementation Labels

+ (void)trimFrameHeightForLabel:(UILabel *)lblLabel {
	CGSize objNewSize = [lblLabel.text sizeWithFont:lblLabel.font
								  constrainedToSize:lblLabel.frame.size
									  lineBreakMode:lblLabel.lineBreakMode];
	
	CGRect objNewFrame = CGRectMake(lblLabel.frame.origin.x, lblLabel.frame.origin.y, lblLabel.frame.size.width, objNewSize.height);
	
	[lblLabel setFrame:objNewFrame];
}

+ (void)trimFrameHeightForLabel:(UILabel *)lblLabel WithMinHeight:(CGFloat)fltMinHeight {
	CGSize objNewSize = [lblLabel.text sizeWithFont:lblLabel.font
								  constrainedToSize:lblLabel.frame.size
									  lineBreakMode:lblLabel.lineBreakMode];
	
	CGRect objNewFrame = CGRectMake(lblLabel.frame.origin.x, lblLabel.frame.origin.y, lblLabel.frame.size.width,
									fmax(fltMinHeight, objNewSize.height));
	
	[lblLabel setFrame:objNewFrame];
}

+ (CGFloat)addLabelTextPairForView:(UIView *)objView AtCurrentY:(CGFloat)fltCurrentY WithTitleText:(NSString *)strTitle ContentText:(NSString *)strContent {
	// Setup the Title Label
	UILabel * lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(kSideMargin, fltCurrentY, [UIScreen mainScreen].bounds.size.width - kSideMargin * 2, 18)];
	[lblTitle setFont:[UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]]];
	[lblTitle setTextColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.6 alpha:1.0]];
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	[lblTitle setText:strTitle];

	// Add it to the View
	[lblTitle autorelease];
	[objView addSubview:lblTitle];

	// Set up the Content Background Panel
	UIView * pnlContent = [[UIView alloc] initWithFrame:CGRectMake(kSideMargin * 3, fltCurrentY + 18, [UIScreen mainScreen].bounds.size.width - kSideMargin * 4, 200)];
	[pnlContent setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
	[pnlContent.layer setCornerRadius:5];
	[pnlContent.layer setMasksToBounds:true];

	// Add it to the View
	[pnlContent autorelease];
	[objView addSubview:pnlContent];
	
	// Set up the Content Text
	UILabel * lblContent = [[UILabel alloc] initWithFrame:CGRectMake(kSideMargin, kTopMargin / 2, [UIScreen mainScreen].bounds.size.width - kSideMargin * 6, 200)];
	[lblContent setLineBreakMode:UILineBreakModeWordWrap];
	[lblContent setNumberOfLines:0];
	[lblContent setText:strContent];
	[lblContent setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
	[lblContent setBackgroundColor:[UIColor clearColor]];
	[Labels trimFrameHeightForLabel:lblContent];

	// Add it to the Content Background Panel
	[lblContent autorelease];
	[pnlContent addSubview:lblContent];
	
	// Calculate the Correct Height for the Content Background Panel
	CGRect objNewFrame = CGRectMake(pnlContent.frame.origin.x, pnlContent.frame.origin.y, pnlContent.frame.size.width, lblContent.frame.size.height + kTopMargin);
	[pnlContent setFrame:objNewFrame];

	// Update fltCurrentY and Return It
	fltCurrentY += 18 + pnlContent.frame.size.height + kTopMargin;
	return fltCurrentY;
}
@end
