//
//  FXSearchViewController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSearchViewController.h"

@interface FXSearchViewController ()

@end

@implementation FXSearchViewController

@synthesize searchController = _searchController;
@synthesize searchBar = _searchBar;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSearchBarAndController {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion > 7.0) {
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
}

#pragma mark - UISearchBarDelegate   
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.hidden = YES;
    [_searchBar resignFirstResponder];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    _searchBar.hidden = YES;
}

@end
