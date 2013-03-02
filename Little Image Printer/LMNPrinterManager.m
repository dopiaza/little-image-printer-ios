    //
//  LMNPrinterManager.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import "LMNPrinterManager.h"
#import "LMNImageProcessor.h"
#import "NSData+Base64.h"
#import "NSString+URLEncode.h"

static LMNPrinterManager *_sharedPrinterManager;

@interface LMNPrinterManager ()

@property (nonatomic, strong) LMNImageProcessor *imageProcessor;
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation LMNPrinterManager

+ (LMNPrinterManager *)sharedPrinterManager
{
    if (_sharedPrinterManager == nil)
    {
        _sharedPrinterManager = [[LMNPrinterManager alloc] init];
    }
    
    return _sharedPrinterManager;
}


- (NSString *)getDefaultPrinterName
{
    return @"Default Printer";
}

- (NSString *)getDefaultPrinterCode
{
    return @"JQF379XBGUL8";
}

- (void)printImageForURL:(NSURL *)imageURL
{
    if (imageURL)
    {
        self.imageProcessor = [[LMNImageProcessor alloc] initWithSourceImageURL:imageURL];
        [self doPrint];
    }
}

- (void)printImage:(UIImage *)image
{
    if (image)
    {
        self.imageProcessor = [[LMNImageProcessor alloc] initWithSourceImage:image];        
        [self doPrint];
    }
}

- (void)doPrint
{
    NSError *error;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"print" ofType:@"html"];
    NSMutableString *html = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    NSString *contentType = @"image/png";
    NSData *imageData = nil; // [self.imageProcessor generatePNG];
    if ([imageData length] == 0)
    {
        imageData = [self.imageProcessor generateJPG];
        contentType = @"image/jpg";
    }
    
    NSString *dataUri = [NSString stringWithFormat:@"data:%@;base64,%@", contentType, [imageData base64EncodedString]];
    NSString *ditherClass = @"dither";
    
    NSString *finalHTML = [[html stringByReplacingOccurrencesOfString:@"_IMAGECLASS_" withString:ditherClass]
                           stringByReplacingOccurrencesOfString:@"_IMAGEURL_" withString:dataUri];
    NSString *urlEncodedHtml = [finalHTML urlEncode];
    
    NSString *body = [NSString stringWithFormat:@"html=%@", urlEncodedHtml];
    NSString *urlString = [NSString stringWithFormat:@"http://remote.bergcloud.com/playground/direct_print/%@", [self getDefaultPrinterCode]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Start connection");
    self.connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
    [self.connection start];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Failed: %@", [error localizedDescription]);
}

@end
