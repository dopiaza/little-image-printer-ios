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

#define LPWIDTH 384.0

@interface DPZAdjusterViewController ()

@property (nonatomic, strong) DPZImageProcessor *imageProcessor;

@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) GPUImageBrightnessFilter *brightnessFilter;
@property (nonatomic, strong) GPUImageContrastFilter *contrastFilter;
@property (nonatomic, strong) GPUImageGrayscaleFilter *grayscaleFilter;

@property (nonatomic, strong) GPUImagePicture *sourcePicture;

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

    self.title = @"Adjust Image";
    
    //self.imageProcessor = [[DPZImageProcessor alloc] initWithSourceImage:self.sourceImage];
    //self.image.image = [self.imageProcessor processImage];
    //[self.image setNeedsDisplay];
    
    UIBarButtonItem *printButton = [[UIBarButtonItem alloc] initWithTitle:@"Print" style:UIBarButtonItemStyleBordered target:self action:@selector(print)];
    self.navigationItem.rightBarButtonItem = printButton;
    
    self.brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    self.contrastFilter = [[GPUImageContrastFilter alloc] init];
    self.grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];
    
    UIImage *adjustedImage = [self rotateAndScaleImage:self.sourceImage];
    CGSize imageSize = adjustedImage.size;
    CGRect frame = CGRectMake((self.imageViewHolder.frame.size.width - imageSize.width)/2,
                              (self.imageViewHolder.frame.size.height - imageSize.height)/2,
                              imageSize.width,
                              imageSize.height);
    
    self.imageView = [[GPUImageView alloc] initWithFrame:frame];
    self.imageView.fillMode = kGPUImageFillModePreserveAspectRatio;
    [self.imageView setBackgroundColorRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    [self.imageViewHolder addSubview:self.imageView];
    
    self.sourcePicture = [[GPUImagePicture alloc] initWithImage:adjustedImage smoothlyScaleOutput:YES];
    [self.brightnessFilter forceProcessingAtSize:self.imageView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
    [self.contrastFilter forceProcessingAtSize:self.imageView.sizeInPixels];
    [self.grayscaleFilter forceProcessingAtSize:self.imageView.sizeInPixels];
    
    [self.sourcePicture addTarget:self.brightnessFilter];
    [self.brightnessFilter addTarget:self.contrastFilter];
    [self.contrastFilter addTarget:self.grayscaleFilter];
    [self.grayscaleFilter addTarget:self.imageView];
    
    [self.sourcePicture processImage];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)adjusted
{
    //self.imageProcessor.brightness = self.brightness.value;
    //self.imageProcessor.contrast = self.contrast.value;
    //self.image.image = [self.imageProcessor processImage];
    //[self.image setNeedsDisplay];
    [self.brightnessFilter setBrightness:self.brightness.value];
    [self.contrastFilter setContrast:self.contrast.value];
    [self.sourcePicture processImage];
}

- (IBAction)print
{
    [[DPZPrinterManager sharedPrinterManager] printImage:[self.grayscaleFilter imageFromCurrentlyProcessedOutput]];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];    
}

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
    CGFloat scale = MIN(LPWIDTH/originalSize.width, self.imageViewHolder.frame.size.height/originalSize.height);
    
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

@end
