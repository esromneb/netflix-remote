//
//  FlipsideViewController.m
//  try2
//
//  Created by x on 2/1/11.
//  Copyright 2011 Turbo Spring. All rights reserved.
//

#import "GlobalDefines.h"
#import "FlipsideViewController.h"
#import "MyNetwork.h"


@implementation FlipsideViewController

@synthesize delegate;
@synthesize computerIP;
@synthesize progressSlider;
@synthesize volumeSlider;


static MyNetwork* networking;
static int state = 0;
static int running = 0;
static short intBuffer[5];
static int globalCommand;
static int globalVolume;
static int globalReadBackCommand;
static int globalReadBackParam;
static int globalReadBackParam2;

static double globalSeekDouble;



- (void)viewDidLoad {
	state = 0;
	running = 0;
	
	volumeSlider.transform = CGAffineTransformRotate(volumeSlider.transform, 270.0/180*M_PI);
	
	[self fullscreenDisableUIFade];
	
//    [super viewDidLoad];
//    self.view.backgroundColor =	[UIColor colorWithPatternImage:[UIImage imageNamed:@"griddything.png"]];
	
	
	
//    txtIPAddr.text = self.computerIP;
	[self con];
}

- (void) returnToMainView {
	running = 0;
	[networking StopNetworking];
	[self.delegate flipsideViewControllerDidFinish:self];		
}

- (IBAction)done:(id)sender {
	[self returnToMainView];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}


// --------------------------- IB ACTIONS -----------------------

// Show the play button
- (void) useStopGraphics
{
	//	[playBtn setHidden:FALSE];
	//	[pauseBtn setHidden:TRUE];
	playBtn.userInteractionEnabled = TRUE;
	pauseBtn.userInteractionEnabled = FALSE;

	
	[UIView beginAnimations:@"theAnimation" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.1];
	[pauseBtn setAlpha:0.0];
	[playBtn setAlpha:1.0];
	[UIView commitAnimations];	
	
	// [NSThread sleepForTimeInterval:5.0]; doesnt work cuz it freezes the button in the pressed state

}


// Show the Pause Button
- (void) usePlayGraphics
{
	//[playBtn setHidden:TRUE];
	//[pauseBtn setHidden:FALSE];
	playBtn.userInteractionEnabled = FALSE;
	pauseBtn.userInteractionEnabled = TRUE;
	
	[UIView beginAnimations:@"theAnimation" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.1];
	[playBtn setAlpha:0.0];
	[pauseBtn setAlpha:1.0];
	[UIView commitAnimations];	
}

#pragma mark ---------------Sliders ----------------------
- (IBAction) volumeChanged:(UISlider *)sender {
	float fvol = [sender value];
	int intvol = fvol*100;
	
	globalCommand = 6;
	globalVolume = intvol;
		
//	[self setVolume];
	//NSLog(@"%d", intvol);
//    myTextField.text = [NSString stringWithFormat:@"%.1f", [sender value]];  
}
- (void) setVolume
{
	globalVolume = MIN(globalVolume,100);
	globalVolume = MAX(globalVolume,0);
	float fval = globalVolume;
	volumeSlider.value = fval/100;
}

- (void) setSeek
{
	globalSeekDouble = MIN(globalSeekDouble,1.0);
	globalSeekDouble = MAX(globalSeekDouble,0.0);
	progressSlider.value = globalSeekDouble;
}

- (void) progressChangedTouchUp:(UISlider *)sender
{
	NSLog(@"touch up with float %f", [sender value]);
	float fsk = [sender value];
	globalCommand = 7;
	globalSeekDouble = fsk;
}

// update pause/play state according to what AHK said
- (void) setPausePlay:(int)val
{
	if( val == 0x21 )
	{
		[self useStopGraphics];
	}
	if( val == 0x22 )
	{
		[self usePlayGraphics];
	}
}

#pragma mark ---------------Fullscreen Shenanigans----------------

- (void)fullscreenDisableUIFade
{
	[enableSeekSwitch setAlpha:1.0];
	[enableSeekLabel setAlpha:1.0];
	[seekHelpLabel setAlpha:1.0];
	
	[UIView beginAnimations:@"theAnimation" context:NULL];
	[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(yourAnimationHasFinished:finished:context:)];
	[UIView setAnimationDuration:0.7];
	[enableSeekSwitch setAlpha:0.0];
	[enableSeekLabel setAlpha:0.0];
	[seekHelpLabel setAlpha:0.0];
	[UIView commitAnimations];	
}

- (void)fullscreenEnableUIFade
{
	[enableSeekSwitch setAlpha:0.0];
	[enableSeekLabel setAlpha:0.0];
	[seekHelpLabel setAlpha:0.0];
	
	[UIView beginAnimations:@"theAnimation" context:NULL];
	[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(yourAnimationHasFinished:finished:context:)];
	[UIView setAnimationDuration:0.7];
	[enableSeekSwitch setAlpha:1.0];
	[enableSeekLabel setAlpha:1.0];
	[seekHelpLabel setAlpha:1.0];
	[UIView commitAnimations];	
}

#define SEEK_DISABLED_ALPHA 0.15

- (void)seekDisableUIFade
{
	progressSlider.userInteractionEnabled = FALSE;
	seekLeftLabel.userInteractionEnabled = FALSE;
	seekRightLabel.userInteractionEnabled = FALSE;
	seekLabel.userInteractionEnabled = FALSE;
	fwdBtn.userInteractionEnabled = FALSE;
	bckBtn.userInteractionEnabled = FALSE;
	[progressSlider setAlpha:1.0];
	[seekLeftLabel setAlpha:1.0];
	[seekRightLabel setAlpha:1.0];
	[seekLabel setAlpha:1.0];
	[fwdBtn setAlpha:1.0];
	[bckBtn setAlpha:1.0];

	
	[UIView beginAnimations:@"theAnimation" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.7];
	[progressSlider setAlpha:SEEK_DISABLED_ALPHA];
	[seekLeftLabel setAlpha:SEEK_DISABLED_ALPHA];
	[seekRightLabel setAlpha:SEEK_DISABLED_ALPHA];
	[seekLabel setAlpha:SEEK_DISABLED_ALPHA];
	[fwdBtn setAlpha:SEEK_DISABLED_ALPHA];
	[bckBtn setAlpha:SEEK_DISABLED_ALPHA];
	[UIView commitAnimations];	
}

- (void)seekEnableUIFade
{
	progressSlider.userInteractionEnabled = TRUE;
	seekLeftLabel.userInteractionEnabled = TRUE;
	seekRightLabel.userInteractionEnabled = TRUE;
	seekLabel.userInteractionEnabled = TRUE;
	fwdBtn.userInteractionEnabled = TRUE;
	bckBtn.userInteractionEnabled = TRUE;
	[progressSlider setAlpha:SEEK_DISABLED_ALPHA];
	[seekLeftLabel setAlpha:SEEK_DISABLED_ALPHA];
	[seekRightLabel setAlpha:SEEK_DISABLED_ALPHA];
	[seekLabel setAlpha:SEEK_DISABLED_ALPHA];
	[fwdBtn setAlpha:SEEK_DISABLED_ALPHA];
	[bckBtn setAlpha:SEEK_DISABLED_ALPHA];
	
	[UIView beginAnimations:@"theAnimation" context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.7];
	[progressSlider setAlpha:1.0];
	[seekLeftLabel setAlpha:1.0];
	[seekRightLabel setAlpha:1.0];
	[seekLabel setAlpha:1.0];
	[fwdBtn setAlpha:1.0];
	[bckBtn setAlpha:1.0];
	[UIView commitAnimations];	
}

//- (void)yourAnimationHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
//{
//	//[saveButton setHidden:NO];
//}


#pragma mark ---------------Command Stubs-----------------
- (IBAction)stopPlaybackBtn:(id)sender
{
	globalCommand = 1;
	[self useStopGraphics];

}
- (IBAction)playPlaybackBtn:(id)sender
{
	globalCommand = 2;
	[self usePlayGraphics];	
}

- (IBAction)fullscreenSwitchChanged:(id)sender
{
	if( fullscreenSwitch.on )
	{
		// fade fullscreen elements
		[self fullscreenEnableUIFade];
		
		// with fullscreen off, all ui elements must be visible
		// because of this, we need to check the state of enableseek switch such that
		// ui will fade according to position of switch
		if( !enableSeekSwitch.on )
		{
			[self seekDisableUIFade];
		}

	}
	else
	{
		// fade fullscreen elements
		[self fullscreenDisableUIFade];
		
		// force ui to fade all elements into view, (leaving seek switch position how it was)
		if( !enableSeekSwitch.on )
		{
			[self seekEnableUIFade];
		}
	}

	globalCommand = 3;
}

- (IBAction)enableSeekSwitchChanged:(id)sender
{
	if( enableSeekSwitch.on )
	{
		[self seekEnableUIFade];
		[flipBeachball startAnimating];

		// When we enable seek, it's possible that the movie is in a totally different place
        // AHK handles this by immedaitly reading the seek position
		// After the packets reach IPhone, the seek bar UI jumps to the correct position.
        // This process can take awhile, so we fire off a beachball after
        // an arbitrary time of 1.5 seconds to look like we're busy doing something
		[self performSelector:@selector(startBeachball) withObject:nil afterDelay:1.5];
	}
	else
	{
		[self seekDisableUIFade];
	}
	
	globalCommand = 12;
}

- (IBAction)fwdBtnPress:(id)sender
{
	globalCommand = 4;
}
- (IBAction)bckBtnPress:(id)sender
{
	globalCommand = 5;
}
- (void)requestValues
{
	globalCommand = 8;
}

- (void)con
{
	NSLog(@"clicked");
	globalCommand = 0;
	running = 1;
	[self tick];
}

- (IBAction)connect:(id)sender
{
	NSLog(@"clicked");
	globalCommand = 0;
	running = 1;
	[self tick];
}


// ---------------------------- OTHER ------------------------------


// Allows 'done' button of ipaddr filed to close keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)genericTextBox {
	[genericTextBox resignFirstResponder];	
	return YES;
}


- (BOOL)stopBeachballTimed:(float_t)seconds
{
	[self performSelector:@selector(stopBeachball) withObject:nil afterDelay:seconds];
	//NSLog(@"Delay %f", seconds);
}


- (BOOL)stopBeachball
{
	[flipBeachball stopAnimating];
}

- (BOOL)startBeachball
{
	[flipBeachball startAnimating];
}

#pragma mark ---------------------------- STATE MACHINE ------------------------



- (void) tick {
	char ms, ls;

	switch (state) {
		case 0:
			//txtInstant.text = @"starting.";
			//txtStatus.text = @"Not Connected";
			
			flipBeachball.hidesWhenStopped = true;
			[flipBeachball startAnimating];
			
			networking = [[MyNetwork alloc] init];
			[networking StartNetworking:computerIP];
			
			// if socket was made correctly
			//if( [self setupSocket] )
			// FIXME
			if( TRUE )
			{
				state = 1;
			}
			else
			{
				state = 0;
				running = 0;
				[self performSelector:@selector(returnToMainView) withObject:nil afterDelay:1.0];
			}
			break;
		case 1:
			//txtInstant.text = @"starting..";
			navBarStatus.topItem.title = @"Connecting...";
			state = 2;
			break;
		case 2:
			//txtInstant.text = @"Connecting";
			if( [networking detectHello] )
				state = 3;
			else
				state = 1;
			break;
		case 3:
			//txtInstant.text = @"Responding";
			[networking sendHello];
			// the first command will always be 8, which is readback variables
			globalCommand = 8;
			state = 4;
			[flipBeachball stopAnimating];
			break;
		case 4:
			//txtInstant.text = @"Press a button";
			navBarStatus.topItem.title = @"Press a button!";
			state = 4;
			
			[networking readCommand:&globalReadBackCommand paramBack:&globalReadBackParam paramBack2:&globalReadBackParam2];
			if( globalReadBackCommand != 0 )
			{
				[flipBeachball startAnimating];
				state = 6;
			}
			
			if( globalCommand != 0 )
			{
				[flipBeachball startAnimating];
				NSLog(@"Command: %d", globalCommand);
				state = 5;	
			}
			
			break;
			
		case 5:
			if( globalCommand == 6 )
			{
				NSLog(@"Vol: %d", globalVolume);
	  		    // Use our new Special range to transmit the int in 2 bytes
				ls = [networking TransmitRangeIntLS:globalVolume];
				ms = [networking TransmitRangeIntMS:globalVolume];
			}
			else
			{
			  if( globalCommand == 7 )
			  {
				// Add an offset of 34 to avoid sending characters in the 0-20 range, and space (0x20)

				ls = [networking TransmitRangeFloatLS:globalSeekDouble];
				ms = [networking TransmitRangeFloatMS:globalSeekDouble];
			  }
			  else
			  {
				if( globalCommand == 3)
				{
				  ls = 0x21;
				  ms = 0x21+fullscreenSwitch.on;
				}
				else
				{
				  if( globalCommand == 12 )
				  {
					ls = 0x21;
					ms = 0x21+enableSeekSwitch.on;
				  }
				  else
				  {
				    ls = 0x21;
				    ms = 0x21;
				  }
				}
			  }
			}
			[networking sendCommandBytes:globalCommand param:ms param2:ls];

			globalCommand = 0;
			state = 4;
			[self stopBeachballTimed:1.5];
			break;
		
		case 6:
			 if( globalReadBackCommand == 9 )
			 {
				 globalVolume = [networking ReceiveRangeInt:globalReadBackParam2 LS:globalReadBackParam];
				 NSLog(@"reading bytes %d and %d", globalReadBackParam, globalReadBackParam2);
				 NSLog(@"Got volume of %d", globalVolume);
				 [self setVolume];
			 }
			if( globalReadBackCommand == 10 )
			{
				globalSeekDouble = [networking ReceiveRangeFloat:globalReadBackParam2 LS:globalReadBackParam];
				
				NSLog(@"Got seek of %f %%", globalSeekDouble);
				[self setSeek];
			}
			if ( globalReadBackCommand == 11 )
			{
				NSLog(@"Got play of %d %d", globalReadBackParam, globalReadBackParam2);
				[self setPausePlay: globalReadBackParam];
			}
			globalReadBackCommand = 0;
			globalReadBackParam = 0;
			state = 4;
			[self stopBeachballTimed:1.5];
			break;
			
		default:
			state = 0;
			break;
	}
	
	if( running )
	{
		[self performSelector:@selector(tick) withObject:nil afterDelay:0.1];
	}
}

@end
