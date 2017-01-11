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
#import "PayHistoryCollectionReusableView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
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
    NSDictionary *payDic = [app.arrPayDictinaryData objectAtIndex:indexPath.section];
    NSArray *payData = [payDic objectForKey:@"pay info"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
     ;
    NSString* amount =(NSString*)[[payData objectAtIndex:indexPath.row]objectForKey:@"amount"];
    Amount.text =  [NSString stringWithFormat:@"$%@",amount];
    NSDate *datePay = (NSDate*)[[payData objectAtIndex:indexPath.row] objectForKey:@"date"];
    memberShip.text = [NSString stringWithFormat:@"$%@ / Month : %d%%", amount,2*[amount intValue]];
    date.text = [dateFormatter stringFromDate: datePay];
    return  cell;

}


- (CGFloat)collectionView: (UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    //hederview processig
    if (kind == UICollectionElementKindSectionHeader) {
        NSURL *photoURL;
        NSString *name = [[app.arrPayDictinaryData objectAtIndex:indexPath.section] objectForKey:@"name"];
        if ([[app.arrPayDictinaryData objectAtIndex:indexPath.section] objectForKey:@"photourl"]) {
            photoURL = [[NSURL alloc]initWithString:[[app.arrPayDictinaryData objectAtIndex:indexPath.section] objectForKey:@"photourl"]];
        }
        
        PayHistoryCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"payheaerview" forIndexPath:indexPath];
        headerView.lableName.text = name;
        [headerView.imagePhoto sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"person0.jpg"]];
        
        reusableview = headerView;
    }
    
//    if (kind == UICollectionElementKindSectionFooter) {
//        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//        
//        reusableview = footerview;
//    }
    
    return reusableview;
}
- (IBAction)goSideMenu:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}
- (void) viewWillAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    [self.imgPhoto sd_setImageWithURL:app.user.photoURL placeholderImage:[UIImage imageNamed:@"person0.jpg"]];
}



@end
