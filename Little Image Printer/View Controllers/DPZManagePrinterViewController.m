//
//  DPZManagePrinterViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZManagePrinterViewController.h"
#import "DPZPrinterManager.h"
#import "DPZEditPrinterViewController.h"
#import "Printer.h"

@interface DPZManagePrinterViewController ()

@end

@implementation DPZManagePrinterViewController

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

    self.title = @"Printers";

    self.fetchedResultsController = [DPZPrinterManager sharedPrinterManager].printersFetchedResultsController;
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addPrinter:(id)sender
{
    DPZEditPrinterViewController *vc = [[DPZEditPrinterViewController alloc] initWithNibName:@"DPZEditPrinterViewController" bundle:nil];
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
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Printer *printer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    DPZEditPrinterViewController *vc = [[DPZEditPrinterViewController alloc] initWithNibName:@"DPZEditPrinterViewController" bundle:nil];
    vc.printer = printer;
    [self.navigationController pushViewController:vc animated:YES];    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Printer *printer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [DPZPrinterManager sharedPrinterManager].activePrinter = printer;
    [self.navigationController popViewControllerAnimated:YES];
}


@end
