//
//  RestaurantInfoViewController.m
//  disCout
//
//  Created by Theodor Hedin on 8/16/16.
//  Copyright © 2016 THedin. All rights reserved.
//
#import "Request.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "RestaurantInfoViewController.h"
#import "actvatedRestaurantListViewController.h"
#import "LocationMapOfRestaurants.h"
#import "MapViewController.h"
#import "restaurantListViewcontroller.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "webViewController.h"
@interface RestaurantInfoViewController ()
{
    NSString *ResName;
    NSString *ResAddress;
    NSString *ResPostalcode;
    NSString *ResLatitude;
    NSString *ResLonggitude;
    NSString *ResCategories;
    NSString *ResRating;
    NSString *ResSnnipetImageURL;
    NSString *ResRatingImageURL;
    NSString *ResSnippetText;
    NSString *ResDisplayPhone;
    NSString *ResReviewCount;
    NSString *ResMobileURL;
    NSDictionary *dicRestaurantData;
    NSDictionary *tempDic;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imgRestaurnat;
@property (strong, nonatomic) IBOutlet UIImageView *registerMarkImage;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (nonatomic, strong) webViewController* webViewVC;
@property (strong, nonatomic) IBOutlet UIImageView *imgRating;
@property (strong, nonatomic) IBOutlet UILabel *lblResName;
@property (strong, nonatomic) IBOutlet UILabel *lblResAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblResCategories;
@property (strong, nonatomic) IBOutlet UILabel *lblResReviewNumber;

@end

@implementation RestaurantInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.webViewVC = [[webViewController alloc] initWithNibName:@"webViewController" bundle:nil];
    dicRestaurantData = app.dicRestaurantData;
    
    ResName = [dicRestaurantData objectForKey: @"name"];
    ResAddress = [dicRestaurantData objectForKey: @"address"];
    ResPostalcode = [dicRestaurantData objectForKey: @"postal_code"];
    ResLatitude = [dicRestaurantData objectForKey: @"latitude"];
    ResLonggitude = [dicRestaurantData objectForKey: @"longitude"];
    ResCategories = [dicRestaurantData objectForKey: @"categories"];
    ResRating = [dicRestaurantData objectForKey: @"rating"];
    ResSnippetText = [dicRestaurantData objectForKey: @"snnipet_text"];
    ResReviewCount = [dicRestaurantData objectForKey: @"review_count"];
    ResSnnipetImageURL = [dicRestaurantData objectForKey: @"image_url"];
    ResRatingImageURL = [dicRestaurantData objectForKey: @"rating_img_url"];
    
    [self.imgRestaurnat sd_setImageWithURL:[NSURL URLWithString:ResSnnipetImageURL]
                          placeholderImage:[UIImage imageNamed:@"Splash.png"]];
    [self.imgRating sd_setImageWithURL:[NSURL URLWithString:ResRatingImageURL]
                          placeholderImage:[UIImage imageNamed:@"Splash.png"]];
    //check if the restaurant is registered in user database.
    [self.registerMarkImage setImage:[UIImage imageNamed:@"unregisterMark.png"]];
    self.lblResName.text = ResName;
    self.lblResAddress.text = ResAddress;
    self.lblResCategories.text = ResCategories;
    self.lblResReviewNumber.text =[NSString stringWithFormat:@"%@ reviews", ResReviewCount] ;
    
    for (int count1 = 0;app.arrRegisteredDictinaryRestaurantData.count>count1;count1++) {
        if ([[[app.arrRegisteredDictinaryRestaurantData objectAtIndex:count1]objectForKey:@"name"] isEqualToString:ResName]) {
            [self.registerMarkImage setImage:[UIImage imageNamed:@"registerMark.png"]];
            [self.registerButton setBackgroundImage:[UIImage imageNamed:@"btn_Search_Clear.png"] forState:UIControlStateNormal];
            [self.registerButton setTitle:@"REMOVE" forState:UIControlStateNormal];
        }
    }
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)registerRemoveButton:(UIButton *)sender {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
        if ([sender.titleLabel.text isEqualToString:@"REGISTER"]) {
            FIRDatabaseReference* savedResData = [[[[FIRDatabase database] reference]child:@"restaurants"] child:ResName];
            [savedResData setValue:dicRestaurantData];
            [app.arrRegisteredDictinaryRestaurantData addObject:dicRestaurantData];
            [self.navigationController popViewControllerAnimated:YES];
           }
        else{
            UIAlertController * loginErrorAlert = [UIAlertController
                                                   alertControllerWithTitle:@"REMOVE THE RESTAURANT"
                                                   message:@"Are sure remove the restaurant?"
                                                   preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:loginErrorAlert animated:YES completion:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                FIRDatabaseReference* savedResData = [[[Request dataref]child:@"restaurants"] child:ResName];
                [savedResData removeValue];
                
                
                
                NSArray *myControllers = self.navigationController.viewControllers;
                int previous = (int)myControllers.count - 2;
                UIViewController *previousController = [myControllers objectAtIndex:previous];
                if ([previousController isKindOfClass:[actvatedRestaurantListViewController class]] || [previousController isKindOfClass:[MapViewController class]]) {
                [app.arrRegisteredDictinaryRestaurantData removeObjectAtIndex:app.selectedResNumberFromResList];
                }else if([previousController isKindOfClass:[restaurantListViewcontroller class]] || [previousController isKindOfClass:[LocationMapOfRestaurants class]]){
                    //remove the registered restaurant to be matched name.
                    for (int count1 = 0; app.arrRegisteredDictinaryRestaurantData.count>count1; count1++) {
                        if ([[app.arrRegisteredDictinaryRestaurantData objectAtIndex:count1] objectForKey:@"name"]==ResName) {
                            [app.arrRegisteredDictinaryRestaurantData removeObjectAtIndex:count1];
                        }
                    }
                }
                [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
            }];
            [loginErrorAlert addAction:ok];
            [loginErrorAlert addAction:cancel];
            
            
        }
    
    //    self.webViewVC.url = [NSURL URLWithString:[(Annotation*)[view annotation] url]];
    //    [self.navigationController pushViewController:self.webViewVC animated:YES];
}
- (IBAction)goSideMenu:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}

@end
