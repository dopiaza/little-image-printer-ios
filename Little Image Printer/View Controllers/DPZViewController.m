//
//  DPZViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZViewController.h"
#import "DPZImageProcessor.h"
#import "DPZPrinterManager.h"
#import "DPZAdjusterViewController.h"
#import "DPZManagePrinterViewController.h"
#import "Printer.h"

@interface DPZViewController ()

@property (nonatomic, assign) BOOL usingCamera;
@property (nonatomic, assign) UIImage *image;

@end

@implementation DPZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Little Image Printer";
    
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
    Printer *printer = [DPZPrinterManager sharedPrinterManager].activePrinter;
    BOOL printerChosen = (printer != nil);
    self.printerNameLabel.text = printerChosen ? printer.name : @"";
    self.takePhotoButton.enabled = printerChosen;
    self.chooseFromLibraryButton.enabled = printerChosen;
}

- (IBAction)managePrinters:(id)sender
{
    DPZManagePrinterViewController *vc = [[DPZManagePrinterViewController alloc] initWithNibName:@"DPZManagePrinterViewController" bundle:nil];
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
    self.image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (self.image == nil)
    {
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (self.image)
    {
        if (self.usingCamera)
        {
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
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
    DPZAdjusterViewController *vc = [[DPZAdjusterViewController alloc] initWithNibName:@"DPZAdjusterViewController" bundle:nil];
    vc.sourceImage = image;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
