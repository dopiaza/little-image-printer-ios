//
//  DPZImageProcessor.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DPZImageProcessor.h"

#define LPWIDTH 384.0


@interface DPZImageProcessor ()

@property (strong) NSURL *imageURL;

@property (strong) UIImage *sourceImage;
@property (strong) UIImage *adjustedImage;
@property (strong) CIImage *baseImage;
@property (strong) CIFilter *colorControls;
@property (strong) CIFilter *monochromeFilter;

@property (assign) CGSize originalSize;
@property (assign) CGSize baseSize;

@end

@implementation DPZImageProcessor

- (id)initWithSourceImageURL:(NSURL *)sourceImageURL
{
    self = [super init];
    if (self)
    {
        self.imageURL = sourceImageURL;
        self.brightness = 0.0;
        self.contrast = 1.0;
        [self initialiseImage];
    }
    return self;
}

- (id)initWithSourceImage:(UIImage *)sourceImage
{
    self = [super init];
    if (self)
    {
        self.imageURL = nil;
        self.sourceImage = sourceImage;
        self.brightness = 0.0;
        self.contrast = 1.0;
        [self initialiseImage];
    }
    return self;
}


- (void)setColorControls
{
    [self.colorControls setValue:[NSNumber numberWithFloat:0.0] forKey:@"inputSaturation"];
    [self.colorControls setValue:[NSNumber numberWithFloat:self.brightness]forKey:@"inputBrightness"];
    [self.colorControls setValue:[NSNumber numberWithFloat:self.contrast] forKey:@"inputContrast"];
}

- (void)initialiseImage
{
    if (self.imageURL)
    {
        self.sourceImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
    }
    
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
    
    self.originalSize = [self.sourceImage size];
    CGFloat scale = LPWIDTH/self.originalSize.width;
    self.baseSize = CGSizeMake(LPWIDTH, self.originalSize.height * scale);
    
    CIImage *img = [[CIImage alloc] initWithCGImage:[self.sourceImage CGImage]];;
    CGAffineTransform t = CGAffineTransformMakeScale(scale, scale);
    self.baseImage = [img imageByApplyingTransform:t];
    
    if (angle != 0.0)
    {
        CGAffineTransform rotator = CGAffineTransformMakeRotation(angle);
        self.baseImage = [self.baseImage imageByApplyingTransform:rotator];
    }
    
    self.colorControls = [CIFilter filterWithName:@"CIColorControls"];
    [self.colorControls setValue:self.baseImage forKey:@"inputImage"];
    [self setColorControls];
    
    [self processImage];
}


- (UIImage *)processImage
{
    //CGRect bounds = CGRectMake(0.0, 0.0, self.baseSize.width, self.baseSize.height);
    //NSLog(@"Size: %.2f, %.2f", self.baseSize.width, self.baseSize.height);

    [self setColorControls];
    
    CIImage *outputImage = [self.colorControls valueForKey:@"outputImage"];
    
    //self.adjustedImage = [UIImage imageWithCIImage:outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    self.adjustedImage = [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
    
    return self.adjustedImage;
}

- (NSData *)generatePNG
{
    NSData *pngData = [NSData dataWithData:UIImagePNGRepresentation(self.adjustedImage)];
    
    //BOOL ok = [pngData writeToFile:@"/Users/davidw/Desktop/image.png" atomically:NO];
    
    return pngData;
}

- (NSData *)generateJPG
{
    NSData *jpgData = [NSData dataWithData:UIImageJPEGRepresentation(self.adjustedImage, 0.9)];
    
    //BOOL ok = [pngData writeToFile:@"/Users/davidw/Desktop/image.png" atomically:NO];
    
    return jpgData;
}

@end
