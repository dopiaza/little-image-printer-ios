//
//  LMNEditPrinterViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 03/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import "LMNEditPrinterViewController.h"
#import "LMNDataManager.h"
#import "LMNPrinterManager.h"

@interface LMNEditPrinterViewController ()

@end

@implementation LMNEditPrinterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];

    self.navigationItem.rightBarButtonItem = saveButton;
    if (self.printer)
    {
        self.name.text = self.printer.name;
        self.code.text = self.printer.code;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save
{
    LMNDataManager *dm = [LMNDataManager sharedManager];
    if (self.printer == nil)
    {
        self.printer = [[LMNPrinterManager sharedPrinterManager] createPrinter];
    }
    self.printer.name = self.name.text;
    self.printer.code = self.code.text;
    [dm saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deletePrinter:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Confirm Delete"
                          message: [NSString stringWithFormat:@"Are you sure you want to delete %@?", self.printer.name]
                          delegate: self
                          cancelButtonTitle: @"Cancel"
                          otherButtonTitles: @"Delete", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            // Cancel
            break;
            
        case 1:
        {
            // Delete
            LMNDataManager *dm = [LMNDataManager sharedManager];
            [dm deleteObject:self.printer];
            [dm saveContext];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

@end
