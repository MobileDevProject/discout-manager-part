
#import <UIKit/UIKit.h>
#import "UserInfo.h"
@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate>


//search result
@property (strong, nonatomic)UIWindow *window;
@property (nonatomic,retain)NSDictionary *dicRestaurantData;
@property (nonatomic)int selectedResNumberFromResList;
@property (nonatomic,retain)NSMutableArray *arrSearchedDictinaryRestaurantData;
@property (nonatomic,retain)NSMutableArray *arrTempSearchedDictinaryRestaurantData;
@property (nonatomic,retain)NSMutableArray *arrRegisteredDictinaryRestaurantData;
@property (nonatomic,retain)NSMutableArray *arrPayDictinaryData;//dic->user, user->paydate and payamount

@property(nonatomic, retain) UITabBarController *MyTabBarController;

//cuisine type
@property(nonatomic, retain)NSMutableArray* arrCuisine;
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

//offset in yelp search result
@property(nonatomic)int offsetNumber;

@property(nonatomic)int intSearchOption1;
@property(nonatomic)int intSearchOption2;

@property (nonatomic, retain)NSString *term;
@property (nonatomic, retain)NSString *location;
@property(nonatomic)BOOL IsMatch;

//manager mail
@property (nonatomic, retain)NSString *managerMail;
@property (nonatomic) BOOL isManager;
@property (nonatomic) BOOL boolOncePassed;

//location
@property (nonatomic) float myLatitude;
@property (nonatomic) float mylongitued;

-(void)addTabBar;
@end

