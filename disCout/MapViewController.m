//
//  MapViewController.m
//  disCout
//
//  Created by Theodor Hedin on 8/7/16.
//  Copyright © 2016 THedin. All rights reserved.
//

#import "MapViewController.h"
#import "NearMeListViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RestaurantInfoViewController.h"
#import "actvatedRestaurantListViewController.h"
#import "restaurantListViewcontroller.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "Annotation.h"


@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate> {
    NSMutableArray *arrRestaurantData;
    float preValue;
    UIViewController *previousController;
    NSMutableArray *annotations;
    Boolean checkMyLocation;
    MKUserLocation * MyCoordinate;
    float currentRadius;
}
#define METERS_PER_MILE 1609.344

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *lblMDistance;
@property (strong, nonatomic) IBOutlet UISlider *sliderMDistanceControl;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property BOOL mapDidLoadForFirstTime;
@property (nonatomic,retain) AppDelegate * app;
@end

@implementation MapViewController
@synthesize mapView;
@synthesize locationManager = _locationManager;
- (void)viewDidLoad{
    checkMyLocation = YES;
    //set the search radius as 1000m
    currentRadius = 2000;
    mapView.delegate =self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.mapView.delegate = self;
    self.mapView.showsBuildings = NO;
    self.mapView.pitchEnabled = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.rotateEnabled = YES;
    self.mapView.showsUserLocation = YES;
    
    [self.sliderMDistanceControl setMaximumValue:100.0f];
    [self.sliderMDistanceControl setMinimumValue:0.0f];
    [self.sliderMDistanceControl setValue:20.0f animated:YES];
    [self.sliderMDistanceControl setThumbTintColor:[UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]];
    [self.sliderMDistanceControl setTintColor:[UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]];
    [self ChangeMDistanceSearch:self.sliderMDistanceControl];
    
    self.app = [[UIApplication sharedApplication] delegate];
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
                                              NSFontAttributeName: [UIFont fontWithName:@"Avenir Next LT Pro" size:10],
                                              NSForegroundColorAttributeName: [UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]
                                              } forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:@{
                                              NSFontAttributeName: [UIFont fontWithName:@"Avenir Next LT Pro" size:10],
                                              NSForegroundColorAttributeName: [UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]
                                              } forState:UIControlStateSelected];
}


#pragma mark - CLLocationManagerDelegate
- (CLLocationManager*)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = (METERS_PER_MILE * 5.0);
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.activityType = CLActivityTypeOtherNavigation;
    }
    
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // once we know where we are, we don't need to keep the location services running,
    // so stop it
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    
    [self.mapView setCenterCoordinate:location.coordinate animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(error)
        NSLog(@"[%@ %@] error(%ld): %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), (long)[error code],
              [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            
            [self.locationManager startUpdatingLocation];
            break;
            
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        default:
            
            [self.locationManager stopUpdatingLocation];
            break;
    }
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MyCoordinate = userLocation;
    if (checkMyLocation) {
        MKCoordinateRegion region = [self createViewableRegionForLocation:userLocation.coordinate andDistance:2000/METERS_PER_MILE];
        [self.mapView setRegion:region animated:YES];
    }
    checkMyLocation = NO;
    
}
- (MKCoordinateRegion)createViewableRegionForLocation:(CLLocationCoordinate2D)coordinate andDistance:(CLLocationDistance)distance
{
    CLLocationDirection latInMeters = distance*METERS_PER_MILE;
    CLLocationDirection longInMeters = distance*METERS_PER_MILE;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, latInMeters, longInMeters);
    float lati = coordinate.latitude;
    float longgi = coordinate.longitude ;
    
    
    [mapView removeOverlay:[[mapView overlays] firstObject]];
    CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(lati, longgi);
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:distance*METERS_PER_MILE];
    [mapView addOverlay: circle];
    
    return region;
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *MyPin;
    
    if (![[[annotation title] uppercaseString] isEqualToString: [@"My Location" uppercaseString]]) {
        
        MyPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
        UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //[advertButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        MyPin.rightCalloutAccessoryView = advertButton;
        MyPin.draggable = YES;
        MyPin.animatesDrop=TRUE;
        MyPin.canShowCallout = YES;
        MyPin.highlighted = NO;
        MyPin.image = [UIImage imageNamed:@"Pin.png"];
    }else{
        
    }
    
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

-(float)kilometersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to  {
    
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest]/1000;
    
    //NSLog(@"%f",dist);
    NSString *distance = [NSString stringWithFormat:@"%f",dist];
    
    return [distance floatValue];
    
}

- (void)viewWillAppear:(BOOL)animated{
    checkMyLocation = YES;
    [self.locationManager startUpdatingLocation];
    
    MKCoordinateRegion Bridge = { {self.app.myLatitude, self.app.mylongitued} , {0.0, 0.0} };
    //[mapView setDelegate:self];
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
    
    
    
}
- (IBAction)ChangeMDistanceSearch:(UISlider *)sender {
    
    preValue = sender.value;
    if ((int)(sender.value) % 2 == 0) {
        self.app.arrTempSearchedDictinaryRestaurantData = [[NSMutableArray alloc]init];
        [mapView removeOverlay:[[mapView overlays] firstObject]];
        //temp
        //float lati = [[self.app.arrRegisteredDictinaryRestaurantData.firstObject objectForKey:@"latitude"] floatValue];
        //float longi = [[self.app.arrRegisteredDictinaryRestaurantData.firstObject objectForKey:@"longitude"] floatValue];
        //CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(lati, longi);
        //filter with distance
        
        //MyCoordinate.coordinate = CLLocationCoordinate2DMake(lati, longi);
        //temp
        // draw circle at my location
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:MyCoordinate.coordinate radius:sender.value*100];
        [mapView addOverlay: circle];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:2];
        NSString *formattedNumber = [formatter stringFromNumber:@(sender.value/10)];
        self.lblMDistance.text = [NSString stringWithFormat:@"%@ Km", formattedNumber];

        for (NSDictionary *RestaurantData in self.app.arrRegisteredDictinaryRestaurantData) {
            float resLati = [[RestaurantData objectForKey:@"latitude"] floatValue];
            float resLong = [[RestaurantData objectForKey:@"longitude"] floatValue];
            float distance = [self kilometersfromPlace:MyCoordinate.coordinate andToPlace:CLLocationCoordinate2DMake(resLati, resLong)];
            if (distance<[formattedNumber floatValue]) {
                [self.app.arrTempSearchedDictinaryRestaurantData addObject:RestaurantData];
            }
        }
    }
    
}
- (IBAction)ExchangeMMapList:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NearMeListViewController *nearMeListViewController = [storyboard instantiateViewControllerWithIdentifier:@"NearMeListViewController"];
    [self.navigationController pushViewController:nearMeListViewController animated:YES];
    
}
- (IBAction)goSlide:(UIButton *)sender {
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    [self.navigationController.revealViewController rightRevealToggle:nil];
}
@end
