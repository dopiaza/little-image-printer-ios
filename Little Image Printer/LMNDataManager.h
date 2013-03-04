//
//  LMNDataManager.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Printer.h"

@interface LMNDataManager : NSObject

+ (LMNDataManager *)sharedManager;

- (Printer *) createPrinter;
-(void)saveContext;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain, readonly) NSFetchedResultsController *printersFetchedResultsController;

@end
