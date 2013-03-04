//
//  LMNDataManager.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import "LMNDataManager.h"

static LMNDataManager *_sharedManager = nil;

@implementation LMNDataManager

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

+ (LMNDataManager *)sharedManager
{
    if (_sharedManager == nil)
    {
        _sharedManager = [[LMNDataManager alloc] init];
    }
    return _sharedManager;
}

#pragma mark - Core Data

- (id)getAllFromFetchRequest:(NSFetchRequest *)fetchRequest
{
    NSArray *matches = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return matches;
}

- (id)getOneFromFetchRequest:(NSFetchRequest *)fetchRequest
{
    NSArray *matches = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return ([matches count] >= 1) ? [matches objectAtIndex:0] : nil;
}

- (id)insertNewObjectForEntityForName:(NSString *)name
{
    NSManagedObjectContext *context = [self managedObjectContext];
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
}

- (NSFetchRequest *)newFetchRequestForEntityNamed:(NSString *)name
{
    NSEntityDescription *entity = [self entityForName:name];
    return [self newFetchRequestForEntity:entity];
}

- (NSFetchRequest *)newFetchRequestForEntity:(NSEntityDescription *)entity
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    return  fetchRequest;
}

- (NSEntityDescription *)entityForName:(NSString *)name
{
    return [NSEntityDescription entityForName:name inManagedObjectContext:[self managedObjectContext]];
}

- (NSManagedObject *)loadObjectWithId:(NSManagedObjectID *)moId
{
    return [self.managedObjectContext objectRegisteredForID:moId];
}

- (void)deleteObject:(NSManagedObject *)object
{
    if (object)
    {
        [self.managedObjectContext deleteObject:object];
    }
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LittleImagePrinter" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LittleImagePrinter"];
    
    NSError *error = nil;
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        [self fatalError:error];
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        _managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }
    
    return _managedObjectContext;
}

-(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    [self saveContext:managedObjectContext];
}

-(void)saveContext:(NSManagedObjectContext *)managedObjectContext
{
    NSError *error = nil;
    
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            [self fatalError:error];
        }
    }
}


-(void)fatalError:(NSError *)error
{
    [self alertWithTitle:@"Error" message:@"A serious error occured and Little Image Printer cannot continue. Please close the application by pressing the Home button."];
    NSLog(@"Fatal error %@, %@", error, [error userInfo]);
    abort();
}

-(void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:title
                              message: message
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    });
}

@end
