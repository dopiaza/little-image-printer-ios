//
//  LMNViewController.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMNViewController : UIViewController
<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

- (IBAction)managePrinters:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)chooseFromLibrary:(id)sender;


@end
