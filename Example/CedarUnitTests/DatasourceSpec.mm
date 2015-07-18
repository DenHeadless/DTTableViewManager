#import "DTTableViewController+UnitTests.h"
#import "DTMemoryStorage+UnitTests.h"
#import "MockTableHeaderView.h"
#import "BeNil.h"
#import "DTMemoryStorage.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(DatasourceSpecs)

describe(@"Datasource spec", ^{
    __block DTTableViewController *model;
    __block DTMemoryStorage * storage;
    __block Example * testModel;
    __block Example * acc1;
    __block Example * acc2;
    __block Example * acc3;
    __block Example * acc4;
    __block Example * acc5;
    __block Example * acc6;


    beforeEach(^{
        [UIView setAnimationsEnabled:NO];

        model = [DTTableViewController new];
        storage = [model memoryStorage];
        storage.loggingEnabled = NO;
        model.storage = storage;
        model.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain] autorelease];
        [model registerCellClass:[ExampleCell class] forModelClass:[Example class]];
        model.tableView.delegate = model;
        model.tableView.dataSource = model;
        [model.tableView reloadData];
        testModel = [Example new];
        acc1 = [[Example new] autorelease];
        acc2 = [[Example new] autorelease];
        acc3 = [[Example new] autorelease];
        acc4 = [[Example new] autorelease];
        acc5 = [[Example new] autorelease];
        acc6 = [[Example new] autorelease];
    });

    afterEach(^{
        [model release];
        [testModel release];

        [UIView setAnimationsEnabled:YES];
    });

#define TEST_1 @"test1"
#define TEST_2 @"test2"

    it(@"should return correct tableItem", ^{
        [storage addItems:@[acc3,acc2,acc1,acc6,acc4]];

        [model verifyTableItem:acc6
                   atIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] should be_truthy;

        [model verifyTableItem:acc3
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;

        [storage itemAtIndexPath:[NSIndexPath indexPathForRow:56 inSection:0]] should be_nil;
    });

    it(@"should return correct number of table items", ^{
        [storage addItem:testModel];
        [storage addItem:testModel];
        [storage addItem:testModel];
        [storage addItem:testModel];

        [storage addItem:testModel toSection:1];
        [storage addItem:testModel toSection:1];
        [storage addItem:testModel toSection:1];

        [[storage itemsInSection:0] count] should equal(4);
        [[storage itemsInSection:1] count] should equal(3);

        [model tableView:model.tableView numberOfRowsInSection:0] should equal(4);
        [model tableView:model.tableView numberOfRowsInSection:1] should equal(3);
    });

    it(@"should return correct number of sections", ^{
        [storage addItem:acc1 toSection:0];
        [storage addItem:acc4 toSection:3];
        [storage addItem:acc2 toSection:2];

        [model numberOfSectionsInTableView:model.tableView] should equal(4);
    });

    it(@"should set section titles", ^{
        model.sectionHeaderStyle = DTTableViewSectionStyleTitle;
        [storage setSectionHeaderModels:[[@[ TEST_1, TEST_2 ] mutableCopy] autorelease]];
        [model tableView:model.tableView titleForHeaderInSection:0] should equal(TEST_1);
        [model tableView:model.tableView titleForHeaderInSection:1] should equal(TEST_2);
    });

    it(@"should set section footers", ^{
        model.sectionFooterStyle = DTTableViewSectionStyleTitle;
        [storage setSectionFooterModels:[[@[ TEST_1, TEST_2 ] mutableCopy] autorelease]];

        [model tableView:model.tableView titleForFooterInSection:0] should equal(TEST_1);
        [model tableView:model.tableView titleForFooterInSection:1] should equal(TEST_2);
    });

    it(@"should handle titles and footers", ^{
        [storage addItem:testModel];
        [storage addItem:testModel toSection:1];

        ^{
            [model tableView:model.tableView titleForFooterInSection:1];
            [model tableView:model.tableView titleForHeaderInSection:1];

        } should_not raise_exception;
    });

    it(@"should add table item", ^{
        [storage addItem:acc1];
        [storage addItem:acc4];
        [model verifyTableItem:acc1
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;
        [model verifyTableItem:acc4
                   atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] should be_truthy;
    });

    it(@"should add table items", ^{
        [storage addItems:@[acc3,acc2]];
        [storage itemsInSection:0].count should equal(2);
        [model verifyTableItem:acc3
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;
        [model verifyTableItem:acc2
                   atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] should be_truthy;
    });

    it(@"should add table item to section", ^{
        [storage addItem:acc1 toSection:0];
        [storage addItem:acc2 toSection:2];
        [storage addItem:acc4 toSection:2];

        [[storage sections] count] should equal(3);
        [model verifyTableItem:acc1
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;
        [model verifyTableItem:acc2
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]] should be_truthy;
        [model verifyTableItem:acc4
                   atIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]] should be_truthy;
    });

    it(@"should add table items to section", ^{
        [storage addItems:@[acc1,acc3,acc5] toSection:4];

        [[storage sections] count] should equal(5);

        [model verifyTableItem:acc1
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]] should be_truthy;
        [model verifyTableItem:acc3
                   atIndexPath:[NSIndexPath indexPathForRow:1 inSection:4]] should be_truthy;
        [model verifyTableItem:acc5
                   atIndexPath:[NSIndexPath indexPathForRow:2 inSection:4]] should be_truthy;
    });

    it(@"should add table item withRowAnimation", ^{
        [storage addItem:acc2];
        [storage addItem:acc5];

        [[storage itemsInSection:0] count] should equal(2);
        [model verifyTableItem:acc2
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;
        [model verifyTableItem:acc5
                   atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] should be_truthy;
    });

    it(@"should add table items  with row animation",^{
        [storage addItems:@[acc3,acc5,acc2]];

        [[storage itemsInSection:0] count] should equal(3);
        [model verifyTableItem:acc3
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;
        [model verifyTableItem:acc5
                   atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] should be_truthy;
        [model verifyTableItem:acc2
                   atIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] should be_truthy;
    });

    it(@"should insert table item to indexPath", ^{
        [storage addItems:@[acc2,acc4,acc6]];
        [storage insertItem:acc1 toIndexPath:[storage indexPathForItem:acc2]];
        [storage insertItem:acc3 toIndexPath:[storage indexPathForItem:acc4]];

        [[storage itemsInSection:0] count] should equal(5);

        [model verifyTableItem:acc1
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;
        [model verifyTableItem:acc3
                   atIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] should be_truthy;
    });

    it(@"should insert table item to indexPath with row animation", ^{
        [storage addItems:@[acc2,acc4,acc6]];
        [storage insertItem:acc1
                   toIndexPath:[storage indexPathForItem:acc2]];
        [storage insertItem:acc3
                   toIndexPath:[storage indexPathForItem:acc4]];

        [[storage itemsInSection:0] count] should equal(5);
        [model verifyTableItem:acc1
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;
        [model verifyTableItem:acc3
                   atIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] should be_truthy;
    });

    it(@"should replace table item with tableItem", ^{
        [storage addItems:@[acc1,acc3]];
        [storage addItems:@[acc4,acc6] toSection:1];

        [storage replaceItem:acc3 withItem:acc2];
        [storage replaceItem:acc4 withItem:acc5];

        [[storage itemsInSection:0] count] should equal(2);
        [[storage itemsInSection:1] count] should equal(2);

        [model verifyTableItem:acc2
                   atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] should be_truthy;
        [model verifyTableItem:acc5
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] should be_truthy;
    });

    it(@"should do nothing if trying to replace nil items", ^{
        [storage addItems:@[acc1,acc3,acc5]];
        ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
            [storage replaceItem:nil withItem:acc2];
            [storage replaceItem:acc5 withItem:nil];
#pragma clang diagnostic pop
        } should_not raise_exception;

        [model verifyTableItem:acc1
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;
        [model verifyTableItem:acc3
                   atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] should be_truthy;
        [model verifyTableItem:acc5
                   atIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] should be_truthy;

        [[storage itemsInSection:0] count] should equal(3);
    });

    it(@"should replace table item with tableItem with row animation", ^{
        [storage addItems:@[acc1,acc3]];
        [storage addItems:@[acc4,acc6] toSection:1];

        [storage replaceItem:acc3 withItem:acc2];
        [storage replaceItem:acc4 withItem:acc5];

        [[storage itemsInSection:0] count] should equal(2);
        [[storage itemsInSection:1] count] should equal(2);

        [model verifyTableItem:acc2
                   atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] should be_truthy;
        [model verifyTableItem:acc5
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] should be_truthy;
    });

    it(@"should do nothing if trying to replace nil items with row animation", ^{
        [storage addItems:@[acc1,acc3,acc5]];
        ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
            [storage replaceItem:nil withItem:acc2];
            [storage replaceItem:acc5 withItem:nil];
#pragma clang diagnostic pop
        } should_not raise_exception;

        [model verifyTableItem:acc1
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;
        [model verifyTableItem:acc3
                   atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] should be_truthy;
        [model verifyTableItem:acc5
                   atIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] should be_truthy;
        [[storage itemsInSection:0] count] should equal(3);
    });

    it(@"should remove table item", ^{
        [storage addItems:@[acc3,acc1,acc2,acc4,acc5]];

        [storage removeItem:acc4];
        [storage removeItem:acc3];
        [storage removeItem:acc5];

        [model verifyTableItem:acc1
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;
        [model verifyTableItem:acc2
                   atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] should be_truthy;
    });

    it(@"should remove table items", ^{
        [storage addItems:@[acc1,acc3,acc2,acc4]];
        [storage removeItems:@[acc1,acc4,acc3,acc5]];
        [[storage itemsInSection:0] count] should equal(1);
        [model verifyTableItem:acc2
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;
    });

    it(@"should remove all table items", ^{
        [storage addItems:@[acc1,acc5,acc4,acc2]];
        [storage removeAllTableItems];

        [[storage itemsInSection:0] count] should equal(0);
    });

    it(@"should move item to another row", ^{
        [storage addItems:@[acc1,acc2,acc3]];

        [storage moveTableItemAtIndexPath:[NSIndexPath indexPathForItem:0
                                                                          inSection:0]
                                          toIndexPath:[NSIndexPath indexPathForItem:2
                                                                          inSection:0]];
        [model verifySection:@[acc2,acc3,acc1] withSectionNumber:0];
    });

    it(@"should not crash when moving to bad row", ^{
        [storage addItems:@[acc1,acc2,acc3]];

        ^{
            [storage moveTableItemAtIndexPath:[NSIndexPath indexPathForItem:0
                                                             inSection:0]
                             toIndexPath:[NSIndexPath indexPathForItem:2
                                                             inSection:1]];
        } should_not raise_exception();
    });

    it(@"should not crash when moving from bad row", ^{
        [storage addItems:@[acc1,acc2,acc3]];

        ^{
            [storage moveTableItemAtIndexPath:[NSIndexPath indexPathForItem:0
                                                             inSection:1]
                             toIndexPath:[NSIndexPath indexPathForItem:0
                                                             inSection:0]];
        } should_not raise_exception();
    });

    it(@"should move sections", ^{
        [storage addItem:acc1];
        [storage addItem:acc2 toSection:1];
        [storage addItem:acc3 toSection:2];

        [storage moveTableViewSection:0 toSection:1];

        [model verifyTableItem:acc2
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;

        [model verifyTableItem:acc1
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] should be_truthy;

        [storage moveTableViewSection:2 toSection:0];

        [model verifyTableItem:acc3
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should be_truthy;

        [model verifyTableItem:acc2
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] should be_truthy;

        [model verifyTableItem:acc1
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]] should be_truthy;
    });

    it(@"should delete sections", ^{
        [storage addItem:acc1];
        [storage addItem:acc2 toSection:1];
        [storage addItem:acc3 toSection:2];

        [storage deleteSections:[NSIndexSet indexSetWithIndex:1]];

        [[storage sections] count] should equal(2);

        [model verifyTableItem:acc3
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] should be_truthy;
    });

    it(@"should delete sections with row animation", ^{
        [storage addItem:acc1];
        [storage addItem:acc2 toSection:1];
        [storage addItem:acc3 toSection:2];

        [storage deleteSections:[NSIndexSet indexSetWithIndex:1]];

        [[storage sections] count] should equal(2);

        [model verifyTableItem:acc3
                   atIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] should be_truthy;
    });

    it(@"should not throw exception if inserting at illegal indexPath", ^{
        ^{
            [storage insertItem:acc1 toIndexPath:
             [NSIndexPath indexPathForRow:1 inSection:0]];
        } should_not raise_exception;
    });

    it(@"should not throw exception if inserting at illegal indexPath", ^{
        ^{
            [storage insertItem:acc1 toIndexPath:
             [NSIndexPath indexPathForRow:3 inSection:5]];
        } should_not raise_exception;
    });

    describe(@"display titles on empty section", ^{

        beforeEach(^{
            [model.memoryStorage setSectionHeaderModel:@"Foo" forSectionIndex:0];
            [model.memoryStorage setSectionFooterModel:@"Bar" forSectionIndex:0];
        });

        afterEach(^{
            model.displayHeaderOnEmptySection = YES;
            model.displayFooterOnEmptySection = YES;
        });

        it(@"shouldn't return anything with property set", ^{
            model.displayHeaderOnEmptySection = NO;
            [model tableView:model.tableView titleForHeaderInSection:0] should be_nil;
        });

        it(@"should not return footer", ^{
            model.displayFooterOnEmptySection = NO;
            [model tableView:model.tableView titleForFooterInSection:0] should be_nil;
        });

    });

    describe(@"display views on empty section", ^{

        beforeEach(^{
            model.sectionHeaderStyle = DTTableViewSectionStyleView;
            model.sectionFooterStyle = DTTableViewSectionStyleView;
            
            [model registerHeaderClass:[MockTableHeaderView class]
                         forModelClass:[Example class]];
            [model registerFooterClass:[MockTableHeaderView class]
                         forModelClass:[Example class]];
            [model.memoryStorage setSectionHeaderModel:acc1 forSectionIndex:0];
            [model.memoryStorage setSectionFooterModel:acc2 forSectionIndex:0];
            
        });

        afterEach(^{
            model.displayHeaderOnEmptySection = YES;
            model.displayFooterOnEmptySection = YES;
        });

        it(@"should not return header", ^
        {
            model.displayHeaderOnEmptySection = NO;
            [model tableView:model.tableView viewForHeaderInSection:0] should be_nil;
        });

        it(@"should not return footer", ^
        {
           model.displayFooterOnEmptySection = NO;
            [model tableView:model.tableView viewForFooterInSection:0] should be_nil;
        });
    });
    
});

describe(@"Supplementary kinds should be set",^{

    it(@"should set kinds for storage",^{
        DTTableViewController * controller = [DTTableViewController new];
        DTMemoryStorage * storage = [DTMemoryStorage new];
        controller.storage = storage;
        
        storage.supplementaryHeaderKind should equal(DTTableViewElementSectionHeader);
        storage.supplementaryFooterKind should equal(DTTableViewElementSectionFooter);
    });
    
    it(@"should set kinds for searching storage",^{
        DTTableViewController * controller = [DTTableViewController new];
        DTMemoryStorage * storage = [DTMemoryStorage new];
        controller.searchingStorage = storage;
        
        storage.supplementaryHeaderKind should equal(DTTableViewElementSectionHeader);
        storage.supplementaryFooterKind should equal(DTTableViewElementSectionFooter);
    });
});

SPEC_END
