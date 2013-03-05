//
//  FetchedResultsViewController.h
//  
//
//  Created by David Wilkinson on 09/04/2012.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPZFetchedResultsTableViewController : UIViewController
<NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

-(UITableViewCell *)newCellWithReuseIdentifier:(NSString *)cellIdentifier;
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet NSFetchedResultsController *fetchedResultsController;

@end
