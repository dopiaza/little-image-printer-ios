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
    
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];

    self.navigationItem.rightBarButtonItem = self.saveButton;
    if (self.printer)
    {
        self.name.text = self.printer.name;
        self.code.text = self.printer.code;
    }
    [self refreshControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshControls
{
    if (self.printer == nil)
    {
        self.deleteButton.enabled = NO;
    }
    
    if ([self.name.text length] == 0 || [self.code.text length] == 0)
    {
        self.saveButton.enabled = NO;
    }
    else
    {
        self.saveButton.enabled = YES;
    }
}

- (void)textChanged:(id)sender
{
    [self refreshControls];
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
    
    DPZPrinterManager *pm = [DPZPrinterManager sharedPrinterManager];
    if ([pm.printers count] == 1)
    {
        // We only have one printer, let's auto select it
        pm.activePrinter = self.printer;
    }
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
            [[DPZPrinterManager sharedPrinterManager] deletePrinter:self.printer];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

@end
