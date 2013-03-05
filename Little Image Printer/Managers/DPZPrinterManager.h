//
//  DPZPrinterManager.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Printer.h"

@interface DPZPrinterManager : NSObject

+ (DPZPrinterManager *)sharedPrinterManager;

- (Printer *) createPrinter;


- (void)printImageForURL:(NSURL *)imageURL;
- (void)printImage:(UIImage *)image;

@property (nonatomic, strong) Printer *activePrinter;

@property (nonatomic, retain, readonly) NSFetchedResultsController *printersFetchedResultsController;
@property (nonatomic, readonly) NSArray *printers;

@end
