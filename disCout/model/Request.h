//
//  Request.h
//  disCout
//
//  Created by Theodor Hedin on 9/25/16.
//  Copyright © 2016 THedin. All rights reserved.
//
@import Firebase;
#import <Foundation/Foundation.h>

@interface Request : NSObject
+ (FIRDatabaseReference*)dataref;
+ (FIRStorageReference*)storageref;
+ (FIRUser*)currentUser;
+ (NSString*)currentUserUid;
+ (void)saveUserEmail:email;
+ (void)saveUserName:name;
+ (NSError*)saveCardInfo:number cvid:cvid date:date membership:membership;
+ (void)cancelMembership;
//+ (NSError)
+ (void)saveRestaurantData:dicRestaurantData;
+ (void)saveUserPhoto:UserPhotoURL;
//+ (void)retrieveAllRestaurantsID;
+ (void)retrieveAllRestaurantsData;

@end
