
@import Firebase;
#import <Foundation/Foundation.h>

@interface Request : NSObject
+ (FIRDatabaseReference*)dataref;
+ (FIRStorageReference*)storageref;
+ (FIRUser*)currentUser;
+ (NSString*)currentUserUid;
+ (void)saveUserEmail:email;
+ (void)saveUserName:name;

//manager
+ (NSError*)saveManagerCardInfo:number cvid:cvid date:date;
+ (void)saveManagerEmail:email;
+ (void)saveManagerName:name;
+ (void)upDateManagerAccount:mangerID email:email name:name;
+(void)registerUser:name email:email image:image;
+ (NSError*)saveCardInfo:number cvid:cvid date:date membership:membership;
+ (void)cancelMembership;
+ (void)saveRestaurantData:dicRestaurantData;
+ (void)saveUserPhoto:UserPhotoURL;
+ (void)retrieveAllRestaurantsData;
+ (void)addCuisineType: (NSArray*)cuisineArray;

@end
