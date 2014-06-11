//
//  FXAddressListController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAddressListController.h"
#import "FXCompareCN.h"
#import "FXAppDelegate.h"
#import "FXAddressListCell.h"
#import "LHLDBTools.h"
#import "FXTimeFormat.h"

#define kTopViewHeight   40

static NSString *AddressCellIdentifier = @"ACI";

@interface FXAddressListController ()

@end

@implementation FXAddressListController

@synthesize dataTableView = _dataTableView;
@synthesize nameLists = _nameLists;
@synthesize contactLists = _contactLists;
@synthesize recentLists = _recentLists;
@synthesize tradeLists = _tradeLists;
@synthesize subscribeLists = _subscribeLists;
@synthesize selectedHeaderViewIndex = _selectedHeaderViewIndex;
@synthesize indexView = _indexView;
@synthesize listTypes = _listTypes;
@synthesize segmentControl = _segmentControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [FXAppDelegate showFuWuTitleForViewController:self];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        _nameLists = [[NSMutableArray alloc] init];
        _contactLists = [[NSMutableArray alloc] init];
        _recentLists = [[NSMutableArray alloc] init];
        _tradeLists = [[NSMutableArray alloc] init];
        _subscribeLists = [[NSMutableArray alloc] init];
        [self initUI];
        [self.view addSubview:self.searchBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setRightNavBarItemWithImageName:@"search.png"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写

- (IBAction)rightBarTouched:(id)sender {
    self.primaryArray = _contactLists;
    self.searchBar.hidden = NO;
    [self.searchBar becomeFirstResponder];
}

#pragma mark - 更新数据

- (void)updateContactList:(NSArray *)list {
    if (list) {
        [_nameLists removeAllObjects];
        [_contactLists removeAllObjects];
        for (ContactModel *user in list) {
            [_nameLists addObject:[self addNameForContact:user]];
            [_contactLists addObject:user];
        }
        [self resetIndexView];
        _listTypes = AddressListAll;
        _segmentControl.selectedSegmentIndex = AddressListAll;
        [_dataTableView reloadData];
    }
}

//有备注显示备注 无备注显示昵称
- (NSString *)addNameForContact:(ContactModel *)model {
    if (model.contactRemark && ![model.contactRemark isEqualToString:@""]) {
        return model.contactRemark;
    }
    return model.contactNickname;
}

#pragma mark - UI

- (void)initUI {
    [self initTopSegmentedControlView];
    [self initBottomTableView];
    [self initIndexView];
}

- (void)initTopSegmentedControlView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kTopViewHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    NSArray *segArray = [NSArray arrayWithObjects:@"全部", @"最近", @"交易", @"订阅", nil];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segArray];
    _segmentControl.frame = CGRectMake(10, 5, 300, 29);
    _segmentControl.tintColor = kColor(209, 27, 33, 1);
    [_segmentControl addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventValueChanged];
    _segmentControl.selectedSegmentIndex = AddressListAll;
    [backView addSubview:_segmentControl];
}

- (void)initBottomTableView {
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopViewHeight, 320, kScreenHeight - 64 - kTopViewHeight - 49) style:UITableViewStylePlain];
    if (kDeviceVersion > 7.0) {
        _dataTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    [self.view addSubview:_dataTableView];
    [_dataTableView registerClass:[FXAddressListCell class] forCellReuseIdentifier:AddressCellIdentifier];
    [self hiddenExtraCellLineWithTableView:_dataTableView];
    _selectedHeaderViewIndex = -1;
}

- (void)initIndexView {
    CGFloat originY = _dataTableView.frame.origin.y + _dataTableView.bounds.size.height / 2 - 20;
    _indexView = [[FXSelectIndexView alloc] initWithFrame:CGRectMake(265, originY, 40, 40)];
    _indexView.hidden = YES;
    [self.view addSubview:_indexView];
}

- (void)resetIndexView {
    CGFloat originY = _dataTableView.frame.origin.y + _dataTableView.bounds.size.height / 2 - 20;
    _indexView.frame = CGRectMake(265, originY, 40, 40);
    _indexView.hidden = YES;
    _indexView.currentIndex = -1;
    _selectedHeaderViewIndex = -1;
}

#pragma mark - Action

- (IBAction)selectedType:(UISegmentedControl *)sender {
    [_nameLists removeAllObjects];
    [self resetIndexView];
    _listTypes = (int)sender.selectedSegmentIndex;
    switch (sender.selectedSegmentIndex) {
        case AddressListAll: {
            for (ContactModel *user in _contactLists) {
                [_nameLists addObject:[self addNameForContact:user]];
            }
        }
            break;
        case AddressListRecent: {
            [_recentLists removeAllObjects];
            [self getRecentContacts];
        }
            break;
        case AddressListTrade: {
            [_tradeLists removeAllObjects];
            [self getTradeContacts];
        }
            break;
        case AddressListSubscribe: {
            [_subscribeLists removeAllObjects];
            [self getSubscribeContacts];
        }
            break;
        default:
            break;
    }
    [_dataTableView reloadData];
}

//排序找到最近联系人列表
- (void)getRecentContacts {
    [LHLDBTools getConversationsWithFinished:^(NSMutableArray *conv,NSString *error) {
        NSArray *sortArray = [conv sortedArrayUsingComparator:^NSComparisonResult(ConversationModel *model1, ConversationModel *model2) {
            NSDate *date1 = [FXTimeFormat dateWithString:model1.conversationLastCommunicateTime];
            NSDate *date2 = [FXTimeFormat dateWithString:model2.conversationLastCommunicateTime];
            NSComparisonResult result = [date2 compare:date1];
            return result;
        }];
        NSInteger count = [sortArray count];
        if (count > 20) {
            //取最近联系20人
            count = 20;
        }
        for (int i = 0; i < count; i++) {
            ConversationModel *conv = [sortArray objectAtIndex:i];
            for (ContactModel *model in _contactLists) {
                if ([model.contactID isEqualToString:conv.conversationContactID]) {
                    [_recentLists addObject:model];
                    [_nameLists addObject:[self addNameForContact:model]];
                    break;
                }
            }
        }
    }];
}

//交易
- (void)getTradeContacts {
    for (ContactModel *model in _contactLists) {
        BOOL showFirst = (model.contactRelationship & 3);
        if (showFirst) {
            [_tradeLists addObject:model];
            [_nameLists addObject:[self addNameForContact:model]];
        }
    }
}

//订阅
- (void)getSubscribeContacts {
    for (ContactModel *model in _contactLists) {
        BOOL showSecond = ((model.contactRelationship & 12) >> 2);
        if (showSecond) {
            [_subscribeLists addObject:model];
            [_nameLists addObject:[self addNameForContact:model]];
        }
    }
}

- (NSMutableArray *)dataSourceWithListType:(AddressListTypes)type {
    NSMutableArray *sourceList = nil;
    switch (type) {
        case AddressListAll:
            sourceList = _contactLists;
            break;
        case AddressListRecent:
            sourceList = _recentLists;
            break;
        case AddressListTrade:
            sourceList = _tradeLists;
            break;
        case AddressListSubscribe:
            sourceList = _subscribeLists;
            break;
        default:
            break;
    }
    return sourceList;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _dataTableView) {
        return [[FXCompareCN tableViewIndexArray:_nameLists] count];
    }
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _dataTableView) {
        return [[[FXCompareCN dataForSectionWithArray:_nameLists] objectAtIndex:section] count];
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _dataTableView) {
        FXAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:AddressCellIdentifier forIndexPath:indexPath];
        NSDictionary *rowDict = [[[FXCompareCN dataForSectionWithArray:_nameLists] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSMutableArray *columnList = [self dataSourceWithListType:_listTypes];
        ContactModel *contact = [columnList objectAtIndex:[[rowDict objectForKey:kIndex] intValue]];
        BOOL showFirst = (contact.contactRelationship & 3);
        BOOL showSecond = ((contact.contactRelationship & 12) >> 2);
        [cell showOrder:showFirst showSubscribe:showSecond];
        cell.nameLabel.text = [self addNameForContact:contact];
        cell.imageURL = contact.contactAvatarURL;
        if ([FXFileHelper isHeadImageExist:contact.contactAvatarURL]) {
            NSData *imageData = [FXFileHelper headImageWithName:contact.contactAvatarURL];
            cell.photoView.image = [UIImage imageWithData:imageData];
        }
        else {
            cell.photoView.image = [UIImage imageNamed:@"placeholder.png"];
            [self downloadImageWithContact:contact forCell:cell];
        }
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == _dataTableView) {
        if (_selectedHeaderViewIndex >= 0) {
            FXTableHeaderView *selectedHeaderView = (FXTableHeaderView *)[tableView headerViewForSection:_selectedHeaderViewIndex];
            selectedHeaderView.isSelected = NO;
        }
        [_indexView moveToIndex:index
                   withAllIndex:[_dataTableView numberOfSections]
                     withHeight:_dataTableView.frame.size.height];
        _indexView.indexLabel.text = title;
        
        FXTableHeaderView *headerView = (FXTableHeaderView *)[tableView headerViewForSection:index];
        if (headerView) {
            headerView.isSelected = YES;
        }
        _selectedHeaderViewIndex = index;
        return index;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _dataTableView) {
        NSDictionary *dict = [[[FXCompareCN dataForSectionWithArray:_nameLists] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSMutableArray *columnList = [self dataSourceWithListType:_listTypes];
        ContactModel *contact = [columnList objectAtIndex:[[dict objectForKey:kIndex] intValue]];
        FXChatViewController *chatC = [[FXChatViewController alloc] init];
        chatC.contact = contact;
        chatC.ID = contact.contactID;
        chatC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatC animated:YES];
    }
    else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == _dataTableView) {
        return [FXCompareCN tableViewIndexArray:_nameLists];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _dataTableView) {
        return 20;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == _dataTableView) {
        return nil;
    }
    return [super tableView:tableView titleForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _dataTableView) {
        FXTableHeaderView *headerView = [[FXTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        headerView.indexLabel.text = [[FXCompareCN tableViewIndexArray:_nameLists] objectAtIndex:section];
        headerView.numberString = [NSString stringWithFormat:@"%ld",(long)[tableView numberOfRowsInSection:section]];
        return headerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (tableView == _dataTableView) {
        if (_selectedHeaderViewIndex >= 0 && section == _selectedHeaderViewIndex) {
            FXTableHeaderView *selectedHeaderView = (FXTableHeaderView *)view;
            selectedHeaderView.isSelected = YES;
        }
    }
}

@end
