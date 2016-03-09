//
//  HelpViewController.m
//  try2
//
//  Created by x on 2/1/11.
//  Copyright 2011 Turbo Spring. All rights reserved.
//

#import "HelpViewController.h"


@implementation HelpViewController

@synthesize delegate;


- (void)viewDidLoad {
    [super viewDidLoad];

	
	// FIXME, fallback to a local html help file if we can't get to the internet
	//[helpWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"mainhelp" ofType:@"html"]isDirectory:NO]]];
	
	
	NSURL *url = [NSURL URLWithString: @"http://netflix-remote.info/mobile-help-page/main-help.html"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];	
	[helpWebView loadRequest:requestObj];
}


- (IBAction)done:(id)sender {
	[self.delegate helpViewControllerDidFinish:self];
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

// -------------------- Keyboard Hide Code --------------
// Allows 'done' button of ipaddr filed to close keyboard

- (BOOL)textFieldShouldReturn:(UITextField *)genericTextBox {
	[genericTextBox resignFirstResponder];	
	return YES;
}

@end
