//
//  BanksCoreDataViewController.m
//  DTTableViewManager
//
//  Created by Denys Telezhkin on 08.12.13.
//  Copyright (c) 2013 Denys Telezhkin. All rights reserved.
//

#import "BanksCoreDataViewController.h"
#import "Bank.h"
#import "BankCell.h"
#import "BanksCoreDataStorage.h"

@implementation BanksCoreDataViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self registerCellClass:[BankCell class] forModelClass:[Bank class]];

    NSFetchedResultsController * controller = [BanksCoreDataStorage banksFetchControllerWithPredicate:nil];
    self.storage = [[BanksCoreDataStorage alloc] initWithFetchResultsController:controller];
}

-(void)tableControllerDidCancelSearch
{
    self.tableView.hidden = NO;
}

-(void)tableControllerDidEndSearch
{
    if ([self.tableView numberOfSections] == 0)
    {
        self.tableView.hidden = YES;
    }
    else {
        self.tableView.hidden = NO;
    }
}

@end
