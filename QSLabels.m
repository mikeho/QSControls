/**
 * QSLabels.m
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

@implementation QSLabels

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
	[QSLabels trimFrameHeightForLabel:lblContent];

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
