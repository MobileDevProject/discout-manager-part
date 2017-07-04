
#import "SWRevealViewController.h"
#import "LocationMapOfRestaurants.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "restaurantListViewcontroller.h"
#import "RestaurantInfoViewController.h"
#import "actvatedRestaurantListViewController.h"
#import "AppDelegate.h"
#import "Annotation.h"

@interface LocationMapOfRestaurants ()<MKMapViewDelegate> {
    NSMutableArray *arrRestaurantData;
    float preValue;
    UIViewController *previousController;
}
#define METERS_PER_MILE 1609.344

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) NSMutableArray *annotations;
@property BOOL mapDidLoadForFirstTime;
@property (nonatomic,retain) AppDelegate *app;
@end

@implementation LocationMapOfRestaurants

#pragma mark - set environment
- (void)viewWillAppear:(BOOL)animated{
    _app = [UIApplication sharedApplication].delegate;
    arrRestaurantData = [[NSMutableArray alloc]init];
    // check come from search result nor registered restaurant data
    NSArray *myControllers = self.navigationController.viewControllers;
    int previous = (int)myControllers.count - 2;
    previousController = [myControllers objectAtIndex:previous];
    if ([previousController isKindOfClass:[actvatedRestaurantListViewController class]]) {
        arrRestaurantData = self.app.arrRegisteredDictinaryRestaurantData;
    }else{
        arrRestaurantData = self.app.arrSearchedDictinaryRestaurantData;
    }
    
    
    MKCoordinateRegion Bridge = { {0.0, 0.0} , {0.0, 0.0} };
    
    [self.mapView setDelegate:self];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
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
        ann.subtitle = (NSString*)[dicRestaurantData objectForKey:@"address"];;
        ann.url = [dicRestaurantData objectForKey:@"mobile_url"];
        ann.number = count;
        [ann setValue:ann.url forKey:@"url"];
        ann.coordinate = Bridge.center;
        [self.mapView addAnnotation:ann];
    }
    float lati = [[(NSDictionary*)[arrRestaurantData firstObject] objectForKey:@"latitude"] floatValue];
    float longgi = [[(NSDictionary*)[arrRestaurantData firstObject] objectForKey:@"longitude"] floatValue];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(lati, longgi), 2500, 2500);
    [self.mapView setRegion:region animated:YES];
    
}

#pragma mark - MKMapView delegate
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    MyPin.rightCalloutAccessoryView = advertButton;
    MyPin.draggable = YES;
    MyPin.animatesDrop=TRUE;
    MyPin.canShowCallout = YES;
    MyPin.highlighted = NO;
    
    return MyPin;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{

}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{

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

#pragma mark - go back and map - list
- (IBAction)ExchangeMapList:(UIButton *)sender {
    // pop back to previous controller
    NSArray *myControllers = self.navigationController.viewControllers;
    int previous = (int)myControllers.count - 2;
    previousController = [myControllers objectAtIndex:previous];
    if ([previousController isKindOfClass:[actvatedRestaurantListViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([previousController isKindOfClass:[restaurantListViewcontroller class]]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        restaurantListViewcontroller *RestaurantListViewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"restaurantListViewcontroller"];
        [self.navigationController pushViewController:RestaurantListViewcontroller animated:YES];
    }
}

- (IBAction)GoBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goSideMenu:(UIButton *)sender {
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    [self.navigationController.revealViewController rightRevealToggle:nil];
}



@end
