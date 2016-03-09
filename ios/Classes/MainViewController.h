//
//  MainViewController.h
//  try2
//
//  Created by x on 2/1/11.
//  Copyright 2011 Turbo Spring. All rights reserved.
//

#import "FlipsideViewController.h"
#import "EditViewController.h"
#import "HelpViewController.h"
#import <UIKit/UIKit.h>


@class DataController;

// The ViewControllerDelegate(s) below inside <> are not needed.
@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, EditViewControllerDelegate, HelpViewControllerDelegate> {

	IBOutlet UITableView *tblSimpleTable;
	DataController *dataController;
	
	IBOutlet UITextField *txtDiscoveredIP;
	
	NSMutableData *responseData;
	NSURL *baseURL;
	int editTextMode;

	NSString *discoveredIP;
	unsigned discoverdCount;
	
	IBOutlet UIActivityIndicatorView *mainBeachball;
}

- (IBAction)checkMagicIPAgain:(id)sender;
- (IBAction)editClick:(id)sender;
- (void)showFlipside:(NSString*)ip;
- (void)showEditPage;

- (IBAction)displayHelpFromMain:(id)sender;

- (void) getWebFetch;
- (void)saveSettings;
//- (void)loadSettings;

@property (nonatomic, retain) DataController *dataController;
@property (retain) NSString *discoveredIP;

// suggested but not needed:
//   http://www.iphonedevsdk.com/forum/iphone-sdk-development/4134-handle-keyboard-done-press-text-field.html
//@property (nonatomic, retain) IBOutlet UITextField * txtIPAddr;

- (void)helpViewControllerDidFinish:(HelpViewController *)controller;

//@property(readwrite, assign) int firstName;
	

@end
