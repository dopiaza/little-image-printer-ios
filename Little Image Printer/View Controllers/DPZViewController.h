//
//  DPZViewController.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPZViewController : UIViewController
<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

- (IBAction)managePrinters:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)chooseFromLibrary:(id)sender;

@property (nonatomic, strong) IBOutlet UILabel *printerNameLabel;
@property (nonatomic, strong) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, strong) IBOutlet UIButton *chooseFromLibraryButton;

@end
