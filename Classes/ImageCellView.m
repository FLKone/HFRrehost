//
//  ImageCellView.m
//  HFRrehost
//
//  Created by Shasta on 15/10/10.
//  Copyright 2010 FLK. All rights reserved.
//

#import "ImageCellView.h"


@implementation ImageCellView
@synthesize previewImage, previewImage2, parent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		//self.backgroundView = self.previewImage;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


-(IBAction)copyFull {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Copier le BBCode" message:@"avec ou sans lien?"
												   delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Avec!", @"Sans!", @"Le lien uniquement!", nil];
	
	[alert setTag:111];
	[alert show];
	[alert release];	
}

-(IBAction)copyPreview {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Copier le BBCode" message:@"avec ou sans lien?"
												   delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Avec!", @"Sans!", @"Le lien uniquement!", nil];
	
	[alert setTag:222];
	[alert show];
	[alert release];	
}

-(IBAction)copyMini {
	//NSLog(@"indexPath %@", self.indexPath);

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Copier le BBCode" message:@"avec ou sans lien?"
												   delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Avec!", @"Sans!", @"Le lien uniquement!", nil];
	
	[alert setTag:333];
	[alert show];
	[alert release];	
}

- (void)dealloc {
	NSLog(@"dealloc");
	
	self.previewImage = nil;
	self.previewImage2 = nil;
	self.parent = nil;
	
    [super dealloc];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//NSLog(@"buttonIndex %d", buttonIndex);
	//NSLog(@"indexPath %@", self.indexPath);
	NSIndexPath *indexPath = [[self.parent tableView] indexPathForCell:self];
	
	NSLog(@"indexPath clicked %@", indexPath);

	
	NSManagedObject *managedObject = [self.parent.fetchedResultsController objectAtIndexPath:indexPath];
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	
	//NSLog(@"%@", [[managedObject valueForKey:@"nolink_miniature"] description]);	
	
	switch (buttonIndex) {
		case 1:
		{
			switch (alertView.tag) {
				case 111:
					pasteboard.string = [[managedObject valueForKey:@"link_full"] description];
					break;
				case 222:
					pasteboard.string = [[managedObject valueForKey:@"link_preview"] description];
					break;
				case 333:
					pasteboard.string = [[managedObject valueForKey:@"link_miniature"] description];
					break;					
				default:
					break;
			}
			break;
		}	
		case 2:
			switch (alertView.tag) {
				case 111:
					pasteboard.string = [[managedObject valueForKey:@"nolink_full"] description];
					break;
				case 222:
					pasteboard.string = [[managedObject valueForKey:@"nolink_preview"] description];
					break;
				case 333:
					pasteboard.string = [[managedObject valueForKey:@"nolink_miniature"] description];
					break;					
				default:
					break;
			}
			break;
        case 3:
        {
            
			switch (alertView.tag) {
				case 111:
					pasteboard.string = [[[[managedObject valueForKey:@"nolink_full"] description] stringByReplacingOccurrencesOfString:@"[img]" withString:@""] stringByReplacingOccurrencesOfString:@"[/img]" withString:@""];
					break;
				case 222:
					pasteboard.string = [[[[managedObject valueForKey:@"nolink_preview"] description] stringByReplacingOccurrencesOfString:@"[img]" withString:@""] stringByReplacingOccurrencesOfString:@"[/img]" withString:@""];
					break;
				case 333:
					pasteboard.string = [[[[managedObject valueForKey:@"nolink_miniature"] description] stringByReplacingOccurrencesOfString:@"[img]" withString:@""] stringByReplacingOccurrencesOfString:@"[/img]" withString:@""];
					break;					
				default:
					break;
			}
			break;
        }
		default:
			break;
	}
	
	NSLog(@"\n\n%@", pasteboard.string);
}

@end
