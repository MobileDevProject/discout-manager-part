//
//  UserInfo.m
//  OnGo
//
//  Created by star on 2/15/16.
//  Copyright © 2016 star. All rights reserved.
//

//#define CONFIG_KEY_USER_INFO        @"UserInfo"


#import "UserInfo.h"


@implementation UserInfo

- (instancetype) initWithDictionary:(NSDictionary*) dict {

    self = [super init];
    
    if (self) {
        self.userId = dict[@"id"];
        self.email = dict[@"email"];
        self.name = dict[@"name"];
        self.photoURL = dict[@"photo URL"];
        self.membership = dict[@"membership"] ? dict[@"membership"] : nil;
        self.cardCVID = dict[@"card cvid"] ? dict[@"card cvid"] : nil;
        self.cardDate = dict[@"card date"] ? dict[@"card date"] : nil;
        self.cardNumber = dict[@"card number"] ? dict[@"card number"] : nil;
        self.payData = dict[@"pay info"] ? dict[@"pay info"] : nil;
        self.isCancelled = dict[@"isCancelled"];
    }
    
    return self;
}



@end
