//
//  DPZPrinterManager.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZPrinterManager.h"
#import "DPZDataManager.h"
#import "DPZImageProcessor.h"
#import "NSData+Base64.h"
#import "NSString+URLEncode.h"
#import "Printer.h"

static DPZPrinterManager *_sharedPrinterManager;

@interface DPZPrinterManager ()

@property (nonatomic, strong) DPZImageProcessor *imageProcessor;
@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, copy) void (^completionBlock)(BOOL);
@property (nonatomic, assign) NSInteger httpStatus;

@end

@implementation DPZPrinterManager

@synthesize printersFetchedResultsController = _printersFetchedResultsController;

+ (DPZPrinterManager *)sharedPrinterManager
{
    if (_sharedPrinterManager == nil)
    {
        _sharedPrinterManager = [[DPZPrinterManager alloc] init];
    }
    
    return _sharedPrinterManager;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        NSArray *printers = self.printers;
        if ([printers count] > 0)
        {
            for (Printer *p in printers)
            {
                if ([p.active boolValue])
                {
                    _activePrinter = p;
                    break;
                }
            }
            
            // No default set, just use the first in the list
            if (!_activePrinter)
            {
                _activePrinter = [printers objectAtIndex:0];
            }
        }
    }
    return self;
}

- (void)setActivePrinter:(Printer *)activePrinter
{
    _activePrinter = activePrinter;
    NSArray *printers = self.printers;
    for (Printer *p in printers)
    {
        p.active = [NSNumber numberWithBool:NO];
    }
    activePrinter.active = [NSNumber numberWithBool:YES];

    DPZDataManager *dm = [DPZDataManager sharedManager];
    [dm saveContext];
}


- (Printer *)createPrinter
{
    DPZDataManager *dm = [DPZDataManager sharedManager];
    return [dm insertNewObjectForEntityForName:@"Printer"];
}

- (void)deletePrinter:(Printer *)printer
{
    DPZDataManager *dm = [DPZDataManager sharedManager];
    if ([printer.active boolValue])
    {
        // This is the active printer,
        [DPZPrinterManager sharedPrinterManager].activePrinter = nil;
    }
    [dm deleteObject:printer];
    [dm saveContext];
}

- (NSArray *)printers
{
    DPZDataManager *dm = [DPZDataManager sharedManager];

    NSFetchRequest *fr = [dm newFetchRequestForEntityNamed:@"Printer"];
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    fr.sortDescriptors = [NSArray arrayWithObject:nameSort];
    
    return [dm getAllFromFetchRequest:fr];
}

- (NSFetchedResultsController *)printersFetchedResultsController
{
    if (_printersFetchedResultsController == nil)
    {
        DPZDataManager *dm = [DPZDataManager sharedManager];
        NSFetchRequest *fr = [dm newFetchRequestForEntityNamed:@"Printer"];
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        fr.sortDescriptors = [NSArray arrayWithObject:nameSort];
        
        _printersFetchedResultsController = [[NSFetchedResultsController alloc]
                                             initWithFetchRequest:fr
                                             managedObjectContext:dm.managedObjectContext
                                             sectionNameKeyPath:nil
                                             cacheName:nil];
    }
    
    return _printersFetchedResultsController;
}

- (void)printImageForURL:(NSURL *)imageURL withCompletionBlock:(DPZPrinterManagerCallback)completionBlock
{
    if (imageURL)
    {
        self.imageProcessor = [[DPZImageProcessor alloc] initWithSourceImageURL:imageURL];
        [self doPrintWithCompletionBlock:completionBlock];
    }
}

- (void)printImage:(UIImage *)image withCompletionBlock:(DPZPrinterManagerCallback)completionBlock
{
    if (image)
    {
        self.imageProcessor = [[DPZImageProcessor alloc] initWithSourceImage:image];        
        [self doPrintWithCompletionBlock:completionBlock];
    }
}

- (void)doPrintWithCompletionBlock:(DPZPrinterManagerCallback)completionBlock
{
    _error = nil;
    NSError *error = nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"print" ofType:@"html"];
    NSMutableString *html = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (error)
    {
        _error = error;
        if (completionBlock)
        {
            completionBlock(NO);
        }
    }
    else
    {
        self.completionBlock = completionBlock;
        
        NSString *contentType = @"image/png";
        NSData *imageData = nil;
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
        NSString *urlString = [NSString stringWithFormat:@"http://remote.bergcloud.com/playground/direct_print/%@",
                               self.activePrinter.code];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
        [self.connection start];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    self.httpStatus = [httpResponse statusCode];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.httpStatus == 200)
    {
        _error = nil;
    }
    else
    {
        NSString *message = nil;
        if (self.httpStatus == 401)
        {
            message = @"You are trying to print to a printer that doesn't exist. Please check you are using the correct print code.";
        }
        else
        {
            message = @"There was a problem trying to print to that printer.";
        }
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:message forKey:NSLocalizedDescriptionKey];
        _error = [NSError errorWithDomain:@"org.dopiaza.littleimageprinterios" code:1 userInfo:userInfo];        
    }
    
    if (self.completionBlock)
    {
        self.completionBlock(self.error == nil);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _error = error;
    if (self.completionBlock)
    {
        self.completionBlock(NO);
    }
}

@end
