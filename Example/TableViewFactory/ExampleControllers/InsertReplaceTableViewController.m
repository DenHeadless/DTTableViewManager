//
//  InsertReplaceTableViewController.m
//  TableViewFactory
//
//  Created by Denys Telezhkin on 10/16/12.
//  Copyright (c) 2012 Denys Telezhkin. All rights reserved.
//

#import "InsertReplaceTableViewController.h"

@interface InsertReplaceTableViewController ()
@property (nonatomic,retain) Example * wonderfulExample;
@end

@implementation InsertReplaceTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self setCellMappingforClass:[ExampleCell class] modelClass:[Example class]];
    }
    return self;
}

-(void)dealloc
{
    self.wonderfulExample = nil;
    [super dealloc];
}

-(Example *)wonderfulExample
{
    if (!_wonderfulExample)
        _wonderfulExample = [[Example exampleWithText:@"Wonderful" andDetails:@"cell"] retain];
    return _wonderfulExample;
}

-(void)addInsertSection
{
    [self addTableItem:[Example exampleWithText:@"Tap me to insert wonderful cell" andDetails:nil]];
}

-(void)addReplaceSection
{
    [self addTableItem:[Example exampleWithText:@"Tap me to replace with wonderful cell"
                                     andDetails:nil]
             toSection:1];
    [self addTableItem:[Example exampleWithText:@"Or me"
                                     andDetails:nil]
             toSection:1];
    [self addTableItem:[Example exampleWithText:@"Or me"
                                     andDetails:nil]
             toSection:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addInsertSection];
    [self addReplaceSection];
    [self setSectionHeaders:@[@"Insert rows", @"Replace rows"]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section)
    {
        //replace
        [self replaceTableItem:[self tableItemAtIndexPath:indexPath]
                 withTableItem:self.wonderfulExample
               andRowAnimation:UITableViewRowAnimationRight];
    }
    else
    {
        //insert
        [self insertTableItem:self.wonderfulExample
                  toIndexPath:indexPath
             withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
