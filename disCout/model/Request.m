
#import "AppDelegate.h"
#import "Request.h"
FIRDatabaseReference *ref;
@implementation Request

//Firebase
+ (FIRDatabaseReference*)dataref{
    return [[FIRDatabase database] reference];
}
+ (FIRStorageReference*)storageref{
    return [[FIRStorage storage] referenceForURL:@"gs://discout-a93e0.appspot.com"];
}
+ (FIRUser*)currentUser{
    return [FIRAuth auth].currentUser;
}
+ (NSString*)currentUserUid{
    return [FIRAuth auth].currentUser.uid;
}
+ (void)saveUserEmail:email{
    FIRDatabaseReference* ref = [[[[[[FIRDatabase database] reference] child:@"users"] child:[self currentUserUid]]child:@"general info" ] child:@"email"] ;
    [ref setValue:(NSString*)email];
    //[[[[[self dataref] child:@"users"] child:[self currentUserUid] ] child:@"email"] setValue:(NSString*)email];
}
+ (void)saveUserName:name{
    [[[[[[[FIRDatabase database] reference] child:@"users"] child:[self currentUserUid]]child:@"general info" ] child:@"name"] setValue:(NSString*)name];
}

//save manager
+ (void)saveManagerEmail:email{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    FIRDatabaseReference* ref = [[[[[FIRDatabase database] reference] child:@"manager"] child:app.user.userId]child:@"email"] ;
    [ref setValue:(NSString*)email];
}
+ (void)saveManagerName:name{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    FIRDatabaseReference* ref = [[[[[FIRDatabase database] reference] child:@"manager"] child:app.user.userId]child:@"name"] ;
    [ref setValue:(NSString*)name];
}

+ (NSError*)saveManagerCardInfo:number cvid:cvid date:date{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [[[[[self dataref] child:@"manager"] child:[self currentUserUid] ]child:@"cardcvid"] setValue:cvid withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        app.Acterror = error;
    }];
    [[[[[self dataref] child:@"manager"] child:[self currentUserUid] ]child:@"cardnumber"] setValue:number withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        app.Acterror = error;
    }];
    [[[[[self dataref] child:@"manager"] child:[self currentUserUid] ] child:@"carddate"] setValue:date withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        app.Acterror = error;
    }];
    return app.Acterror;
}
+ (void)getManagerCardInfoFromDatabase{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    FIRDatabaseReference *cvidref = [[[[self dataref] child:@"manager"] child:[self currentUserUid] ]child:@"cardcvid"];
    [cvidref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        app.user.cardCVID = snapshot.value;
    }];
    
    FIRDatabaseReference *numberref = [[[[self dataref] child:@"manager"] child:[self currentUserUid] ]child:@"cardnumber"];
    [numberref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        app.user.cardCVID = snapshot.value;
    }];
    FIRDatabaseReference *dateref = [[[[self dataref] child:@"manager"] child:[self currentUserUid] ]child:@"carddate"];
    [dateref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        app.user.cardCVID = snapshot.value;
    }];

}
+ (void)upDateManagerAccount:mangerID email:email name:name{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    FIRDatabaseReference* ref = [[Request dataref]child:@"manager"];
            NSString* cardCVID = app.user.cardCVID;
            NSString* cardNumber = app.user.cardNumber;
            NSString* cardDate = app.user.cardDate;
            NSString* photoURL = [app.user.photoURL absoluteString];
            photoURL = photoURL ? photoURL: @" ";
                NSString *key = [[ref child:@"manager"] child:mangerID].key;
                NSDictionary *post = @{@"email": email,
                                       @"name": name,
                                       @"photourl": photoURL,
                                       @"cardcvid": cardCVID,
                                       @"cardnumber": cardNumber,
                                       @"carddate": cardDate
                                       };
                NSDictionary *childUpdates = @{key: post};
                [ref updateChildValues:childUpdates];

}
//user
+ (NSError*)saveCardInfo:number cvid:cvid date:date membership:membership{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [[[[[[self dataref] child:@"users"] child:[self currentUserUid] ]child:@"general info" ] child:@"card cvid"] setValue:cvid withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        app.Acterror = error;
    }];
    [[[[[[self dataref] child:@"users"] child:[self currentUserUid] ]child:@"general info" ] child:@"card number"] setValue:number withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        app.Acterror = error;
    }];
    [[[[[[self dataref] child:@"users"] child:[self currentUserUid] ]child:@"general info" ] child:@"card date"] setValue:date withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        app.Acterror = error;
    }];
    [[[[[[self dataref] child:@"users"] child:[self currentUserUid] ]child:@"general info" ] child:@"membership"] setValue:membership withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        app.Acterror = error;
    }];
    [[[[[[self dataref] child:@"users"] child:[self currentUserUid] ]child:@"general info" ] child:@"iscancelled"] setValue:@"true" withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
    }];
    return app.Acterror;
}
+ (void)cancelMembership{
    [[[[[[self dataref] child:@"users"] child:[self currentUserUid] ]child:@"general info" ] child:@"iscancelled"] setValue:@"false" withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        
    }];
}
//manager restaurant
+ (void)saveRestaurantData:dicRestaurantData{
    
    FIRDatabaseReference *allRestaurants = [[self dataref] child:@"restaurants"];
    NSString *restaurantID = [(NSDictionary*)dicRestaurantData objectForKey:@"name"];
    NSDictionary *registerData = [NSDictionary dictionaryWithObjectsAndKeys:restaurantID,dicRestaurantData, nil];
    [allRestaurants setValue:registerData];
}
+ (void)saveUserPhoto:image{
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    FIRStorageReference *photoImagesRef = [storageRef child:[NSString stringWithFormat:@"users photo/%@/photo.jpg", [Request currentUserUid]] ];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    //image compress until size < 1 MB
    int count = 0;
    while ([imageData length] > 1000000) {
        imageData = UIImageJPEGRepresentation(image, powf(0.9, count));
        count++;
        NSLog(@"just shrunk it once.");
    }
    
    // Upload the file to the path "images/userID.PNG"
    [photoImagesRef putData:imageData metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            // Uh-oh, an error occurred!
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            app.user.photoURL = metadata.downloadURL;
            FIRDatabaseReference* savedResData = [[[[[FIRDatabase database] reference]child:@"manager"] child:[Request currentUserUid]]child:@"photoURL"];
            [savedResData setValue:[app.user.photoURL absoluteString]];
            
        }
    }];
    

    
}

//Yelp
+ (void)retrieveAllRestaurantsData{
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    app.arrRegisteredDictinaryRestaurantData = [[NSMutableArray alloc]init];
    FIRDatabaseReference* ref = [[Request dataref]child:@"restaurants"];
    [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary*dic = snapshot.value;
        NSArray *keys;
        if (![dic isKindOfClass:[NSNull class]]) {
            keys = dic.allKeys;
        }
        
        for (int count = 0;keys.count>count;count++) {
            NSDictionary *restaurantData = [dic objectForKey:[keys objectAtIndex:count]];
            [app.arrRegisteredDictinaryRestaurantData addObject:restaurantData];
        }
    }];
}

+(void)registerUser:name email:email image:image{
    
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
    NSString *userId = user.uid;
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storageRef = [storage reference];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        FIRStorageReference *photoImagesRef = [storageRef child:[NSString stringWithFormat:@"users photo/%@/photo.jpg", [Request currentUserUid]] ];
        NSData *imageData = UIImagePNGRepresentation(image);
        
        //image compress until size < 1 MB
        int count = 0;
        while ([imageData length] > 1000000) {
            imageData = UIImageJPEGRepresentation(image, powf(0.9, count));
            count++;
            NSLog(@"just shrunk it once.");
        }
        
        // Upload the file to the path "images/userID.PNG"f
        
        [photoImagesRef putData:imageData metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                changeRequest.displayName = name;
                changeRequest.photoURL = metadata.downloadURL;
                [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            // An error happened.
                            NSLog(@"%@", error.description);
                        } else {
                            // Profile updated.
                            
                            NSDictionary *userData = @{@"name":name,
                                                       @"email":email,
                                                       @"photourl":[metadata.downloadURL absoluteString],
                                                       @"userid":userId,
                                                       @"numberofcomments":@"0"
                                                       };
                            [[[[[FIRDatabase database] reference] child:@"users"] child:userId]setValue:userData];
                            
                        }
                        
                    });
                }];
                
            }
        }];
        
    });
    
    
}

+ (void)addCuisineType: (NSArray*)cuisineArray{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableSet *newCuisine = [NSMutableSet set];
    for (NSString *Cuisine in app.arrCuisine) {
        [newCuisine addObject:Cuisine];
    }
    
    for (NSString *cuisine in cuisineArray) {
        if (![newCuisine containsObject:cuisine]) {
            [app.arrCuisine addObject:cuisine];
        }
    }
    
    FIRDatabaseReference *allRestaurants = [[self dataref] child:@"cuisine"];
    //NSDictionary *registerData = [NSDictionary dictionaryWithObjectsAndKeys:app.arrCuisine,@"cuisine", nil];
    [allRestaurants setValue:app.arrCuisine];
    
}

@end

