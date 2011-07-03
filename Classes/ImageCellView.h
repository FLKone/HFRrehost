//
//  ImageCellView.h
//  HFRrehost
//
//  Created by Shasta on 15/10/10.
//  Copyright 2010 FLK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"


@interface ImageCellView : UITableViewCell <UIAlertViewDelegate> {	
	UIImageView *previewImage;
	UIImageView *previewImage2;
	RootViewController *parent;
}

@property (nonatomic, retain) IBOutlet UIImageView *previewImage;
@property (nonatomic, retain) IBOutlet UIImageView *previewImage2;
@property (nonatomic, assign) RootViewController *parent;

-(IBAction)copyFull;
-(IBAction)copyPreview;
-(IBAction)copyMini;

@end
