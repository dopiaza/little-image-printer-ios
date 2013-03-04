//
//  Printer.h
//  Little Image Printer
//
//  Created by David Wilkinson on 04/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Printer : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * active;

@end
