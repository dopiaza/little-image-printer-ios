//
//  LMNDataManager.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMNDataManager : NSObject

+ (LMNDataManager *)sharedManager;

- (id)getAllFromFetchRequest:(NSFetchRequest *)fetchRequest;
- (id)getOneFromFetchRequest:(NSFetchRequest *)fetchRequest;
- (id)insertNewObjectForEntityForName:(NSString *)name;
- (NSFetchRequest *)newFetchRequestForEntityNamed:(NSString *)name;
- (NSFetchRequest *)newFetchRequestForEntity:(NSEntityDescription *)entity;
- (NSEntityDescription *)entityForName:(NSString *)name;
- (NSManagedObject *)loadObjectWithId:(NSManagedObjectID *)moId;
- (void)deleteObject:(NSManagedObject *)object;
- (void)saveContext;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
