//
//  FXSearchViewController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSearchViewController.h"
#import "FXAddressListCell.h"
#import "FXChatCell.h"

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
        [self initSearchBarAndController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _resultArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
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
    [self hiddenExtraCellLineWithTableView:_searchController.searchResultsTableView];
}

- (void)hiddenExtraCellLineWithTableView:(UITableView *)table {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [table setTableFooterView:view];
}

- (void)searchContacts {
    NSString *search = _searchController.searchBar.text;
    [_resultArray removeAllObjects];
    for (ContactModel *contact in _primaryArray) {
        BOOL hasNickName = [[contact.contactNickname lowercaseString] rangeOfString:[search lowercaseString]].length > 0;
        BOOL hadName = [[contact.contactRemark lowercaseString] rangeOfString:[search lowercaseString]].length > 0;
        if (hasNickName || hadName) {
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

#pragma mark - 下载头像

- (void)downloadImageWithContact:(ContactModel *)contact forCell:(FXListCell *)cell {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:contact.contactAvatarURL];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        NSLog(@"head = %@",url);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([cell.imageURL isEqualToString:contact.contactAvatarURL]) {
                if ([imageData length] > 0) {
                    cell.photoView.image = [UIImage imageWithData:imageData];
                    [FXFileHelper documentSaveImageData:imageData withName:contact.contactAvatarURL withPathType:PathForHeadImage];
                }
            }
        });
    });
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
        ContactModel *rowData = [_resultArray objectAtIndex:indexPath.row];
        if (rowData.contactRemark && ![rowData.contactRemark isEqualToString:@""]) {
            cell.nameLabel.text = rowData.contactRemark;
        }
        else {
            cell.nameLabel.text = rowData.contactNickname;
        }
        cell.imageURL = rowData.contactAvatarURL;
        if ([FXFileHelper isHeadImageExist:rowData.contactAvatarURL]) {
            NSData *imageData = [FXFileHelper headImageWithName:rowData.contactAvatarURL];
            cell.photoView.image = [UIImage imageWithData:imageData];
        }
        else {
            cell.photoView.image = [UIImage imageNamed:@"placeholder.png"];
            [self downloadImageWithContact:rowData forCell:cell];
        }
        
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
    ContactModel *rowData = [_resultArray objectAtIndex:indexPath.row];
    FXChatViewController *chatC = [[FXChatViewController alloc] init];
    chatC.contact = rowData;
    chatC.ID = rowData.contactID;
    chatC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatC animated:YES];
}

@end
