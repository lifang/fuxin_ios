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

#define kTopViewHeight   40

static NSString *AddressCellIdentifier = @"ACI";

@interface FXAddressListController ()

@end

@implementation FXAddressListController

@synthesize dataTableView = _dataTableView;
@synthesize nameLists = _nameLists;
@synthesize contactLists = _contactLists;
@synthesize selectedHeaderViewIndex = _selectedHeaderViewIndex;
@synthesize indexView = _indexView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通讯录";
    NSLog(@"%@",self.title);
    [self setRightNavBarItemWithImageName:@"search.png"];
    [self initUI];
    _nameLists = [[NSMutableArray alloc] init];
    _contactLists = [[NSMutableArray alloc] init];
    [self.view addSubview:self.searchBar];
    [self getContactList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求
- (void)getContactList {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat getContactListWithToken:delegate.token UserId:delegate.userID Finished:^(BOOL success, NSData *response){
        if (success) {
            //请求成功
            [_nameLists removeAllObjects];
            [_contactLists removeAllObjects];
            ContactResponse *resp = [ContactResponse parseFromData:response];
            for (Contact *user in resp.contactsList) {
                [_nameLists addObject:user.name];
                [_contactLists addObject:user];
//                NSLog(@"id:%d|name:%@|customName:%@|pinyin:%@|last:%@|gender:%d|source:%d|isPro:%d|lisence:%@|pub:%@|sig:%@",user.contactId,user.name,user.customName,user.pinyin,user.lastContactTime,user.gender,user.source,user.isProvider,user.lisence,user.publishClassType,user.signature);
            }
            [_dataTableView reloadData];
        }
    }];
}

#pragma mark - 重写

- (IBAction)rightBarTouched:(id)sender {
    self.primaryArray = _contactLists;
    self.searchBar.hidden = NO;
    [self.searchBar becomeFirstResponder];
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
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segArray];
    segmentedControl.frame = CGRectMake(10, 5, 300, 29);
    segmentedControl.tintColor = kColor(209, 27, 33, 1);
    [segmentedControl addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = AddressListAll;
    [backView addSubview:segmentedControl];
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
    
    _selectedHeaderViewIndex = -1;
}

- (void)initIndexView {
    CGFloat originY = _dataTableView.frame.origin.y + _dataTableView.bounds.size.height / 2 - 20;
    _indexView = [[FXSelectIndexView alloc] initWithFrame:CGRectMake(265, originY, 40, 40)];
    _indexView.hidden = YES;
    [self.view addSubview:_indexView];
}

#pragma mark - Action

- (IBAction)selectedType:(id)sender {
    NSLog(@"!!!!%d",[(UISegmentedControl *)sender selectedSegmentIndex]);
//    FXHttpRequest *request = [[FXHttpRequest alloc] init];
//    [request setHttpRequestWithInfo:nil];
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
        cell.nameLabel.text = [rowDict objectForKey:kName];
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
        Contact *contact = [_contactLists objectAtIndex:[[dict objectForKey:kIndex] intValue]];
        FXChatViewController *chatC = [[FXChatViewController alloc] init];
        chatC.contact = contact;
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
        headerView.numberString = [NSString stringWithFormat:@"%d",[tableView numberOfRowsInSection:section]];
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
