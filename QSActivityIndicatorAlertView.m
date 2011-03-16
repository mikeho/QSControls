/**
 * QSActivityIndicatorAlertView.m
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

static QSActivityIndicatorAlertView * _qsActivityIndicatorAlertView;

@interface QSActivityIndicatorAlertView (private)
- (void)adjustAlertViewSpinner;
@end

@implementation QSActivityIndicatorAlertView

- (QSActivityIndicatorAlertView *)initWithTitle:(NSString *)strTitle Message:(NSString *)strMessage {
	QSActivityIndicatorAlertView * objView = (QSActivityIndicatorAlertView *) [super initWithTitle:strTitle message:strMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[objView setTag:kWaitScreenTag];
	[objView show];
	
	// Create and add the activity indicator
	UIActivityIndicatorView * objWaitIcon = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[objWaitIcon setTag:kWaitScreenSpinner];
	
	objWaitIcon.center = CGPointMake(objView.bounds.size.width / 2.0f, objView.bounds.size.height - 40.0f);
	[objWaitIcon startAnimating];
	
	[objView addSubview:objWaitIcon];
	[objWaitIcon release];

	[self performSelector:@selector(adjustAlertViewSpinner) withObject:nil afterDelay:0.5f];
	return self;
}

- (void)adjustAlertViewSpinner {
	UIActivityIndicatorView * objWaitIcon = (UIActivityIndicatorView *) [self viewWithTag:kWaitScreenSpinner];
	objWaitIcon.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height - 40.0f);	
}

+ (UIAlertView *)displayAsAlertWithText:(NSString *)strText {
	QSActivityIndicatorAlertView * objView = [[QSActivityIndicatorAlertView alloc] initWithTitle:strText Message:nil];
	_qsActivityIndicatorAlertView = objView;
	return objView;
}

+ (void)removeAlert {
	if (_qsActivityIndicatorAlertView) {
		[_qsActivityIndicatorAlertView dismissWithClickedButtonIndex:0 animated:true];
		[_qsActivityIndicatorAlertView release];
		_qsActivityIndicatorAlertView = nil;
	}
}

+ (void)updateMessage:(NSString *)strText {
	if (_qsActivityIndicatorAlertView) {
		[_qsActivityIndicatorAlertView setTitle:strText];
	}
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
