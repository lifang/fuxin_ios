//
//  FXAddressListController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAddressListController.h"
#import "FXCompareCN.h"
#import "FXHttpRequest.h"

#define kTopViewHeight   40

@interface FXAddressListController ()

@end

@implementation FXAddressListController

@synthesize dataTableView = _dataTableView;
@synthesize dataItems = _dataItems;
@synthesize selectedHeaderView = _selectedHeaderView;

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
    [self setRightNavBarItemWithImageName:@"info.png"];
    [self initUI];
    _dataItems = [[NSMutableArray alloc] initWithObjects:@"王A",@"王B",@"李A",@"李B",@"赵A",@"张A",@"赵B",@"124",@"5434",nil];
    [self.view addSubview:self.searchBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写

- (IBAction)rightBarTouched:(id)sender {
    self.searchBar.hidden = NO;
    [self.searchBar becomeFirstResponder];
}

#pragma mark - UI

- (void)initUI {
    [self initTopSegmentedControlView];
    [self initBottomTableView];
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
//    _dataTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    [self.view addSubview:_dataTableView];
}

#pragma mark - Action

- (IBAction)selectedType:(id)sender {
    NSLog(@"!!!!%d",[(UISegmentedControl *)sender selectedSegmentIndex]);
    FXHttpRequest *request = [[FXHttpRequest alloc] init];
    [request setHttpRequestWithInfo:nil];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%lu",(unsigned long)[[FXCompareCN tableViewIndexArray:_dataItems] count]);
    return [[FXCompareCN tableViewIndexArray:_dataItems] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[FXCompareCN dataForSectionWithArray:_dataItems] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"AddressIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    NSString *data = [[[FXCompareCN dataForSectionWithArray:_dataItems] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = data;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (_selectedHeaderView) {
        _selectedHeaderView.isSelected = NO;
    }
    FXTableHeaderView *headerView = (FXTableHeaderView *)[tableView headerViewForSection:index];
    headerView.isSelected = YES;
    self.selectedHeaderView = headerView;
    return index;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [FXCompareCN tableViewIndexArray:_dataItems];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FXTableHeaderView *headerView = [[FXTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    headerView.indexLabel.text = [[FXCompareCN tableViewIndexArray:_dataItems] objectAtIndex:section];
    headerView.numberString = @"44";
    return headerView;
}



@end
