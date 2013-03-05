//
//  DPZEditPrinterViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 03/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZEditPrinterViewController.h"
#import "DPZDataManager.h"
#import "DPZPrinterManager.h"

@interface DPZEditPrinterViewController ()

@end

@implementation DPZEditPrinterViewController

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
    DPZDataManager *dm = [DPZDataManager sharedManager];
    if (self.printer == nil)
    {
        self.printer = [[DPZPrinterManager sharedPrinterManager] createPrinter];
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
            DPZDataManager *dm = [DPZDataManager sharedManager];
            [dm deleteObject:self.printer];
            [dm saveContext];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

@end
