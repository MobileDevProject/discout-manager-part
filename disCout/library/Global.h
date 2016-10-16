//
//  Global.h
//  Wowz
//
//  Created by Yosemite on 7/28/15.
//  Copyright (c) 2015 Tommy Rauvola. All rights reserved.
//

#ifndef Wowz_Global_h
#define Wowz_Global_h

#import <Foundation/Foundation.h>

#define IS_RETINA ([UIScreen mainScreen].scale == 2.0f)

//#define SERVER_URL @"http://172.16.1.39:1337/"
#define SERVER_URL @"http://52.90.35.58:1337/"

//#define API_SOCKET_SERVER   @"172.16.1.39"
#define API_SOCKET_SERVER   @"52.90.35.58"
#define API_SOCKET_PORT     1337

// API Service
#define API_ACCESS                  @"api"

#define API_ACTION_LOGIN            @"loginWithEmail"
#define API_ACTION_REGISTER         @"registerWithEmail"
#define API_ACTION_FBLOGIN          @"loginWithFacebook"
#define API_ACTION_SAVE_PROFILE     @"saveProfile"
#define API_ACTION_SAVE_FILTER      @"saveFilterOption"
#define API_ACTION_GET_FILTER       @"fetchFilterOption"
#define API_ACTION_FETCH_ROOMS      @"fetchRoomByUser"
#define API_ACTION_ROOM_BY_USER     @"fetchRoomInfo"
#define API_ACTION_FETCH_ADDRESS    @"fetchAddressInfo"
#define API_ACTION_SAVE_ADDRESS     @"saveAddressInfo"
#define API_ACTION_FETCH_OBJECTS    @"fetchAllObjects"
#define API_ACTION_FETCH_FAVORITES  @"fetchFavoriteObjects"
#define API_ACTION_ADD_FAVORITES    @"addToFavorites"
#define API_ACTION_ADD_BAGS         @"addToBagList"
#define API_ACTION_REMOVE_FAVORITES @"removeFromFavorites"
#define API_ACTION_REMOVE_OBJECT    @"removeObject"
#define API_ACTION_UNREGISTER       @"removeUser"
#define API_ACTION_REMOVE_ROOM      @"removeRoom"

// Socket
#define API_SOCKET_SIGNIN           @"/api/socketSignin"
#define API_SOCKET_FETCH_MESSAGES   @"/api/messages"
#define API_SOCKET_SEND_MESSAGE     @"/api/sendMsg"

// 3rd Party API
#define AWS_COGNITO_KEY             @"us-east-1:70e33175-edee-4204-856c-f25ddc3445cb"
#define AWS_BUCKET_NAME             @"pinresidence"
#define AWS_PHOTO_URL_MACRO         @"https://s3.amazonaws.com/%@/%@/profile_%@.jpg"
#define AWS_FEATURED_URL_MACRO      @"https://s3.amazonaws.com/%@/%@/%@"

// Notification
#define NOTIFICATION_CONNECTED          @"connected"
#define NOTIFICATION_CONNECTION_LOST    @"connection_lost"
#define NOTIFICATION_MESSAGE_SENT       @"message_sent"
#define NOTIFICATION_MESSAGE_READ       @"message_read"
#define NOTIFICATION_CIRCLE_STATUS      @"circle_status"
#define NOTIFICATION_ALL_STATUS         @"all_status"
#define NOTIFICATION_MESSAGE_FETCHED    @"message_fetched"
#define NOTIFICATION_CIRCLE             @"circle"
#define NOTIFICATION_CIRCLE_INVITED     @"circle_invited"
#define NOTIFICATION_UNREAD_MESSAGE     @"unread_message"

#define NOTIFICATION_SIGNIN_REQUIRED    @"SigninRequired"
#define NOTIFICATION_USER_SIGNED_IN     @"UserSignedIn"
#define NOTIFICATION_USER_SIGNED_OUT    @"UserSignedOut"
#define NOTIFICATION_PROFILE_CHANGED    @"profile_changed"

#define NOTIFICATION_GOTO_HOME      @"GotoHome"
#define NOTIFICATION_ARRIVED_HOME   @"ArrivedHome"
#define NOTIFICATION_LEAVED_HOME    @"LeavedHome"

// Socket
#define API_SOCKET_SIGNIN           @"/api/socketSignin"
#define API_SOCKET_FETCH_MESSAGES   @"/api/messages"
#define API_SOCKET_SEND_MESSAGE     @"/api/sendMsg"
#define API_SOCKET_REMOVE_UNREAD    @"/api/removeUnreadFlag"

// Fonts
#define DEFAULT_FONT_LIGHT          @"Avenir Light"
#define DEFAULT_FONT_REGULAR        @"Avenir Book"

// Colors
#define DEFAULT_COLOR_HIGHLITS      0xFF3366
#define DEFAULT_COLOR_TEXT          0x1D1D26
#define DEFAULT_COLOR_DESCRIPTION   0xA8A8AA
#define DEFAULT_COLOR_OTHERH        0x15B0F1

// Constants
#define OBJECT_TYPE_CONDO               @"Condo"
#define OBJECT_TYPE_VILLA               @"Villa"
#define OBJECT_TYPE_SEMI_DETACHED       @"Semi Detached"

// Common

#define CONFIG_KEY_USER_INFO        @"UserInfo"

// Macro
#define SSShowAlertView(title, msg) \
[[[UIAlertView alloc] initWithTitle:(title) message:(msg) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

#define SSShowConnectionErrorAlertView \
[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];


// 3rd Party API Key
#define GOOGLE_MAP_API_KEY          @"AIzaSyDi5oZ0jNxyJBsS7qe1sGrJpN_C-Ai6R9U"

#import "APIService.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "SessionManager.h"
#import "UIColor+Expanded.h"
#import "APISocketManager.h"

#endif
