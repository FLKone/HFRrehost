//
//  ProgressView.h
//  HFRrehost
//
//  Created by Shasta on 15/10/10.
//  Copyright 2010 FLK. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProgressView : UIViewController {
	UIProgressView *progIndicator;
}
@property (nonatomic, retain) IBOutlet UIProgressView *progIndicator;


@end
