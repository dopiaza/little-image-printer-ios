//
//  LMNAdjusterViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import "LMNAdjusterViewController.h"
#import "LMNImageProcessor.h"
#import "LMNPrinterManager.h"

@interface LMNAdjusterViewController ()

@property (nonatomic, strong) LMNImageProcessor *imageProcessor;

@end

@implementation LMNAdjusterViewController

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

    self.imageProcessor = [[LMNImageProcessor alloc] initWithSourceImage:self.sourceImage];
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
    [[LMNPrinterManager sharedPrinterManager] printImage:[self.imageProcessor processImage]];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
