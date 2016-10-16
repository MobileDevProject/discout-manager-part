//
//  SearchLocationTableViewController.h
//  disCout
//
//  Created by Theodor Hedin on 8/7/16.
//  Copyright © 2016 THedin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchLocationTableViewController : UITableViewController<CLLocationManagerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *places;

@end
