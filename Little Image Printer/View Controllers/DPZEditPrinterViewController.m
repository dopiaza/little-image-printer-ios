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
#import "UIView+FirstResponder.h"

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
        self.title = @"Edit Printer";
    }
    else
    {
        self.title = @"Add Printer";
    }
    
    [self refreshControls];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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



// Called when the UIKeyboardWillShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect f = self.containerView.frame;
    f.origin.y = f.origin.y - kbSize.height;
    NSTimeInterval duration = [self keyboardAnimationDurationForNotification:notification];
    [UIView animateWithDuration:duration animations:^{
        self.containerView.frame = f;
    }];
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHide:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect f = self.containerView.frame;
    f.origin.y = f.origin.y + kbSize.height;
    NSTimeInterval duration = [self keyboardAnimationDurationForNotification:notification];
    [UIView animateWithDuration:duration animations:^{
        self.containerView.frame = f;
    }];
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}

// Hide the keyboard when the user taps outside of the controls
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view findAndResignFirstResponder];
}

@end
