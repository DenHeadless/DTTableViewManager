//
//  DTTableViewDatasource.m
//  DTTableViewManager
//
//  Created by Denys Telezhkin on 23.11.13.
//  Copyright (c) 2013 Denys Telezhkin. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DTTableViewMemoryStorage.h"
#import "DTTableViewController.h"

@interface DTMemoryStorage ()
- (DTSectionModel *)getValidSection:(NSUInteger)sectionNumber;

@property (nonatomic, retain) DTStorageUpdate * currentUpdate;

- (void)startUpdate;

- (void)finishUpdate;
@end

@implementation DTTableViewMemoryStorage

- (void)setSectionHeaderModels:(NSArray *)headerModels
{
    [self setSupplementaries:headerModels forKind:DTTableViewElementSectionHeader];
}

- (void)setSectionFooterModels:(NSArray *)footerModels
{
    [self setSupplementaries:footerModels forKind:DTTableViewElementSectionFooter];
}

- (id)headerModelForSectionIndex:(NSInteger)index
{
    DTSectionModel * section = self.sections[index];
    return section.headerModel;
}

- (id)footerModelForSectionIndex:(NSInteger)index
{
    DTSectionModel * section = self.sections[index];
    return section.footerModel;
}

- (void)removeAllTableItems
{
    for (DTSectionModel * section in self.sections)
    {
        [section.objects removeAllObjects];
    }
    [self.delegate performAnimatedUpdate:^(UITableView * tableView)
    {
        [tableView reloadData];
    }];
}

- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
                toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self startUpdate];

    id item = [self objectAtIndexPath:sourceIndexPath];

    if (!sourceIndexPath || !item)
    {
        if ([self loggingEnabled])
        {
            NSLog(@"DTCollectionViewManager: source indexPath should not be nil when moving collection item");
        }
        return;
    }
    DTSectionModel * sourceSection = [self getValidSection:sourceIndexPath.section];
    DTSectionModel * destinationSection = [self getValidSection:destinationIndexPath.section];

    if ([destinationSection.objects count] < destinationIndexPath.row)
    {
        if ([self loggingEnabled])
        {
            NSLog(@"DTCollectionViewManager: failed moving item to indexPath: %@, only %d items in section", destinationIndexPath, [destinationSection.objects count]);
        }
        self.currentUpdate = nil;
        return;
    }

    [self.delegate performAnimatedUpdate:^(UITableView * tableView)
    {
        [tableView insertSections:self.currentUpdate.insertedSectionIndexes
                 withRowAnimation:UITableViewRowAnimationAutomatic];
        [sourceSection.objects removeObjectAtIndex:sourceIndexPath.row];
        [destinationSection.objects insertObject:item
                                         atIndex:destinationIndexPath.row];
        [tableView moveRowAtIndexPath:sourceIndexPath
                          toIndexPath:destinationIndexPath];
    }];
    self.currentUpdate = nil;
}

#pragma mark - Section management

- (void)moveSection:(NSInteger)indexFrom toSection:(NSInteger)indexTo
{
    DTSectionModel * validSectionFrom = [self getValidSection:indexFrom];
    [self getValidSection:indexTo];

    [(NSMutableArray *)self.sections removeObject:validSectionFrom];
    [(NSMutableArray *)self.sections insertObject:validSectionFrom atIndex:indexTo];

    [self.delegate performAnimatedUpdate:^(UITableView * tableView)
    {
        [tableView moveSection:indexFrom toSection:indexTo];
    }];
}

@end
