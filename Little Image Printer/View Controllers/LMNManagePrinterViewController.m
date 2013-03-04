//
//  LMNManagePrinterViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 Lumen Services Limited. All rights reserved.
//

#import "LMNManagePrinterViewController.h"
#import "LMNDataManager.h"
#import "Printer.h"
#import "LMNEditPrinterViewController.h"

@interface LMNManagePrinterViewController ()

@end

@implementation LMNManagePrinterViewController

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

    self.fetchedResultsController = [LMNDataManager sharedManager].printersFetchedResultsController;
    
    self.addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                  target:self
                                                                  action:@selector(addPrinter:)];
    self.navigationItem.rightBarButtonItem = self.addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addPrinter:(id)sender
{
    LMNEditPrinterViewController *vc = [[LMNEditPrinterViewController alloc] initWithNibName:@"LMNEditPrinterViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell *)newCellWithReuseIdentifier:(NSString *)cellIdentifier
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
}

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Printer *printer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = printer.name;
    cell.detailTextLabel.text = printer.code;
}

@end
