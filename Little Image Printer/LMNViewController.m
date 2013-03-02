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
    NSURL *url = [NSURL URLWithString:@"http://farm9.staticflickr.com/8240/8473037025_613c1d9247_z.jpg"];
    [[LMNPrinterManager sharedPrinterManager] printImage:url];
}

@end
