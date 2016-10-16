//
//  AppDelegate.m
//  disCout
//
//  Created by Theodor Hedin on 7/20/16.
//  Copyright © 2016 THedin. All rights reserved.
//
#import "SWRevealViewController.h"
#import "actvatedRestaurantListViewController.h"
#import "LocationMapOfRestaurants.h"
#import "SearchViewController.h"
#import "MapViewController.h"
#import "AllPayHistoryViewController.h"

#import "AppDelegate.h"

@interface AppDelegate ()



@end



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [FIRApp configure];
    _dicRestaurantData = [[NSDictionary alloc]init];
    //self.dicSearchedDictionaryRestaurantData = [[NSDictionary alloc] init];
    
    //init condition
    
    //1. init Cuisign type
    self.arrCuisine = [[NSArray alloc]initWithObjects:@"African", @"American",@"British", @"Caribbean", @"Chinese", @"French", @"Greek", @"Indian", @"Italian", @"Japanese", @"Medditerranean", @"Mexican", @"Moroccan", @"Spanish", @"Thai", @"Turkish", @"Vietnamese", nil];
    self.user = [[UserInfo alloc]init];
    //init selected cuisine type
    self.arrSelectedCuisine = [[NSMutableArray alloc]init];
    for (int index = 0; index < self.arrCuisine.count; index++) {
        
        [self.arrSelectedCuisine addObject:@"1"];
        
    }
    [self.arrSelectedCuisine setObject:@"1" atIndexedSubscript:self.arrSelectedCuisine.count];
    [application setStatusBarHidden:YES];
    // Add this if you only want to change Selected Image color
    // and/or selected image text
    
    // Add this code to change StateNormal text Color,
    [[UIView appearanceWhenContainedInInstancesOfClasses:[[NSArray alloc] initWithObjects:[UITabBar class],nil]] setTintColor:[UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]];
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]}
                                           forState:UIControlStateNormal];
    
    
    // then if StateSelected should be different, you should add this code
    [UITabBarItem.appearance setTitleTextAttributes:
     @{
       NSFontAttributeName: [UIFont fontWithName:@"GRAYSTROKE" size:10],
       NSForegroundColorAttributeName: [UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]
       } forState:UIControlStateSelected];
    [UITabBarItem.appearance setTitleTextAttributes:
     @{
       NSFontAttributeName: [UIFont fontWithName:@"GRAYSTROKE" size:10],
       NSForegroundColorAttributeName: [UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]
       } forState:UIControlStateNormal];
    return YES;
}

-(void)addTabBar{
    SWRevealViewController *swRevealViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    self.window.rootViewController = swRevealViewController;
    [self.window makeKeyAndVisible];
}
- (void)applicationWillResignActive:(UIApplication *)application {

    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
