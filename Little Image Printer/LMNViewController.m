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
#import "LMNAdjusterViewController.h"
#import "LMNManagePrinterViewController.h"
#import "Printer.h"

@interface LMNViewController ()

@property (nonatomic, assign) BOOL usingCamera;
@property (nonatomic, assign) UIImage *image;

@end

@implementation LMNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    Printer *printer = [LMNPrinterManager sharedPrinterManager].activePrinter;
    self.printerNameLabel.text = printer ? printer.name : @"";
}

- (IBAction)managePrinters:(id)sender
{
    LMNManagePrinterViewController *vc = [[LMNManagePrinterViewController alloc] initWithNibName:@"LMNManagePrinterViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)takePhoto:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    self.usingCamera = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)chooseFromLibrary:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    self.usingCamera = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    self.image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (self.image == nil)
    {
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (self.image)
    {
        //[[LMNPrinterManager sharedPrinterManager] printImage:self.image];
        if (self.usingCamera)
        {
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
        //[self performSelectorOnMainThread:@selector(runAdjuster:) withObject:self.image waitUntilDone:NO];
    }
    
    UIImage *img = self.image;
    [self dismissViewControllerAnimated:YES completion:^{
        if (img)
        {
            [self runAdjuster:img];
        }
    }];
}

- (void)runAdjuster:(UIImage *)image
{
    LMNAdjusterViewController *vc = [[LMNAdjusterViewController alloc] initWithNibName:@"LMNAdjusterViewController" bundle:nil];
    vc.sourceImage = image;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
