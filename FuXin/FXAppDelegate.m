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

static FXMainController       *s_mainController = nil;

@interface FXAppDelegate ()
@property (nonatomic ,strong)UIAlertView *alertView;
@end


@implementation FXAppDelegate

@synthesize rootController = _rootController;
@synthesize userID = _userID;
@synthesize token = _token;
@synthesize messageTimeStamp = _messageTimeStamp;

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

+ (FXMainController *)shareMainViewController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_mainController = [[FXMainController alloc] init];
    });
    return s_mainController;
}

//设置导航栏颜色
+ (void)setNavigationBarTinColor:(UINavigationController *)nav {
    UIColor *color = kColor(209, 27, 33, 1);
    if (kDeviceVersion >= 7.0) {
        nav.navigationBar.barTintColor = color;
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
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
    _rootController = [[FXRootViewController alloc] init];
    self.window.rootViewController = _rootController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

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

@end
