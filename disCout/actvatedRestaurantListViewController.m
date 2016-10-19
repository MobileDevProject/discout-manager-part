//
//  actvatedRestaurantListViewController.m
//  disCout
//
//  Created by Theodor Hedin on 9/25/16.
//  Copyright © 2016 THedin. All rights reserved.
//

#import "Request.h"
#import "AppDelegate.h"
#import "YPAPISample.h"
#import "RestaurantInfoViewController.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LocationMapOfRestaurants.h"
#import "SWRevealViewController.h"
@import Firebase;
#import "actvatedRestaurantListViewController.h"
@interface actvatedRestaurantListViewController ()
{
    int count;
    AppDelegate *app;
    NSArray *ArrResThumbnailsName;
    NSArray *ArrResNames;
    NSMutableArray* registeredRestaurants;
    NSMutableArray *muarResName;
    
    NSArray *businessArray;
    bool *checkScroll;
}
@property (weak, nonatomic) IBOutlet UICollectionView *tableResList;

@end

@implementation actvatedRestaurantListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    app = [UIApplication sharedApplication].delegate;
    
    
    checkScroll = false;
//    if (self.revealViewController != nil) {
//        menuButton.target = self.revealViewController()
//        menuButton.action = "revealToggle:"
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//    }
    
    ///
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.MyTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"mytabbarController"];
    
    
    actvatedRestaurantListViewController *restaurantListViewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"actvatedRestaurantListViewController"];
    MapViewController *mapViewController = [storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    SearchViewController *SearchViewController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    AllPayHistoryViewController *allPayHistoryViewController = [storyboard instantiateViewControllerWithIdentifier:@"AllPayHistoryViewController"];
    //[signUp setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Mycard" image:[UIImage imageNamed:@"MyCard_InActive.png"] selectedImage:[UIImage imageNamed:@"MyCard_Active.png"]]];
    
    UINavigationController *navActivity = [[UINavigationController alloc]initWithRootViewController:restaurantListViewcontroller];
    
    UINavigationController *navNearMe = [[UINavigationController alloc]initWithRootViewController:mapViewController];
    UINavigationController *navMyCard = [[UINavigationController alloc]initWithRootViewController:allPayHistoryViewController];
    UINavigationController *navSearch = [[UINavigationController alloc]initWithRootViewController:SearchViewController];
    NSArray *navViewControllers = [[NSArray alloc]initWithObjects:navActivity, navNearMe, navMyCard, navSearch, nil];
    [navActivity setNavigationBarHidden:YES];
    [navNearMe setNavigationBarHidden:YES];
    [navMyCard setNavigationBarHidden:YES];
    [navSearch setNavigationBarHidden:YES];
    
    
    
    
    [self.MyTabBarController setViewControllers:navViewControllers animated:YES];
    UITabBar *tabbar = [self.MyTabBarController tabBar];
    CGRect frame = CGRectMake(0.0, 0.0, self.MyTabBarController.view.bounds.size.width, 60);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    [v setBackgroundColor:[UIColor colorWithRed:0.2117 green:0.2117 blue:0.2117 alpha:1] ];
    [[self.MyTabBarController tabBar] addSubview:v];
    
    // Change the title color of tab bar items
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    
    UITabBarItem *tab1 = [tabbar.items objectAtIndex:0];
    [tab1 setSelectedImage:[[UIImage imageNamed:@"Activity_Active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab1 setImage:[[UIImage imageNamed:@"Activity_InActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab1 setTitle:@"ACTIVITY"];
    
    UITabBarItem *tab2 = [tabbar.items objectAtIndex:1];
    [tab2 setSelectedImage:[[UIImage imageNamed:@"NearMe_Active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab2 setImage:[[UIImage imageNamed:@"NearMe_InActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab2 setTitle:@"NEAR ME"];
    
    UITabBarItem *tab3 = [tabbar.items objectAtIndex:2];
    [tab3 setSelectedImage:[[UIImage imageNamed:@"MyCard_Active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab3 setImage:[[UIImage imageNamed:@"MyCard_InActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab3 setTitle:@"MY CARD"];
    
    UITabBarItem *tab4 = [tabbar.items objectAtIndex:3];
    [tab4 setSelectedImage:[[UIImage imageNamed:@"Search_Active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab4 setImage:[[UIImage imageNamed:@"Search_InActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tab4 setTitle:@"SEARCH"];
     [self.MyTabBarController setSelectedIndex:0];
    */
    
    [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Activity_Active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setImage:[[UIImage imageNamed:@"Activity_Inactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setTitle:@"ACTIVITY"];
    [self.tabBarItem setTitleTextAttributes:@{
                                              NSFontAttributeName: [UIFont fontWithName:@"Avenir Next LT Pro" size:10],
                                              NSForegroundColorAttributeName: [UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]
                                              } forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:@{
                                              NSFontAttributeName: [UIFont fontWithName:@"Avenir Next LT Pro" size:10],
                                              NSForegroundColorAttributeName: [UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]
                                              } forState:UIControlStateSelected];
    
}
- (void)viewWillAppear:(BOOL)animated{
    registeredRestaurants = [[NSMutableArray alloc]init];
    for (int count1 = 0; app.arrRegisteredDictinaryRestaurantData.count>count1; count1++) {
        NSString *name = [[app.arrRegisteredDictinaryRestaurantData objectAtIndex:count1] objectForKey:@"name"];
        [registeredRestaurants addObject:name];
    }
    [self.tableResList reloadData];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return app.arrRegisteredDictinaryRestaurantData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    //retrieve registered restaurants
    
    
    
    
    static NSString *identifier = @"resCell";
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *resAddress = (UILabel *)[cell viewWithTag:101];
    NSDictionary *dice = (NSDictionary*)[app.arrRegisteredDictinaryRestaurantData objectAtIndex:indexPath.row];
    resAddress.text = (NSString*)[dice objectForKey:@"address"];
    
    UILabel *membershipLabel= (UILabel *)[cell viewWithTag:102];
    [membershipLabel setHidden:YES];
    
    UIImageView *resImageView = (UIImageView *)[cell viewWithTag:103];
    [resImageView sd_setImageWithURL:[NSURL URLWithString:[[app.arrRegisteredDictinaryRestaurantData objectAtIndex:indexPath.row] objectForKey:@"image_url"]]
                    placeholderImage:[UIImage imageNamed:@"Splash.png"]];
    
    UILabel *resName = (UILabel *)[cell viewWithTag:104];
    resName.text = [[app.arrRegisteredDictinaryRestaurantData objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    UIImageView *resRatingImageView = (UIImageView *)[cell viewWithTag:105];
    [resRatingImageView sd_setImageWithURL:[NSURL URLWithString:[[app.arrRegisteredDictinaryRestaurantData objectAtIndex:indexPath.row] objectForKey:@"rating_img_url"]]
                          placeholderImage:[UIImage imageNamed:@"Splash.png"]];
    
    UILabel *reviewCount = (UILabel *)[cell viewWithTag:106];
    reviewCount.text = [NSString stringWithFormat:@"%@ reviews",[[app.arrRegisteredDictinaryRestaurantData objectAtIndex:indexPath.row] objectForKey:@"review_count"]];
    
    UILabel *resCategories = (UILabel *)[cell viewWithTag:107];
    resCategories.text = [[app.arrRegisteredDictinaryRestaurantData objectAtIndex:indexPath.row] objectForKey:@"categories"];
    
    UILabel *resPhoneNumber = (UILabel *)[cell viewWithTag:109];
    resPhoneNumber.text = [[app.arrRegisteredDictinaryRestaurantData objectAtIndex:indexPath.row] objectForKey:@"display_phone"];
    
    UIImageView *regImageView = (UIImageView *)[cell viewWithTag:110];
    [regImageView setHidden:NO];
//    for (int i = 0; registeredRestaurants.count>i; i++) {
//        
//        if ([[muarResName objectAtIndex:indexPath.row] isEqualToString:[registeredRestaurants objectAtIndex:i]]) {
//            [regImageView setHidden:NO];
//            
//            continue;
//        }
//        
//    }
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    app.selectedResNumberFromResList = (int)indexPath.row;
    app.dicRestaurantData = [[NSDictionary alloc]initWithDictionary:[app.arrRegisteredDictinaryRestaurantData objectAtIndex:app.selectedResNumberFromResList] copyItems:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestaurantInfoViewController *restaurantInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantInfoViewController"];
    [self.navigationController pushViewController:restaurantInfoViewController animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width, 100);
}
- (IBAction)exchangeMap:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationMapOfRestaurants *restaurantInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"LocationMapOfRestaurants"];
    [self.navigationController pushViewController:restaurantInfoViewController animated:YES];
}
- (IBAction)Sort:(UIButton *)sender {
    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    app.arrRegisteredDictinaryRestaurantData = [[NSMutableArray alloc]initWithArray:[app.arrRegisteredDictinaryRestaurantData sortedArrayUsingDescriptors:@[descriptor]]];
    [self.tableResList reloadData];
}
- (IBAction)goSlide:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}

@end
