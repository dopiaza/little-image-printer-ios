//
//  LMNViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import "LMNViewController.h"
#import "LMNImageProcessor.h"
#import "LMNPrinterManager.h"

@interface LMNViewController ()

@end

@implementation LMNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)managePrinters:(id)sender
{
    
}

- (IBAction)takePhoto:(id)sender
{
    
}

- (IBAction)chooseFromLibrary:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker animated:YES completion:^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [[LMNPrinterManager sharedPrinterManager] printImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
