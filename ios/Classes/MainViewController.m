//
//  MainViewController.m
//  try2
//
//  Created by x on 2/1/11.
//  Copyright 2011 Turbo Spring. All rights reserved.
//

#import "MainViewController.h"
#import "DataController.h"


@implementation MainViewController
@synthesize dataController;
@synthesize discoveredIP;

#define PRESS_EDIT_TEXT @"Press 'Edit' to add..."
#define PRESS_HERE_TEXT @"<--- Press here to add"

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 
- (void)viewDidLoad 
 {
 // what does this do?
 self.navigationItem.leftBarButtonItem = self.editButtonItem;


 // this function will load settings if they exist!	 
 self.dataController = [[DataController alloc] init];
 
	 
 tblSimpleTable.editing = NO;
 tblSimpleTable.allowsSelectionDuringEditing = YES;

 	 
 // launch function to hit url
 // this will return asynchronously
 [self getWebFetch];
	
 editTextMode = 0;
 discoverdCount = 0;
 
 }

#pragma mark --------------- Switch To Flipside Page -----------------
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (void)showFlipside:(NSString*)ip {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	NSLog(@"Connecting to:");
	NSLog(ip);
//	[dataController objectInListAtIndex:2];
	//NSLog(@"in flipside");
	//NSLog([dataController ipInListAtIndex:arrayIndex]);
//	NSLog(@"%s", [self ipInListAtIndex:arrayIndex]+1);
	// don't use offset here
	
	controller.computerIP = ip;//[dataController ipInListAtIndex:arrayIndex];	
//	controller.computerIP = [self ipInListAtIndex:arrayIndex];
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



- (void)dealloc {
    [super dealloc];
}



#pragma mark Table view methods


/*
- (id)initWithStyle:(UITableViewStyle)style 
{
    if (self = [super initWithStyle:style]) 
	{
        self.title = NSLocalizedString(@"List Title", @"Master view navigation title");
		self.dataController = [[DataController alloc] init];
    }
    return self;
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Only one section so return the number of items in the list
	
	// +1 for first row, + # of discovered computers
    return [dataController countOfList]+ 1 + discoverdCount;
}

// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Get the object to display and set the value in the cell
	switch( indexPath.row )
	{
		case 0:
			if( editTextMode )
				cell.text  = PRESS_HERE_TEXT;
			else
				cell.text  = PRESS_EDIT_TEXT;	
			break;
		default:
			//NSLog( @"for entry %d, list length %d",indexPath.row, [dataController countOfList] );
			if( indexPath.row > [dataController countOfList] )
			{
				// use stringWithFormat, epic cousin to sprintf(), to add a star to the ip string
				// The star * character is followed by %@ which is used instead of %s
				NSString *discoveredIPStar = [NSString stringWithFormat: @"*%@", discoveredIP];
				cell.text = discoveredIPStar;
				//[discoveredIPStar release];
			}
			else
			{
				cell.text = [dataController objectInListAtIndex:indexPath.row-1];	
			}
			break;			
	}

	
	return cell;
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row == 0)
	{
		return UITableViewCellEditingStyleInsert;
	}
	else
	{
		return UITableViewCellEditingStyleDelete;
	}
}

/*
- (void)setBackgroundImage {
	UIImageView *customBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainScreenBg.jpg"]];
	self.background = customBackground;
	[customBackground release];
	
	[self addSubview:background];
	NSLog(@"Added background subview %@", background);
	[self sendSubviewToBack:background];
}*/



- (IBAction)editClick:(id)sender
{
	if( tblSimpleTable.editing == YES )
	{
		tblSimpleTable.editing = NO;	
		editTextMode = 0;
		[self saveSettings];
	}else
	{
		tblSimpleTable.editing = YES;
		editTextMode = 1;
	}
	[tblSimpleTable reloadData];
    	
}


#define DATA_OFFSET(i) ((i)-1)
#define REVERSE_DATA_OFFSET(i) ((i)+1)

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// If row is deleted, remove it from the list.
	if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		// if deleting the autodetected computer
		if( indexPath.row == REVERSE_DATA_OFFSET( [dataController countOfList] ) )
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Autodetected Computer" message:@"This computer was automatically detected on your network.  This entry cannot be deleted."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
			
			[tblSimpleTable reloadData];
			return;
		}
		
		NSLog(@"Deleting Element");
        [dataController removeDataAtIndex:DATA_OFFSET(indexPath.row)];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		//[self.tableView reloadData];
    }
	else if(editingStyle == UITableViewCellEditingStyleInsert)
	{
		[self showEditPage];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Create the detail view controller and set its inspected item to the currently-selected item
    
	UIAlertView *alert;
	
	if( tblSimpleTable.editing == YES )
	{
		NSLog(@"Flip to edit view for exiting item");

		if(indexPath.row == 0)
		{
			[self showEditPage];
			return;
		}
		
		// if pressing the autodetected computer in edit mode
		if( indexPath.row == REVERSE_DATA_OFFSET( [dataController countOfList] ) )
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Autodetected Computer" message:@"This computer was automatically detected on your network.  This entry cannot be edited."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		
			return;
		}
		
		[self showEditPageWithEdit:indexPath.row];
	}
	else
	{	
	
		if(indexPath.row == 0)
		{
			// for now do nothing if tapping main row (easter egg here?)
			return;
		}
	
		if( indexPath.row > [dataController countOfList] )
		{
			[self showFlipside:discoveredIP];
		}
		else
		{
			// put offset here
			NSString *ipInList = [dataController ipInListAtIndex:DATA_OFFSET(indexPath.row)];
			[self showFlipside:ipInList];
		}
	}
	
}


- (void)helpViewControllerDidFinish:(HelpViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark --------------- Switch To Edit Page -----------------

/*!
 This function fires when the edit page returns.
 The edit page has 3 member variables: computerName, computerIP.
 This data is transfered to the mainView by this funciton.
   It simply adds these values to the dataController, at which
point the originals are destroyed (maybe?) with the edit view.
*/
- (void)editViewControllerDidFinish:(EditViewController *)controller {
	// 
	
	if( controller.editRow == -1 )
	{
		// only add to list if name is non empty
		if( [controller.computerName isEqualToString:@""] || [controller.computerIP isEqualToString:@""] )
		{
//	name is empty, do nothing
		}
		else
		{
		// add item to list
			[dataController addData:controller.computerName ip:controller.computerIP];
			[tblSimpleTable reloadData];
		
			// save list to prefs
			[self saveSettings];
		}
	}
	else
	{
        //if name and ip are both not empty
		if( !(controller.computerName == @"" && controller.computerIP == @"") )
		{
			[dataController updatePairInList:DATA_OFFSET(controller.editRow) data:controller.computerName ip:controller.computerIP];
		
			[self saveSettings];
		}
	}

	
	// switch text back
	editTextMode = 0;
	

	
	// exit edit mode
	tblSimpleTable.editing = NO;
	
	
	// always update label (regardless if cancel or save wuz clicked)
	[tblSimpleTable reloadData];

	
	[self dismissModalViewControllerAnimated:YES];
}


- (void)showEditPage {    
    // Not needed but this method of NSLog is nice :)
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	EditViewController *controller = [[EditViewController alloc] initWithNibName:@"EditView" bundle:nil];
	controller.delegate = self;
	// pass in a -1 and we will get a new entry
	controller.editRow = -1;
	
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (void)showEditPageWithEdit:(int)editingRow{    
    // Not needed but this method of NSLog is nice :)
//	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);

	
	// pull the data for the row to edit
	NSString *ipInList = [dataController ipInListAtIndex:DATA_OFFSET(editingRow)];
	NSString *nameInList = [dataController objectInListAtIndex:DATA_OFFSET(editingRow)];
	
	
	EditViewController *controller = [[EditViewController alloc] initWithNibName:@"EditView" bundle:nil];
	controller.delegate = self;

	controller.computerIP = ipInList;
	controller.computerName = nameInList;
	
	// this tells the other page that we are adding a new entry.
	// (if we pass in a -1 value we will get a new entry instead)
	controller.editRow = editingRow;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction)displayHelpFromMain:(id)sender {
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Help!" message:@"This application requires the Remote4Netflix client to be installed on your PC Computer. Visit: www.netflix-remote.com\n\nIf you see an IP address\n(aka *1.2.3.4)\npress it to connect."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	//[alert show];
	//[alert release];

	HelpViewController *controller = [[HelpViewController alloc] initWithNibName:@"HelpView" bundle:nil];
	controller.delegate = self;

	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];

}


#pragma mark ---------------- Web Fetcher -------------------

- (IBAction)checkMagicIPAgain:(id)sender {
	txtDiscoveredIP.text = @"Refreshing...";
	[self getWebFetch];
}

#define IOS_MAGIC_URL @"http://netflix-remote.me/ios.php"
- (void) getWebFetch {
	responseData = [[NSMutableData data] retain];
    baseURL = [[NSURL URLWithString:IOS_MAGIC_URL] retain];
	
    NSURLRequest *request =
	[NSURLRequest requestWithURL:[NSURL URLWithString:IOS_MAGIC_URL]];
    [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
	
	mainBeachball.hidesWhenStopped = true;
	[mainBeachball startAnimating];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[mainBeachball stopAnimating];
//    [[NSAlert alertWithError:error] runModal];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
      // Once this method is invoked, "responseData" contains the complete result
	
//	NSString *serverIP;
//	serverIP = txtDiscoveredIP.text;
	
//	responseData
	NSString *bodyText = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];

	BOOL flagFail = false;
	
	// On some networks, requests are redirected to a login page
	// the chance of this page being longer than N chars is 100%
	if([bodyText length] > 100) {
		txtDiscoveredIP.text = @"Bad Internet Connection";
		discoverdCount = 0;
		flagFail = true;
	}
	else
	{
	
		if ([bodyText isEqualToString:@"no"]) {	
	
			txtDiscoveredIP.text = @"No correclty configured computers detected!";
			discoverdCount = 0;
		
			flagFail = true;		
		}
		else
		{
			txtDiscoveredIP.text = [NSString stringWithFormat:@"Autodetected Computer: *%@", bodyText];
			discoveredIP = bodyText;
			discoverdCount = 1;
		}
	}
	
	if( flagFail )
	{
		// if not discovered, retry again in N seconds
		[self performSelector:@selector(getWebFetch) withObject:self afterDelay:5.0];
	}
	[tblSimpleTable reloadData];
	[mainBeachball stopAnimating];
}


- (NSURLRequest *)connection:(NSURLConnection *)connection
			 willSendRequest:(NSURLRequest *)request
			redirectResponse:(NSURLResponse *)redirectResponse
{
    [baseURL autorelease];
    baseURL = [[request URL] retain];
    return request;
}


#pragma mark ------------------Save/Load Settings------------------

/*
-(void)loadSettings{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

	dataController.listIP = [[prefs objectForKey:@"listIP"] mutableCopy];
	dataController.listName = [[prefs objectForKey:@"listName"] mutableCopy];

	[tblSimpleTable reloadData];
}
*/

-(void)saveSettings {
	
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:dataController.listIP forKey:@"listIP"];
	[prefs setObject:dataController.listName forKey:@"listName"];
	
	[prefs synchronize];
}

@end
