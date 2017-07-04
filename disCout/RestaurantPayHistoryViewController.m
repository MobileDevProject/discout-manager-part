
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
    NSMutableDictionary *mudicPayData;
    
}
@property (strong, nonatomic) IBOutlet UICollectionView *payHistoryTableView;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UILabel *JobID;
@property (strong, nonatomic) IBOutlet UILabel *Membership;
@property (strong, nonatomic) IBOutlet UILabel *UserName;

@end

@implementation RestaurantPayHistoryViewController
#pragma mark - set environment
- (void) viewDidLoad{
    app = [UIApplication sharedApplication].delegate;
    childCount = 1;
    self.UserName.text = app.user.name;
    [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"MyCard_Active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setImage:[[UIImage imageNamed:@"MyCard_InActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setTitle:@"SAVED"];
    
    
    
}
- (void) viewWillAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    [self.imgPhoto sd_setImageWithURL:app.user.photoURL placeholderImage:[UIImage imageNamed:@"person0.jpg"]];
}

#pragma mark - restaurant collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return app.arrPayDictinaryData.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[app.arrPayDictinaryData objectAtIndex:section] objectForKey:@"pay info"] count] ;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width, 50);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *identifier = @"payCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UILabel *date = (UILabel *)[cell viewWithTag:101];
    UILabel *Amount = (UILabel *)[cell viewWithTag:102];
    NSDictionary *payDic = [app.arrPayDictinaryData objectAtIndex:indexPath.section];
    NSArray *payData = [payDic objectForKey:@"pay info"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString* amount =(NSString*)[[payData objectAtIndex:indexPath.row]objectForKey:@"resName"];
    Amount.text =  [NSString stringWithFormat:@"%@",amount];
    NSDate *datePay = (NSDate*)[[payData objectAtIndex:indexPath.row] objectForKey:@"date"];
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
    
    return reusableview;
}
#pragma mark - go side
- (IBAction)goSideMenu:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}

-(NSDate*)date_from_string: (NSString*)string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM_dd_yyyy_HH_mm_ss"];
    NSDate *dateReturn = (__bridge NSDate *)([dateFormatter dateFromString:string]?[string isEqualToString:@"defaultTime"]:nil);
    return dateReturn;
}
-(NSString*)string_from_date: (NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
    [dateFormatter setDateFormat:@"MM_dd_yyyy_HH_mm_ss"];
    NSString *strReturn = [dateFormatter stringFromDate:date];
    return strReturn;
}

@end
