//
//  DPZEditPrinterViewController.h
//  Little Image Printer
//
//  Created by David Wilkinson on 03/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Printer.h"

@interface DPZEditPrinterViewController : UIViewController

- (IBAction)textChanged:(id)sender;
- (IBAction)deletePrinter:(id)sender;
- (IBAction)findPrinterCode:(id)sender;

@property (nonatomic, strong) IBOutlet UITextField *name;
@property (nonatomic, strong) IBOutlet UITextField *code;

@property (nonatomic, strong) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, strong) IBOutlet UIView *containerView;

@property (nonatomic, strong) Printer *printer;

@end

