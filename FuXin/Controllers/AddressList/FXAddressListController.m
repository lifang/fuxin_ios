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

@synthesize contactLists = _contactLists;
@synthesize recentLists = _recentLists;
@synthesize tradeLists = _tradeLists;
@synthesize subscribeLists = _subscribeLists;
@synthesize selectedHeaderViewIndex = _selectedHeaderViewIndex;
@synthesize indexView = _indexView;
@synthesize listTypes = _listTypes;
@synthesize segmentControl = _segmentControl;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        _contactLists = [[NSMutableArray alloc] init];
        _recentLists = [[NSMutableArray alloc] init];
        _tradeLists = [[NSMutableArray alloc] init];
        _subscribeLists = [[NSMutableArray alloc] init];
        [self initUI];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通讯录";

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 32, 32);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRefresh:) name:RequestFinishNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"contactList"];

}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"contactList"];
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
        [_contactLists removeAllObjects];
        for (ContactModel *user in list) {
            [_contactLists addObject:user];
        }
//        [self resetIndexView];
//        self.listTypes = AddressListRecent;
//        _segmentControl.selectedSegmentIndex = AddressListRecent;
        [self showContactInColumn];
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

- (void)setListTypes:(AddressListTypes)listTypes {
    _listTypes = listTypes;
    [self showContactInColumn];
}

- (void)showContactInColumn {
    switch (_listTypes) {
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

#pragma mark - UI

- (void)initUI {
    [self setTopSegmentedControlView];
    [self initBottomTableView];
    [self.view addSubview:self.searchBar];
//    [self initIndexView];
}

- (void)setTopSegmentedControlView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kTopViewHeight)];
    _topView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_topView];
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16],UITextAttributeFont, nil];
    NSArray *segArray = [NSArray arrayWithObjects:@"最近", @"交易",@"订阅", nil];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segArray];
    _segmentControl.frame = CGRectMake(10, 7, 300, 32);
    _segmentControl.tintColor = kColor(209, 27, 33, 1);
    [_segmentControl setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    [_segmentControl addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventValueChanged];
    _listTypes = AddressListRecent;
    _segmentControl.selectedSegmentIndex = 0;
    [_topView addSubview:_segmentControl];
}

- (void)initBottomTableView {
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 49 - 64) style:UITableViewStylePlain];
    _dataTableView.delegate = self;
    _dataTableView.dataSource = self;
    [self.view addSubview:_dataTableView];
    if (kDeviceVersion >= 7.0) {
        _dataTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _dataTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - _dataTableView.bounds.size.height, self.view.frame.size.width, _dataTableView.bounds.size.height)];
        view.delegate = self;
        [_dataTableView addSubview:view];
        _refreshHeaderView = view;
    }

//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
//    [self.refreshControl beginRefreshing];
    [_dataTableView registerClass:[FXAddressListCell class] forCellReuseIdentifier:AddressCellIdentifier];
    [self hiddenExtraCellLineWithTableView:_dataTableView];
    _dataTableView.tableHeaderView = _topView;
    _selectedHeaderViewIndex = -1;
}

- (void)refresh {
//    if (self.refreshControl.isRefreshing) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UpdateContactNotification object:nil];
//    }
}

#pragma mark - 通知

- (void)endRefresh:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    BOOL result = [[dict objectForKey:@"result"] boolValue];
    _refreshHeaderView._statusLabel.hidden = NO;

    if (result) {
//        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新成功"];
        _refreshHeaderView._statusLabel.text = @"刷新成功";
    }
    else {
//        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新失败"];
        _refreshHeaderView._statusLabel.text = @"刷新失败";
    }
    [self performSelector:@selector(hiddenRefresh) withObject:nil afterDelay:0.5];
}

- (void)hiddenRefresh {
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@" "];
//    [self.refreshControl endRefreshing];
    if (_reloading) {
        [self doneLoadingTableViewData];
    }
}

#pragma mark - 右侧索引框 deprecated in 2014-6-25
/*
- (void)initIndexView {
    CGFloat originY = self.tableView.frame.origin.y + self.tableView.bounds.size.height / 2 - 20;
    CGFloat originX = 265;
    if (kDeviceVersion < 7.0) {
        originX = 250;
    }
    _indexView = [[FXSelectIndexView alloc] initWithFrame:CGRectMake(originX, originY, 40, 40)];
    _indexView.hidden = YES;
    [self.view addSubview:_indexView];
}

- (void)resetIndexView {
    CGFloat originY = self.tableView.frame.origin.y + self.tableView.bounds.size.height / 2 - 20;
    CGFloat originX = 265;
    if (kDeviceVersion < 7.0) {
        originX = 250;
    }
    _indexView.frame = CGRectMake(originX, originY, 40, 40);
    _indexView.hidden = YES;
    _indexView.currentIndex = -1;
    _selectedHeaderViewIndex = -1;
}
 */

#pragma mark - Action

- (IBAction)selectedType:(UISegmentedControl *)sender {
//    [self resetIndexView];
    self.listTypes = (int)sender.selectedSegmentIndex;
}

#pragma mark - 查找

- (NSArray *)sortRecentArrayWithArray:(NSArray *)contactList {
    return [contactList sortedArrayUsingComparator:^NSComparisonResult(ContactModel *model1, ContactModel *model2) {
        NSDate *date1 = [FXTimeFormat dateWithString:model1.contactLastContactTime];
        NSDate *date2 = [FXTimeFormat dateWithString:model2.contactLastContactTime];
        NSComparisonResult result = [date2 compare:date1];
        return result;
    }];
}

- (NSArray *)sortOrderArrayWithArray:(NSArray *)contactList {
    return [contactList sortedArrayUsingComparator:^NSComparisonResult(ContactModel *model1, ContactModel *model2) {
        NSDate *date1 = [FXTimeFormat dateWithString:model1.orderTime];
        NSDate *date2 = [FXTimeFormat dateWithString:model2.orderTime];
        NSComparisonResult result = [date2 compare:date1];
        return result;
    }];
}

- (NSArray *)sortSubscribeArrayWithArray:(NSArray *)contactList {
    return [contactList sortedArrayUsingComparator:^NSComparisonResult(ContactModel *model1, ContactModel *model2) {
        NSDate *date1 = [FXTimeFormat dateWithString:model1.subscribeTime];
        NSDate *date2 = [FXTimeFormat dateWithString:model2.subscribeTime];
        NSComparisonResult result = [date2 compare:date1];
        return result;
    }];
}

//排序找到最近联系人列表
- (void)getRecentContacts {
    NSArray *sortArray = [self sortRecentArrayWithArray:_contactLists];
    NSInteger count = [sortArray count];
    if (count > 20) {
        //取最近联系20人
        count = 20;
    }
    for (int i = 0; i < count; i++) {
        ContactModel *contact = [sortArray objectAtIndex:i];
        [_recentLists addObject:contact];
    }
}

//交易
- (void)getTradeContacts {
    NSArray *sortArray = [self sortOrderArrayWithArray:_contactLists];
    for (int i = 0; i < [sortArray count]; i++) {
        ContactModel *contact = [sortArray objectAtIndex:i];
        BOOL showFirst = (contact.contactRelationship & 3);
        if (showFirst) {
            [_tradeLists addObject:contact];
        }
    }
}

//订阅
- (void)getSubscribeContacts {
    NSArray *sortArray = [self sortSubscribeArrayWithArray:_contactLists];
    for (int i = 0; i < [sortArray count]; i++) {
        ContactModel *contact = [sortArray objectAtIndex:i];
        BOOL showSecond = ((contact.contactRelationship & 12) >> 2);
        if (showSecond) {
            [_subscribeLists addObject:contact];
        }
    }
}

- (NSMutableArray *)dataSourceWithListType:(AddressListTypes)type {
    NSMutableArray *sourceList = nil;
    switch (type) {
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
        return 1;
    }
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _dataTableView) {
        switch (_listTypes) {
            case AddressListRecent:
                return [_recentLists count];
                break;
            case AddressListTrade:
                return [_tradeLists count];
                break;
            case AddressListSubscribe:
                return [_subscribeLists count];
                break;
            default:
                break;
        }
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _dataTableView) {
        FXAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:AddressCellIdentifier forIndexPath:indexPath];
        NSMutableArray *columnList = [self dataSourceWithListType:_listTypes];
        ContactModel *contact = [columnList objectAtIndex:indexPath.row];
        cell.nameLabel.text = [self addNameForContact:contact];
        cell.imageURL = contact.contactAvatarURL;
        [cell showOrder:NO showSubscribe:NO];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _dataTableView) {
        NSMutableArray *columnList = [self dataSourceWithListType:_listTypes];
        ContactModel *contact = [columnList objectAtIndex:indexPath.row];

        FXContactInfoController *contactC = [[FXContactInfoController alloc] init];
        contactC.contact = contact;
        contactC.ID = contact.contactID;
        contactC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contactC animated:YES];
    }
    else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _dataTableView) {
        return 60;
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _dataTableView) {
        return 0;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

#pragma mark - 下拉刷新

- (void)reloadTableViewDataSource{
    _reloading = YES;
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_dataTableView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    [self reloadTableViewDataSource];
    [self refresh];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return _reloading;
}

//- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
//    return [NSDate date];
//}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark - 联系人分组排序 deprecated in 2014-6-25

/*
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
*/

@end
