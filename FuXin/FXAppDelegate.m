//
//  FXAppDelegate.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-14.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAppDelegate.h"

static FXLoginController      *s_loginController = nil;
static UINavigationController *s_loginNavController = nil;

@interface FXAppDelegate ()
@property (nonatomic ,strong) UIAlertView *alertView;
@property (nonatomic ,strong) UIView *progressHUDView;  //菊花view
@end


@implementation FXAppDelegate

@synthesize rootController = _rootController;
@synthesize userID = _userID;
@synthesize token = _token;
@synthesize messageTimeStamp = _messageTimeStamp;
@synthesize contactTimeStamp = _contactTimeStamp;
@synthesize isChatting = _isChatting;
@synthesize user = _user;
@synthesize push_deviceToken = _push_deviceToken;

+ (FXAppDelegate *)shareFXAppDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (FXRootViewController *)shareRootViewContorller {
    return _rootController;
}

+ (UINavigationController *)shareLoginViewController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_loginController = [[FXLoginController alloc] init];
        s_loginNavController = [[UINavigationController alloc] initWithRootViewController:s_loginController];
        [[self class] setNavigationBarTinColor:s_loginNavController];
    });
    return s_loginNavController;
}

//设置导航栏颜色
+ (void)setNavigationBarTinColor:(UINavigationController *)nav {
    UIColor *color = kColor(209, 27, 33, 1);
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"red.png"] forBarMetrics:UIBarMetricsDefault];
    if (kDeviceVersion >= 7.0) {
//        nav.navigationBar.barTintColor = color;
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    }
    else {
        nav.navigationBar.tintColor = color;
    }
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [[UINavigationBar appearance] setTitleTextAttributes:barAttrs];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    
    _rootController = [[FXRootViewController alloc] init];
    self.window.rootViewController = _rootController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - 推送

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"deviceToken = %@",[NSString stringWithFormat:@"%@",deviceToken]);
    self.push_deviceToken = [[[[deviceToken description]
                               stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"notification error = %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@",userInfo);
}

#pragma mark - life style

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"background");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"active");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark --
+ (void)errorAlert:(NSString *)message {
    if (!message || [message isEqualToString:@""]) {
        return;
    }
    if ([FXAppDelegate shareFXAppDelegate].alertView != nil) {
        UIAlertView *alert = [FXAppDelegate shareFXAppDelegate].alertView;
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [[FXAppDelegate shareFXAppDelegate] setAlertView:alert];
    [alert show];
}

+ (void)showFuWuTitleForViewController:(UIViewController *)controller{
    //福务网标题
    NSString *versionString = [NSString stringWithFormat:@"v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *fullTitleString = [NSString stringWithFormat:@"福务网%@",versionString];
    NSRange versionRange = [fullTitleString rangeOfString:versionString];
    NSRange otherRange = NSMakeRange(0, versionRange.location);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullTitleString];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:otherRange];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:versionRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
    
    UILabel *attributedTitleLabel = [[UILabel alloc] init];
    attributedTitleLabel.frame = CGRectMake(85, 0, 150, 44);
    attributedTitleLabel.textColor = [UIColor whiteColor];
    attributedTitleLabel.backgroundColor = [UIColor clearColor];
    attributedTitleLabel.textAlignment = NSTextAlignmentCenter;
    attributedTitleLabel.attributedText = attributedString;
    
    controller.navigationItem.titleView = attributedTitleLabel;
}

///显示菊花 (只能同时存在一朵)
+ (void)addHUDForView:(UIView *)view animate:(BOOL)animate {
    UIView *HUDView = [FXAppDelegate shareFXAppDelegate].progressHUDView;
    [view addSubview:HUDView];
    HUDView.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 3);
    view.userInteractionEnabled = NO;
    if (animate) {
        HUDView.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            HUDView.alpha = 1;
        }];
    }
}

///隐藏菊花
+ (void)hideHUDForView:(UIView *)view animate:(BOOL)animate {
    view.userInteractionEnabled = YES;
    if (animate) {
        [UIView animateWithDuration:1 animations:^{
            [FXAppDelegate shareFXAppDelegate].progressHUDView.alpha = 0;
        } completion:^(BOOL finished) {
            [[FXAppDelegate shareFXAppDelegate].progressHUDView removeFromSuperview];
        }];
    }
}

- (UIView *)progressHUDView{
    if (!_progressHUDView) {
        _progressHUDView = [[UIView alloc] init];
        _progressHUDView.frame = CGRectMake(0, 0, 60, 70);
        _progressHUDView.backgroundColor = kColor(51, 51, 51, .5);
        _progressHUDView.layer.cornerRadius = 6.;
        _progressHUDView.layer.borderColor = kColor(0, 0, 0, .5).CGColor;
        _progressHUDView.layer.borderWidth = .5;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.frame = CGRectMake(0, 0, 60, 60);
        [indicator startAnimating];
        [_progressHUDView addSubview:indicator];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.frame = CGRectMake(2, 52, 56, 18);
        label.text = @"加载中..";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [_progressHUDView addSubview:label];
    }
    return _progressHUDView;
}

@end
