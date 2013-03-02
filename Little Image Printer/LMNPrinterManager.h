//
//  LMNPrinterManager.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMNPrinterManager : NSObject

+ (LMNPrinterManager *)sharedPrinterManager;

- (NSString *)getDefaultPrinterName;
- (NSString *)getDefaultPrinterCode;
- (void)printImage:(NSURL *)imageURL;

@end
