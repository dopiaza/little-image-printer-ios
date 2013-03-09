//
//  DPZAdjusterViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DPZAdjusterViewController.h"
#import "DPZImageProcessor.h"
#import "DPZPrinterManager.h"

#define LPWIDTH 384.0

@interface DPZAdjusterViewController ()

@property (nonatomic, strong) DPZImageProcessor *imageProcessor;

@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) GPUImageBrightnessFilter *brightnessFilter;
@property (nonatomic, strong) GPUImageContrastFilter *contrastFilter;
@property (nonatomic, strong) GPUImageGrayscaleFilter *grayscaleFilter;

@property (nonatomic, strong) GPUImagePicture *sourcePicture;

@property (nonatomic, strong) UIImage *adjustedImage; // The image after rotation and scaling for LP

@property (nonatomic, strong) UIView *busyView; // Activity indicator shown whilst printing
@property (nonatomic, strong) UIBarButtonItem *printButton;

@end

@implementation DPZAdjusterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Adjust Image";
    
    self.printButton = [[UIBarButtonItem alloc] initWithTitle:@"Print" style:UIBarButtonItemStyleBordered target:self action:@selector(print)];
    self.navigationItem.rightBarButtonItem = self.printButton;
    
    self.adjustedImage = [self rotateAndScaleImage:self.sourceImage];
    
    self.imageView = [[GPUImageView alloc] initWithFrame:[self frameForImageView]];
    self.imageView.fillMode = kGPUImageFillModePreserveAspectRatio;
    [self.imageView setBackgroundColorRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    [self.imageViewHolder addSubview:self.imageView];
    
    self.brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    self.contrastFilter = [[GPUImageContrastFilter alloc] init];
    self.grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];

    self.sourcePicture = [[GPUImagePicture alloc] initWithImage:self.adjustedImage smoothlyScaleOutput:YES];
    [self.brightnessFilter forceProcessingAtSize:self.imageView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
    [self.contrastFilter forceProcessingAtSize:self.imageView.sizeInPixels];
    [self.grayscaleFilter forceProcessingAtSize:self.imageView.sizeInPixels];
    
    [self.sourcePicture addTarget:self.brightnessFilter];
    [self.brightnessFilter addTarget:self.contrastFilter];
    [self.contrastFilter addTarget:self.grayscaleFilter];
    [self.grayscaleFilter addTarget:self.imageView];
    
    [self.sourcePicture processImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // We need to adjust the frame for the image view - the correct size for the imageViewHolder isn't
    // set until viewWillAppear
    self.imageView.frame = [self frameForImageView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGRect)frameForImageView
{
    CGRect imageViewHolderFrame = self.imageViewHolder.frame;
    
    CGSize imageSize = self.adjustedImage.size;
    
    // Scale to fit on screen
    CGFloat scale = MIN(imageViewHolderFrame.size.width/imageSize.width, imageViewHolderFrame.size.height/imageSize.height);
    
    CGFloat w = imageSize.width * scale;
    CGFloat h = imageSize.height * scale;
    CGFloat x = MAX((imageViewHolderFrame.size.width - w)/2, 0.0);
    CGFloat y = MAX((imageViewHolderFrame.size.height - h)/2, 0.0);
    CGRect imageViewFrame = CGRectMake(x, y, w, h);
    
    return imageViewFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)adjusted
{
    [self.brightnessFilter setBrightness:self.brightness.value];
    [self.contrastFilter setContrast:self.contrast.value];
    [self.sourcePicture processImage];
}

- (IBAction)print
{
    [self showBusy];
    self.printButton.enabled = NO;
    UIImage *image = [self.grayscaleFilter imageFromCurrentlyProcessedOutput];
    [[DPZPrinterManager sharedPrinterManager] printImage:image withCompletionBlock:^(BOOL success)
    {
        [self hideBusy];
        self.printButton.enabled = YES;
        
        if (!success)
        {
            NSError *error = [DPZPrinterManager sharedPrinterManager].error;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:[NSString stringWithFormat:@"%@", error.localizedDescription]
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil];
            [alert show];
        }
    }];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];    
}

// Rotate image to correct orientation and scale to fit on Little Printer
- (UIImage *)rotateAndScaleImage:(UIImage *)image
{
    CGFloat angle = 0.0;
    UIImageOrientation orientation = self.sourceImage.imageOrientation;
    switch (orientation)
    {
        case UIImageOrientationUp:
            angle = 0.0;
            break;
            
        case UIImageOrientationDown:
            angle = M_PI;
            break;
            
        case UIImageOrientationLeft:
            angle = M_PI_2;
            break;
            
        case UIImageOrientationRight:
            angle = -M_PI_2;
            break;
            
        default:
            angle = 0.0;
            break;
    }

    CGSize originalSize = [self.sourceImage size];
    CGFloat scale = MIN(LPWIDTH/originalSize.width, 1.0); // Don't scale small images up
    
    CIImage *img = [[CIImage alloc] initWithCGImage:[image CGImage]];;
    CGAffineTransform t = CGAffineTransformMakeScale(scale, scale);
    CIImage *baseImage = [img imageByApplyingTransform:t];
    
    if (angle != 0.0)
    {
        CGAffineTransform rotator = CGAffineTransformMakeRotation(angle);
        baseImage = [baseImage imageByApplyingTransform:rotator];
    }

    CIContext *context = [CIContext contextWithOptions:nil];
    
    UIImage *adjustedImage = [UIImage imageWithCGImage:[context createCGImage:baseImage fromRect:baseImage.extent]];
    
    return adjustedImage;
}

- (void)showBusy
{
    CGSize imageViewHolderSize = self.imageViewHolder.frame.size;
    CGFloat overlayWidth = 100.0;
    CGFloat overlayHeight = 100.0;
    CGFloat overlayX = (imageViewHolderSize.width - overlayWidth)/2;
    CGFloat overlayY = (imageViewHolderSize.height - overlayHeight)/2;
    
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(overlayX, overlayY, overlayWidth, overlayHeight)];
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha = 0.7;
    overlay.layer.cornerRadius = 10.0;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    CGRect activityIndicatorFrame = activityIndicator.frame;
    CGSize activityIndicatorSize = activityIndicatorFrame.size;
    CGFloat activityIndicatorX = (overlayWidth - activityIndicatorSize.width)/2;
    CGFloat activityIndicatorY = (overlayHeight - activityIndicatorSize.height)/2;
    activityIndicatorFrame.origin.x = activityIndicatorX;
    activityIndicatorFrame.origin.y = activityIndicatorY;
    activityIndicator.frame = activityIndicatorFrame;
    activityIndicator.alpha = 1.0;
    
    [overlay addSubview:activityIndicator];
    [self.imageViewHolder addSubview:overlay];
    
    [activityIndicator startAnimating];
    
    self.busyView = overlay;
}

- (void)hideBusy
{
    [self.busyView removeFromSuperview];
    self.busyView = nil;
}

@end
