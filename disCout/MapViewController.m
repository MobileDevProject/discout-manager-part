//
//  MapViewController.m
//  disCout
//
//  Created by Theodor Hedin on 8/7/16.
//  Copyright © 2016 THedin. All rights reserved.
//

#import "MapViewController.h"
#import "LocationMapOfRestaurants.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RestaurantInfoViewController.h"
#import "actvatedRestaurantListViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "Annotation.h"
@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate> {
    NSMutableArray *arrRestaurantData;
    float preValue;
    UIViewController *previousController;
    NSMutableArray *annotations;
}
#define METERS_PER_MILE 1609.344

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property BOOL mapDidLoadForFirstTime;
@property (nonatomic,retain) AppDelegate *app;
@end

@implementation MapViewController
@synthesize mapView;

- (void)viewDidLoad{

    self.locationManager = [[CLLocationManager alloc] init];
    _app = [UIApplication sharedApplication].delegate;
    // pop back to previous controller
    arrRestaurantData = [[NSMutableArray alloc]initWithArray:self.app.arrRegisteredDictinaryRestaurantData];

    float lati = [[(NSDictionary*)[arrRestaurantData firstObject] objectForKey:@"latitude"] floatValue];
    float longgi = [[(NSDictionary*)[arrRestaurantData firstObject] objectForKey:@"longitude"] floatValue];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(lati, longgi), 2000, 2000);
    [self.mapView setRegion:region animated:YES];
    
    //set tabbar
    [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"NearMe_Active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setImage:[[UIImage imageNamed:@"NearMe_InActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setTitle:@"NEAR ME"];
    [self.tabBarItem setTitleTextAttributes:@{
                                              NSFontAttributeName: [UIFont fontWithName:@"GRAYSTROKE" size:10],
                                              NSForegroundColorAttributeName: [UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]
                                              } forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:@{
                                              NSFontAttributeName: [UIFont fontWithName:@"GRAYSTROKE" size:10],
                                              NSForegroundColorAttributeName: [UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]
                                              } forState:UIControlStateSelected];
}
- (void) getCurrentLocation {
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController * loginErrorAlert = [UIAlertController
                                           alertControllerWithTitle:@"Error obtraining location:"
                                           message:error.localizedDescription
                                           preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:loginErrorAlert animated:YES completion:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //NSLog(@"reset password cancelled.");
        [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    [loginErrorAlert addAction:ok];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.app.myLatitude = currentLocation.coordinate.longitude;
        self.app.mylongitued = currentLocation.coordinate.longitude;
    }
    [self.locationManager stopUpdatingLocation];
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    //MyPin.pinColor = MKPinAnnotationColorPurple;
    
    UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[advertButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    MyPin.rightCalloutAccessoryView = advertButton;
    MyPin.draggable = YES;
    MyPin.animatesDrop=TRUE;
    MyPin.canShowCallout = YES;
    MyPin.highlighted = NO;
    //MyPin.image = [UIImage imageNamed:@"Pin.png"];
    
    return MyPin;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    //int d = 9;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    //int  nn = 9;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    self.app.selectedResNumberFromResList = [(Annotation*)[view annotation] number];
    self.app.dicRestaurantData = [[NSDictionary alloc]initWithDictionary:[arrRestaurantData objectAtIndex:self.app.selectedResNumberFromResList] copyItems:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestaurantInfoViewController *restaurantInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantInfoViewController"];
    [self.navigationController pushViewController:restaurantInfoViewController animated:YES];
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay

{
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:(MKCircle *)overlay] ;
    circleView.fillColor = [UIColor colorWithRed:242.0f/255.0f green:101.0f/255.0f blue:34.0f/255.0f alpha:0.2];
    return circleView;
}



- (void)viewWillAppear:(BOOL)animated{
    [self getCurrentLocation];
    MKCoordinateRegion Bridge = { {self.app.myLatitude, self.app.mylongitued} , {0.0, 0.0} };
    [mapView setDelegate:self];
    arrRestaurantData = [[NSMutableArray alloc]initWithArray:self.app.arrRegisteredDictinaryRestaurantData];
    [mapView removeAnnotations:mapView.annotations];
    
    for (int count = 0; arrRestaurantData.count>count ; count++) {
        float lati = [[(NSDictionary*)[arrRestaurantData objectAtIndex:count] objectForKey:@"latitude"] floatValue];
        float longgi = [[(NSDictionary*)[arrRestaurantData objectAtIndex:count] objectForKey:@"longitude"] floatValue];
        Bridge.center.latitude = lati;
        Bridge.center.longitude = longgi;
        Bridge.span.longitudeDelta = 0.01f;
        Bridge.span.latitudeDelta = 0.01f;
        Annotation *ann = [[Annotation alloc] init];
        NSDictionary *dicRestaurantData = (NSDictionary*)[arrRestaurantData objectAtIndex:count];
        ann.title = [dicRestaurantData objectForKey:@"name"];
        ann.subtitle = [dicRestaurantData objectForKey:@"display_phone"];
        ann.subtitle = (NSString*)[dicRestaurantData objectForKey:@"address"];
        ann.url = [dicRestaurantData objectForKey:@"mobile_url"];
        ann.number = count;
        [ann setValue:ann.url forKey:@"url"];
        ann.coordinate = Bridge.center;
        [mapView addAnnotation:ann];
        
    }
    float lati = [[(NSDictionary*)[arrRestaurantData firstObject] objectForKey:@"latitude"] floatValue];
    float longgi = [[(NSDictionary*)[arrRestaurantData firstObject] objectForKey:@"longitude"] floatValue];
    
    
    [mapView removeOverlay:[[mapView overlays] firstObject]];
    CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(lati, longgi);
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:300];
    [mapView addOverlay: circle];
    
    //update my location
    [self getCurrentLocation];
    
}
- (IBAction)goSlide:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}
@end
