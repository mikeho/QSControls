/**
 * QSActivityIndicators.m
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

@implementation QSActivityIndicators


+ (UIAlertView *)displayAsAlertWithText:(NSString *)strText {
	UIAlertView * objView = [[[UIAlertView alloc] initWithTitle:strText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
	[objView show];

	// Create and add the activity indicator
	UIActivityIndicatorView * objWaitIcon = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[objWaitIcon setTag:kWaitScreenSpinner];

	//	objWaitIcon.center = CGPointMake(objAlertView.bounds.size.width / 2.0f, objAlertView.bounds.size.height - 40.0f);
	objWaitIcon.center = CGPointMake(284 / 2.0f, 135 - 40.0f);
	[objWaitIcon startAnimating];
	
	[objView addSubview:objWaitIcon];
	[objWaitIcon release];
	
	
	return objView;
}

+ (UIView *)createFullScreenWithText:(NSString *)strText {
	UIView * objView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
	[objView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
	[objView setTag:kWaitScreenTag];

	UIView * objLabelView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 250) / 2.0,
																	 ([UIScreen mainScreen].bounds.size.height - 180) / 2.0,
																	 250, 180)];
	
	[objLabelView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
	objLabelView.layer.cornerRadius = 10;
	[objView addSubview:objLabelView];

	UILabel * lblText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 140)];
	[lblText setLineBreakMode:UILineBreakModeWordWrap];
	[lblText setNumberOfLines:0];
	[lblText setFont:[UIFont boldSystemFontOfSize:24]];
	[lblText setTextAlignment:UITextAlignmentCenter];
	[lblText setBackgroundColor:[UIColor clearColor]];
	[lblText setTextColor:[UIColor whiteColor]];
	[lblText setText:strText];
	[objLabelView addSubview:lblText];
	
	UIActivityIndicatorView * objWaitIcon = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[objWaitIcon setFrame:CGRectMake((250 - objWaitIcon.frame.size.width) / 2.0,
									  140,
									  objWaitIcon.frame.size.width,
									  objWaitIcon.frame.size.height)];
	[objWaitIcon startAnimating];
	[objLabelView addSubview:objWaitIcon];
	
	return objView;
}

@end
