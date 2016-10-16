//
//  PlaceAnnotation.h
//  disCout
//
//  Created by Theodor Hedin on 8/7/16.
//  Copyright © 2016 THedin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface PlaceAnnotation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, retain) NSURL *url;
@end
