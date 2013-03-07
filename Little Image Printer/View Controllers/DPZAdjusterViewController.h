//
//  DPZAdjusterViewController.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface DPZAdjusterViewController : UIViewController

- (IBAction)print;
- (IBAction)adjusted;
- (IBAction)cancel;

@property (nonatomic, strong) UIImage *sourceImage;

@property (nonatomic, strong) IBOutlet UISlider *brightness;
@property (nonatomic, strong) IBOutlet UISlider *contrast;
@property (nonatomic, strong) IBOutlet UIView *imageViewHolder;


@end
