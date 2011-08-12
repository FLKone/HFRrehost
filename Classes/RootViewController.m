//
//  RootViewController.m
//  HFRrehost
//
//  Created by Shasta on 15/10/10.
//  Copyright 2010 FLK. All rights reserved.
//

#import "RootViewController.h"
#import "ASIFormDataRequest.h"
#import "HTMLParser.h"

#import "ImageCellView.h"
#import "UIImageView+WebCache.h"

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation RootViewController

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;
@synthesize overlayViewController, progViewController;
@synthesize tmpCell;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.overlayViewController =
	[[[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil] autorelease];
	
    // as a delegate we will be notified when pictures are taken and when to dismiss the image picker
    self.overlayViewController.delegate = self;

    self.progViewController =
	[[[ProgressView alloc] initWithNibName:@"ProgressView" bundle:nil] autorelease];
		
    // Set up the edit and add buttons.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
	//NSLog(@"prog %@", self.progViewController.view);
	
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
	v.backgroundColor = [UIColor darkGrayColor];
	[self.tableView setTableFooterView:v];
	[v release];
	
	self.title = @"HFRrehost";
	
	//self.tableView.tableHeaderView = self.progViewController.view;
}


// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)configureCell:(ImageCellView *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = [[managedObject valueForKey:@"timeStamp"] description];
    //cell.detailTextLabel.text = [[managedObject valueForKey:@"nolink_full"] description];
	NSString *url = [NSString stringWithString:[[managedObject valueForKey:@"nolink_miniature"] description]];
	url = [url stringByReplacingOccurrencesOfString:@"[img]" withString:@""];
	url = [url stringByReplacingOccurrencesOfString:@"[/img]" withString:@""];

	[cell.previewImage setImageWithURL:[NSURL URLWithString:url]];
	[cell.previewImage2 setImageWithURL:[NSURL URLWithString:url]];
}


#pragma mark -
#pragma mark Add a new object

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
	if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [self.overlayViewController setupImagePicker:sourceType];
        [self presentModalViewController:self.overlayViewController.imagePickerController animated:YES];
    }
}

- (void)insertNewObject {

	[self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
	return;
}




- (void)setEditing:(BOOL)editing animated:(BOOL)animated {

    // Prevent new objects being added when in editing mode.
    [super setEditing:(BOOL)editing animated:(BOOL)animated];
    self.navigationItem.rightBarButtonItem.enabled = !editing;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	
	static NSString *CellIdentifier = @"ApplicationCell";
    
    ImageCellView *cell = (ImageCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {
		
        [[NSBundle mainBundle] loadNibNamed:@"ImageViewCell" owner:self options:nil];
        cell = tmpCell;
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		//cell.selectionStyle = UITableViewCellSelectionStyleBlue;	

		cell.parent = self;
        self.tmpCell = nil;
		
	}
    
	[self configureCell:cell atIndexPath:indexPath];

	/*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    */
	
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"commitEditingStyle");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}



- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
NSLog(@"didSelectRowAtIndexPath %@", indexPath);
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"shouldIndentWhileEditingRowAtIndexPath");
	return NO;
}
#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
    
    /*
     Set up the fetched results controller.
    */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchedResultsController_;
}    


#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

#pragma mark -
#pragma mark OverlayViewControllerDelegate

// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
	
	[self.progViewController.progIndicator setProgress:0];
	self.tableView.tableHeaderView = self.progViewController.view;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	self.navigationItem.leftBarButtonItem.enabled = NO;
	
	[self performSelectorInBackground:@selector(loadData:) withObject:picture];
}

-(void)loadData:(UIImage *)picture {
	
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	//NSLog(@"imageOrientation %@", picture.imageOrientation);
	//NSLog(@"image %@", picture.imageOrientation);
	
	NSData* jpegImageData = UIImageJPEGRepresentation(picture, 0.9);
	[self performSelectorOnMainThread:@selector(loadData2:) withObject:jpegImageData waitUntilDone:NO];
    [pool release];
	

}	

-(void)loadData2:(NSData *)jpegImageData {


	
	ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: 
								[NSURL URLWithString:@"http://hfr-rehost.net/upload"]]; 
								//   [NSURL URLWithString:@"http://folkn.celeonet.fr/hfrplus/rehost/uploader/upload.processor.php"]]; 
	

	
	NSString* filename = [NSString stringWithFormat:@"snapshot_%d.jpg", rand()]; 
	
	[request setData:jpegImageData withFileName:filename andContentType:@"image/jpeg" forKey:@"fichier"]; 
	//[request setData:jpegImageData withFileName:filename andContentType:@"image/jpeg" forKey:@"file"]; 
	[request setPostValue:@"Envoyer" forKey:@"submit"];
	[request setShouldRedirect:NO];
	
	request.uploadProgressDelegate = self.progViewController; 
	
	[request setDelegate:self];
	
	[request setDidStartSelector:@selector(fetchContentStarted:)];
	[request setDidFinishSelector:@selector(fetchContentComplete:)];
	[request setDidFailSelector:@selector(fetchContentFailed:)];
	
	
	[request startAsynchronous]; 

	
	
}

- (void)fetchContentStarted:(ASIHTTPRequest *)theRequest
{
	NSLog(@"fetchContentStarted");	
}

- (void)fetchContentComplete:(ASIHTTPRequest *)theRequest
{
	NSLog(@"fetchContentComplete");
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	
	self.tableView.tableHeaderView = nil;
	
	[UIView commitAnimations];
	
	
	NSError * error = nil;
	//HTMLParser * myParser = [[HTMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:[self.urlQuote lowercaseString]] error:&error];
	HTMLParser * myParser = [[HTMLParser alloc] initWithData:[theRequest responseData] error:&error];
	//NSLog(@"error %@", error);
	//NSDate *then0 = [NSDate date]; // Create a current date
	
	HTMLNode * bodyNode = [myParser body]; //Find the body tag

	NSArray *codeArray = [bodyNode findChildTags:@"code"];
	NSLog(@"codeArray %d", codeArray.count);
	
	if (codeArray.count == 6) {
		// OK :D
		
		// Create a new instance of the entity managed by the fetched results controller.
		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
		NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
		
		// If appropriate, configure the new managed object.
		[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
		[newManagedObject setValue:[[codeArray objectAtIndex:0] allContents] forKey:@"link_full"];
		[newManagedObject setValue:[[codeArray objectAtIndex:1] allContents] forKey:@"link_preview"];
		[newManagedObject setValue:[[codeArray objectAtIndex:2] allContents] forKey:@"link_miniature"];
		
		[newManagedObject setValue:[[codeArray objectAtIndex:3] allContents] forKey:@"nolink_full"];
		[newManagedObject setValue:[[codeArray objectAtIndex:4] allContents] forKey:@"nolink_preview"];
		[newManagedObject setValue:[[codeArray objectAtIndex:5] allContents] forKey:@"nolink_miniature"];		
		
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}

		
	}
	else {
		// ERROR .x
		NSLog(@"ERROR: %@", [theRequest responseString]);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops !" message:@"Erreur inconnue :/"
													   delegate:self cancelButtonTitle:@"Tant pis..." otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
		
	}
	self.navigationItem.rightBarButtonItem.enabled = YES;
	self.navigationItem.leftBarButtonItem.enabled = YES;	
	[myParser release];
}

- (void)fetchContentFailed:(ASIHTTPRequest *)theRequest
{
	self.navigationItem.rightBarButtonItem.enabled = YES;
	self.navigationItem.leftBarButtonItem.enabled = YES;

	
	NSLog(@"fetchContentFailed");
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops !" message:[[theRequest error] localizedDescription]
												   delegate:self cancelButtonTitle:@"Tant pis..." otherButtonTitles:nil, nil];
	[alert show];
	[alert release];

	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	
	self.tableView.tableHeaderView = nil;
	
	[UIView commitAnimations];	
	//NSLog(@"error: %@", [[theRequest error] localizedDescription]);

}


// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera
{
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [fetchedResultsController_ release];
    [managedObjectContext_ release];
	
	[overlayViewController release];
	[progViewController release];
	
    [super dealloc];
}


@end

