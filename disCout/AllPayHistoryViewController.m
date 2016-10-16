//
//  AllPayHistoryViewController.m
//  disCout
//
//  Created by Theodor Hedin on 9/25/16.
//  Copyright © 2016 THedin. All rights reserved.
//
@import Firebase;
#import "AppDelegate.h"
#import "Request.h"
#import "RestaurantPayHistoryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SWRevealViewController.h"
#import "AllPayHistoryViewController.h"

@interface AllPayHistoryViewController ()
{
    int childCount;
    NSMutableArray *dates;
    NSMutableArray *amounts;
    AppDelegate *app;
}
@property (strong, nonatomic) IBOutlet UICollectionView *payHistoryTable;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UILabel *JobID;
@property (strong, nonatomic) IBOutlet UILabel *UserName;


@end

@implementation AllPayHistoryViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLoad{
    app = [UIApplication sharedApplication].delegate;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    childCount = 1;
    self.JobID.text = [Request currentUserUid];
    self.UserName.text = app.user.name;

    [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"MyCard_Active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setImage:[[UIImage imageNamed:@"MyCard_InActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setTitle:@"MY CARD"];
    [self.imgPhoto sd_setImageWithURL:app.user.photoURL placeholderImage:[UIImage imageNamed:@"person0.jpg"]];


}

//                    NSMutableArray *dates = [[NSMutableArray alloc]initWithArray:[payData allKeys]];
//                    NSMutableArray *amounts = [[NSMutableArray alloc]init];
//                    for (int count1= 0; dates.count>count1; count1++) {
//                        [amounts addObject:[payData objectForKey:[dates objectAtIndex:count1]]];
//                    }
//NSDictionary* PersonPayData = [[NSDictionary alloc]initWithObjectsAndKeys:userName, @"name", payData,@"pay info", nil];
//[app.arrPayDictinaryData addObject:PersonPayData];

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
    UILabel *resName = (UILabel *)[cell viewWithTag:103];
    NSDictionary *PersonPayData = [[app.arrPayDictinaryData objectAtIndex:indexPath.section] objectForKey:@"pay info"];
    NSString *datetext = [NSString stringWithFormat:@"%@", [[PersonPayData allKeys] objectAtIndex:indexPath.row]] ;
    datetext = [NSString stringWithFormat:@"%@/%@/%@",[datetext substringWithRange:NSMakeRange(5, 2)], [datetext substringWithRange:NSMakeRange(8, 2)], [datetext substringWithRange:NSMakeRange(0, 4)]];
    date.text = datetext;
    Amount.text =  [NSString stringWithFormat:@"$%@",[PersonPayData objectForKey:[[PersonPayData allKeys] objectAtIndex:indexPath.row]]];
    resName.text = [[app.arrPayDictinaryData objectAtIndex:indexPath.section] objectForKey:@"name"];
    return  cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestaurantPayHistoryViewController *restaurantInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantPayHistoryViewController"];
    [self.navigationController pushViewController:restaurantInfoViewController animated:YES];
}

- (CGFloat)collectionView: (UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
 
- (void) viewWillAppear:(BOOL)animated{

    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}
- (IBAction)goSlide:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}
@end
