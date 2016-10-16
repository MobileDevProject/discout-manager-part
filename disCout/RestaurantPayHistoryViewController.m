//
//  RestaurantPayHistoryViewController.m
//  disCout
//
//  Created by Theodor Hedin on 9/25/16.
//  Copyright © 2016 THedin. All rights reserved.
//
#import "Request.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "RestaurantPayHistoryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface RestaurantPayHistoryViewController ()
{
    AppDelegate *app;
    int childCount;
}
@property (strong, nonatomic) IBOutlet UICollectionView *payHistoryTableView;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UILabel *JobID;
@property (strong, nonatomic) IBOutlet UILabel *Membership;
@property (strong, nonatomic) IBOutlet UILabel *UserName;

@end

@implementation RestaurantPayHistoryViewController

- (void) viewDidLoad{
    app = [UIApplication sharedApplication].delegate;
    childCount = 1;
    self.JobID.text = [Request currentUserUid];
    self.UserName.text = app.user.name;
    self.Membership.text = app.user.membership;
    [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"MyCard_Active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setImage:[[UIImage imageNamed:@"MyCard_InActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setTitle:@"MY CARD"];
//    [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"MyCard_Active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [self.tabBarItem setImage:[[UIImage imageNamed:@"MyCard_InActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [self.tabBarItem setTitle:@"MY CARD"];
    [self.imgPhoto sd_setImageWithURL:app.user.photoURL placeholderImage:[UIImage imageNamed:@"person0.jpg"]];
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return app.arrPayDictinaryData.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[app.arrPayDictinaryData objectAtIndex:section] objectForKey:@"pay info"] count] ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    static NSString *identifier = @"payCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UILabel *date = (UILabel *)[cell viewWithTag:101];
    UILabel *Amount = (UILabel *)[cell viewWithTag:102];
    UILabel *memberShip = (UILabel *)[cell viewWithTag:103];
    NSDictionary *PersonPayData = [[app.arrPayDictinaryData objectAtIndex:indexPath.section] objectForKey:@"pay info"];
    NSString *datetext = [NSString stringWithFormat:@"%@", [[PersonPayData allKeys] objectAtIndex:indexPath.row]] ;
    datetext = [NSString stringWithFormat:@"%@/%@/%@",[datetext substringWithRange:NSMakeRange(5, 2)], [datetext substringWithRange:NSMakeRange(8, 2)], [datetext substringWithRange:NSMakeRange(0, 4)]];
    date.text = datetext;
    NSString *amount = [PersonPayData objectForKey:[[PersonPayData allKeys] objectAtIndex:indexPath.row]];
    Amount.text =  [NSString stringWithFormat:@"$%@",amount];
    
    memberShip.text = [NSString stringWithFormat:@"$%@ / Month : %d%%", amount, 2*[amount intValue]];
    return  cell;
    
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    RestaurantPayHistoryViewController *restaurantInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantPayHistoryViewController"];
//    [self.navigationController pushViewController:restaurantInfoViewController animated:YES];
//}

- (CGFloat)collectionView: (UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (IBAction)goSideMenu:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}
- (void) viewWillAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
}



@end
