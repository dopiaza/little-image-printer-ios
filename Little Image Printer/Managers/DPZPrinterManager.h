//
//  DPZPrinterManager.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Printer.h"

typedef void (^DPZPrinterManagerCallback)(BOOL);

@interface DPZPrinterManager : NSObject
<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

+ (DPZPrinterManager *)sharedPrinterManager;

- (Printer *)createPrinter;
- (void)deletePrinter:(Printer *)printer;


- (void)printImageForURL:(NSURL *)imageURL withCompletionBlock:(DPZPrinterManagerCallback)completionBlock;
- (void)printImage:(UIImage *)image withCompletionBlock:(DPZPrinterManagerCallback)completionBlock;

@property (nonatomic, strong) Printer *activePrinter;

@property (nonatomic, retain, readonly) NSFetchedResultsController *printersFetchedResultsController;
@property (nonatomic, readonly) NSArray *printers;

@property (nonatomic, readonly) NSError *error;

@end
