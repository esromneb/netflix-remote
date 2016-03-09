//
//  HelpViewController.h
//  try2
//
//  Created by x on 2/1/11.
//  Copyright 2011 Turbo Spring. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HelpViewControllerDelegate;


@interface HelpViewController : UIViewController {
	id <HelpViewControllerDelegate> delegate;

	IBOutlet UIWebView *helpWebView;
}

- (IBAction)done:(id)sender;


@property (nonatomic, assign) id <HelpViewControllerDelegate> delegate;
@end

@protocol HelpViewControllerDelegate
- (void)helpViewControllerDidFinish:(HelpViewController *)controller;
@end

