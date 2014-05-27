//
//  FXSearchViewController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSearchViewController.h"
#import "FXAddressListCell.h"

static NSString *searchIdentifer = @"SI";

@interface FXSearchViewController ()

@end

@implementation FXSearchViewController

@synthesize searchController = _searchController;
@synthesize searchBar = _searchBar;
@synthesize primaryArray = _primaryArray;
@synthesize resultArray = _resultArray;

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
    [self initSearchBarAndController];
    
    _resultArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSearchBarAndController {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (kDeviceVersion >= 7.0) {
        _searchBar.barTintColor = [UIColor redColor];
        _searchBar.tintColor = [UIColor lightGrayColor];
    }
    else {
        _searchBar.tintColor = [UIColor redColor];
    }
    CGRect rect = _searchBar.bounds;
    rect.origin.y -= 20;
    rect.size.height += 20;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.image = [UIImage imageNamed:@"red.png"];
    [_searchBar insertSubview:imageView atIndex:1];
    for (UIView *view in [[_searchBar.subviews objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
    }
    _searchBar.delegate = self;
    _searchBar.hidden = YES;
//    [self.view addSubview:_searchBar];
    _searchBar.placeholder = @"关键字";
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchController.delegate = self;
    _searchController.searchResultsTableView.delegate = self;
    _searchController.searchResultsTableView.dataSource = self;
    [_searchController.searchResultsTableView registerClass:[FXAddressListCell class] forCellReuseIdentifier:searchIdentifer];
}

- (void)searchContacts {
    NSString *search = _searchController.searchBar.text;
    [_resultArray removeAllObjects];
    for (Contact *contact in _primaryArray) {
        if ([[contact.name lowercaseString] rangeOfString:[search lowercaseString]].length > 0) {
            [_resultArray addObject:contact];
        }
    }
//    [_searchController.searchResultsTableView reloadData];
}

#pragma mark - UISearchBarDelegate   
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.hidden = YES;
    [_searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchContacts];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchContacts];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    _searchBar.hidden = YES;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _searchController.searchResultsTableView) {
        return [_resultArray count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _searchController.searchResultsTableView) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _searchController.searchResultsTableView) {
        FXAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:searchIdentifer forIndexPath:indexPath];
        Contact *rowData = [_resultArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = rowData.name;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"通讯录";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_searchBar resignFirstResponder];
    Contact *rowData = [_resultArray objectAtIndex:indexPath.row];
    FXChatViewController *chatC = [[FXChatViewController alloc] init];
    chatC.contact = rowData;
    chatC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatC animated:YES];
}

@end
