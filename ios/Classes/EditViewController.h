//
//  EditViewController.h
//  try2
//
//  Created by x on 2/1/11.
//  Copyright 2011 Turbo Spring. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditViewControllerDelegate;


@interface EditViewController : UIViewController {
	id <EditViewControllerDelegate> delegate;

	IBOutlet UITextField *txtIP;
	IBOutlet UITextField *txtName;

	NSString *computerIP;
	NSString *computerName;

	NSInteger editRow;
}

- (IBAction)saveClick:(id)sender;
- (IBAction)cancelClick:(id)sender;


@property (retain) NSString *computerIP;
@property (retain) NSString *computerName;
@property (nonatomic) NSInteger editRow;

@property (nonatomic, assign) id <EditViewControllerDelegate> delegate;
@end

@protocol EditViewControllerDelegate
- (void)editViewControllerDidFinish:(EditViewController *)controller;
@end

