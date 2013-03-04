//
//  LMNEditPrinterViewController.h
//  Little Image Printer
//
//  Created by David Wilkinson on 03/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Printer.h"

@interface LMNEditPrinterViewController : UIViewController

- (IBAction)deletePrinter:(id)sender;

@property (nonatomic, strong) IBOutlet UITextField *name;
@property (nonatomic, strong) IBOutlet UITextField *code;

@property (nonatomic, strong) Printer *printer;

@end

