//
//  ImageViewController.h
//  HFRrehost
//
//  Created by Shasta on 16/10/13.
//
//

#import <UIKit/UIKit.h>
#import "constants.h"

@interface ImageViewController : UIViewController {
    
@private
    UIImageView *imageView;
    NSManagedObject *managedObject;
    UIButton *imageButton;
    UIActivityIndicatorView *loadingIndicator;
}

@property (nonatomic, assign) UIImageView *imageView;
@property (nonatomic, retain) NSManagedObject *managedObject;
@property (nonatomic, retain) UIButton *imageButton;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;

- (id)initWithManagedObject:(NSManagedObject *)object;

@end
