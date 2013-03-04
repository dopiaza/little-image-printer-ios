//
//  LMNEditPrinterViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 03/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import "LMNEditPrinterViewController.h"
#import "LMNDataManager.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save
{
    LMNDataManager *dm = [LMNDataManager sharedManager];
    Printer *printer = [dm createPrinter];
    printer.name = self.name.text;
    printer.code = self.code.text;
    [dm saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
