//
//  FlipsideViewController.h
//  try2
//
//  Created by x on 2/1/11.
//  Copyright 2011 Turbo Spring. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController {
	id <FlipsideViewControllerDelegate> delegate;
	IBOutlet UIButton* doneBtn;
	IBOutlet UIButton* pauseBtn;
	IBOutlet UIButton* playBtn;
	IBOutlet UIButton* fwdBtn;
	IBOutlet UIButton* bckBtn;
	
	//IBOutlet UITextField *txtInstant;
	//IBOutlet UITextField *txtStatus;

	IBOutlet UINavigationBar *navBarStatus;
	
	IBOutlet UISlider *volumeSlider;
	IBOutlet UISlider *progressSlider;
	
	IBOutlet UISwitch *fullscreenSwitch;
	IBOutlet UISwitch *enableSeekSwitch;
	IBOutlet UILabel *enableSeekLabel;
	IBOutlet UILabel *seekLeftLabel;
	IBOutlet UILabel *seekRightLabel;
	IBOutlet UILabel *seekLabel;
	IBOutlet UILabel *seekHelpLabel;

	
	NSString *computerIP;

	UIImageView *splashView2;
	
	IBOutlet UIActivityIndicatorView *flipBeachball;
	
}

@property (retain) NSString *computerIP;
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;  
@property (nonatomic, retain) IBOutlet UISlider *progressSlider;  

- (IBAction)connect:(id)sender;
- (void)con;

- (IBAction)stopPlaybackBtn:(id)sender;
- (IBAction)playPlaybackBtn:(id)sender;
- (IBAction)fullscreenSwitchChanged:(id)sender;
- (IBAction)enableSeekSwitchChanged:(id)sender;
- (IBAction)fwdBtnPress:(id)sender;
- (IBAction)bckBtnPress:(id)sender;
- (IBAction)volumeChanged:(id)sender;
- (IBAction)progressChangedTouchUp:(id)sender;


- (void) tick;
- (void) returnToMainView;

// -------------------- FORWARD DEC ---------------------------
/*
LXSocket* socket;// = [[LXSocket alloc] init]
extern int state;
extern int running;
extern short intBuffer[5];
extern int globalCommand;
*/



@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

