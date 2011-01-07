//
//  ActivityIndicators.m
//  iVQ
//
//  Created by Mike Ho on 9/24/10.
//  Copyright 2010 Quasidea Development, LLC. All rights reserved.
//

#import "ActivityIndicators.h"
#import "Constants.h"

@implementation ActivityIndicators


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
