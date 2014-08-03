//
//  TOTAppDelegate.m
//  ThisOrThat
//
//  Created by Jerry Liu on 8/2/14.
//  Copyright (c) 2014 ThisOrThat. All rights reserved.
//

#import "TOTAppDelegate.h"
#import "TOTLoginViewController.h"

@implementation TOTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (TARGET_IPHONE_SIMULATOR) {
    [BaasBox setBaseURL:@"http://localhost:9000"
                appCode:@"1234567890"];
    } else {
        [BaasBox setBaseURL:@"http://169.254.154.234:9000"
                    appCode:@"1234567890"];
    }
    // Override point for customization after application launch.
    
    TOTLoginViewController *vc = [[TOTLoginViewController alloc] init];
    self.window.rootViewController = vc;
    self.window.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:188.0/255.0 blue:255.0/255.0 alpha:1];
    [self.window makeKeyAndVisible];
    [self.window setTintColor:[UIColor whiteColor]];
    
    return YES;
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
