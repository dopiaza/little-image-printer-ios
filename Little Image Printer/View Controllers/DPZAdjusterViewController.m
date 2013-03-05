//
//  DPZAdjusterViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZAdjusterViewController.h"
#import "DPZImageProcessor.h"
#import "DPZPrinterManager.h"

@interface DPZAdjusterViewController ()

@property (nonatomic, strong) DPZImageProcessor *imageProcessor;

@end

@implementation DPZAdjusterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageProcessor = [[DPZImageProcessor alloc] initWithSourceImage:self.sourceImage];
    self.image.image = [self.imageProcessor processImage];
    [self.image setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)adjusted
{
    self.imageProcessor.brightness = self.brightness.value;
    self.imageProcessor.contrast = self.contrast.value;
    self.image.image = [self.imageProcessor processImage];
    [self.image setNeedsDisplay];
}

- (IBAction)print
{
    [[DPZPrinterManager sharedPrinterManager] printImage:[self.imageProcessor processImage]];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];    
}

@end
