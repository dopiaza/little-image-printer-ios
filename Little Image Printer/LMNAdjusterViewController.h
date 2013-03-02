//
//  LMNAdjusterViewController.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMNAdjusterViewController : UIViewController

- (IBAction)print;
- (IBAction)adjusted;

@property (nonatomic, strong) UIImage *sourceImage;

@property (nonatomic, strong) IBOutlet UISlider *brightness;
@property (nonatomic, strong) IBOutlet UISlider *contrast;
@property (nonatomic, strong) IBOutlet UIImageView *image;


@end
