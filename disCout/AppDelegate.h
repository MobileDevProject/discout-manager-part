//
//  AppDelegate.h
//  disCout
//
//  Created by Theodor Hedin on 7/20/16.
//  Copyright © 2016 THedin. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UserInfo.h"
@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate>


//search result
@property (strong, nonatomic)UIWindow *window;
@property (nonatomic,retain)NSDictionary *dicRestaurantData;
@property (nonatomic)int selectedResNumberFromResList;
//@property (nonatomic,retain)NSDictionary *dicSearchedDictionaryRestaurantData;
@property (nonatomic,retain)NSMutableArray *arrSearchedDictinaryRestaurantData;
@property (nonatomic,retain)NSMutableArray *arrTempSearchedDictinaryRestaurantData;
@property (nonatomic,retain)NSMutableArray *arrRegisteredDictinaryRestaurantData;
@property (nonatomic,retain)NSMutableArray *arrPayDictinaryData;//dic->user, user->paydate and payamount

@property(nonatomic, retain) UITabBarController *MyTabBarController;

//they are moved into Backend
//@property (nonatomic,retain)NSArray *arrSearchedRestaurants;
@property(nonatomic, retain)NSArray* arrCuisine;
@property(nonatomic)BOOL isSelectedAllCuisine;

//temp array and variables
@property(nonatomic, retain)NSMutableArray* arrSelectedCuisine;

//user info
@property(nonatomic, retain) FIRUser *userAccount;
@property(nonatomic, retain) NSString *UserName;
@property(nonatomic, retain) NSString *UserID;
@property(nonatomic, retain) NSString *UserPhotoURL;
@property(nonatomic, retain) UserInfo *user;
@property(nonatomic, retain) NSError* Acterror;
//pay info
//@property(nonatomic, retain) NSMutableArray *paydates;
//@property(nonatomic, retain) NSMutableArray *payamounts;

//registered restaurant info(names)
//@property(nonatomic, retain) NSMutableArray *registeredRestaurants;

//selected restaurant info
//@property (nonatomic,retain)RestaurantInfo *resSelectedRestaurantInfo;

//offset in yelp search result
@property(nonatomic)int offsetNumber;
//@property (nonatomic,retain)NSMutableArray *businessArray;
@property(nonatomic)int intSearchOption1;
@property(nonatomic)int intSearchOption2;
//@property (nonatomic,retain)NSMutableArray *arrRestaurantData;
@property (nonatomic, retain)NSString *term;
@property (nonatomic, retain)NSString *location;
@property(nonatomic)BOOL IsMatch;

//manager mail
@property (nonatomic, retain)NSString *managerMail;
@property (nonatomic) BOOL isManager;

//location
@property (nonatomic) float myLatitude;
@property (nonatomic) float mylongitued;

-(void)addTabBar;
@end

