//
//  EditViewController.m
//  try2
//
//  Created by x on 2/1/11.
//  Copyright 2011 Turbo Spring. All rights reserved.
//

#import "EditViewController.h"


@implementation EditViewController

@synthesize delegate;
@synthesize computerName;
@synthesize computerIP;
@synthesize editRow;


- (void)viewDidLoad {
    [super viewDidLoad];

	//NSLog( @"Editing row #%d", editRow );
	// -1 passed to this value means we are making a new row!
	if( editRow != -1 ){
		txtIP.text = computerIP;
		txtName.text = computerName;
	}
}


- (IBAction)done:(id)sender {
	[self.delegate editViewControllerDidFinish:self];
}



- (IBAction)saveClick:(id)sender {
	computerIP = txtIP.text;
	computerName = txtName.text;
	// 'edits' is not modified here, but it will be read by the delegate
   [self.delegate editViewControllerDidFinish:self];
	
}
	
- (IBAction)cancelClick:(id)sender {
	computerIP = @"";
	computerName = @"";
	
	[self.delegate editViewControllerDidFinish:self];

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
