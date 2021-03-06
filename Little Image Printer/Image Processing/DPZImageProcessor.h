//
//  DPZImageProcessor.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"

@interface DPZImageProcessor : NSObject


- (id)initWithSourceImageURL:(NSURL *)sourceImageURL;
- (id)initWithSourceImage:(UIImage *)sourceImage;
- (UIImage *)processImage;
- (NSData *)generatePNG;
- (NSData *)generateJPG;

@property (assign) CGFloat brightness;
@property (assign) CGFloat contrast;

@end
