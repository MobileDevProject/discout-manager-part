//
//  restaurantListViewcontroller.m
//  disCout
//
//  Created by Theodor Hedin on 7/24/16.
//  Copyright © 2016 THedin. All rights reserved.
//
#import "Request.h"
#import "AppDelegate.h"
#import "YPAPISample.h"
#import "RestaurantInfoViewController.h"
#import "restaurantListViewcontroller.h"
#import "LocationMapOfRestaurants.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@import Firebase;
@interface restaurantListViewcontroller ()
{
    int count;
    AppDelegate *app;
    NSArray *ArrResThumbnailsName;
    NSArray *ArrResNames;
    NSMutableArray* registeredRestaurants;
    NSMutableArray *muarResName;
    
    
    //NSArray *businessArray;
    bool checkScroll;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *tableResList;

@end

@implementation restaurantListViewcontroller


- (void)viewDidLoad {
    
    [super viewDidLoad];
    app = [UIApplication sharedApplication].delegate;
    checkScroll = false;
    [self.tableResList setCanCancelContentTouches:NO];
    muarResName = [[NSMutableArray alloc]init];
}
- (void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //[Request retrieveAllRestaurantsID];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            for (int count1 = 0; app.arrRegisteredDictinaryRestaurantData.count>count1; count1++) {
                [tempArray addObject:[[app.arrRegisteredDictinaryRestaurantData objectAtIndex:count1] objectForKey:@"name"]];
            }
            registeredRestaurants = [[NSMutableArray alloc]initWithArray:tempArray];
            
            for (int count1 = 0; app.arrSearchedDictinaryRestaurantData.count>count1; count1++) {
                [muarResName addObject:[[app.arrSearchedDictinaryRestaurantData objectAtIndex:count1] objectForKey:@"name"]];
            }
            [tempArray removeObjectsInArray:muarResName];
            [registeredRestaurants removeObjectsInArray:tempArray];
            [self.tableResList reloadData];
        });
    });
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ExchangeMap:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationMapOfRestaurants *restaurantInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"LocationMapOfRestaurants"];
    [self.navigationController pushViewController:restaurantInfoViewController animated:YES];
}
- (IBAction)GoBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return app.arrSearchedDictinaryRestaurantData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    //retrieve registered restaurants
    
    //registeredRestaurants = [[NSMutableArray alloc]initWithArray:app.registeredRestaurants];

    
    
    static NSString *identifier = @"resCell";
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *resAddress = (UILabel *)[cell viewWithTag:101];
    NSDictionary *dice = (NSDictionary*)[app.arrSearchedDictinaryRestaurantData objectAtIndex:indexPath.row];
    resAddress.text = (NSString*)[dice objectForKey:@"address"];
    
    UILabel *membershipLabel= (UILabel *)[cell viewWithTag:102];
    [membershipLabel setHidden:YES];

    UIImageView *resImageView = (UIImageView *)[cell viewWithTag:103];
    [resImageView sd_setImageWithURL:[NSURL URLWithString:[[app.arrSearchedDictinaryRestaurantData objectAtIndex:indexPath.row] objectForKey:@"image_url"]]
                    placeholderImage:[UIImage imageNamed:@"Splash.png"]];
    
    UILabel *resName = (UILabel *)[cell viewWithTag:104];
    resName.text = [[app.arrSearchedDictinaryRestaurantData objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    UIImageView *resRatingImageView = (UIImageView *)[cell viewWithTag:105];
    [resRatingImageView sd_setImageWithURL:[NSURL URLWithString:[[app.arrSearchedDictinaryRestaurantData objectAtIndex:indexPath.row] objectForKey:@"rating_img_url"]]
                    placeholderImage:[UIImage imageNamed:@"Splash.png"]];
    
    UILabel *reviewCount = (UILabel *)[cell viewWithTag:106];
    reviewCount.text = [NSString stringWithFormat:@"%@ reviews",[[app.arrSearchedDictinaryRestaurantData objectAtIndex:indexPath.row] objectForKey:@"review_count"]];
    
    UILabel *resCategories = (UILabel *)[cell viewWithTag:107];
    resCategories.text = [[app.arrSearchedDictinaryRestaurantData objectAtIndex:indexPath.row] objectForKey:@"categories"];
    
    UILabel *resPhoneNumber = (UILabel *)[cell viewWithTag:109];
    resPhoneNumber.text = [[app.arrSearchedDictinaryRestaurantData objectAtIndex:indexPath.row] objectForKey:@"display_phone"];
    
    UIImageView *regImageView = (UIImageView *)[cell viewWithTag:110];
    [regImageView setHidden:YES];
    for (int i = 0; registeredRestaurants.count>i; i++) {
        if ([[muarResName objectAtIndex:indexPath.row] isEqualToString:[registeredRestaurants objectAtIndex:i]]) {
            [regImageView setHidden:NO];
            
            continue;
        }
        
    }
    
    
    return cell;
    //UIImageView *resImage =
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    app = [UIApplication sharedApplication].delegate;
    app.selectedResNumberFromResList = (int)indexPath.row;
    app.dicRestaurantData = [[NSDictionary alloc]initWithDictionary:[app.arrSearchedDictinaryRestaurantData objectAtIndex:app.selectedResNumberFromResList] copyItems:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestaurantInfoViewController *restaurantInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantInfoViewController"];
    [self.navigationController pushViewController:restaurantInfoViewController animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width, 100);
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (!checkScroll) {
        

    int indexOfTable;
    if ([scrollView isKindOfClass:[UICollectionView class]])
    {
        
        UICollectionView *mainCollection = (UICollectionView *) scrollView;
        
        
        CGRect visibleRect = (CGRect){.origin = mainCollection.contentOffset, .size = mainCollection.bounds.size};
        CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMaxY(visibleRect)-50);
        NSIndexPath *visibleIndexPath = [mainCollection indexPathForItemAtPoint:visiblePoint];
        NSLog(@"visibleIndexPath %ld",(long)visibleIndexPath.row);
        indexOfTable = (int)visibleIndexPath.row;
    }


    if (indexOfTable + 3 > muarResName.count && app.IsMatch) {
        checkScroll = true;
        [self.view setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    
    app.offsetNumber = app.offsetNumber +1;
    count = 1;
    
    //app.businessArray = [[NSMutableArray alloc] init];
    //app.arrRestaurantData = [[NSMutableArray alloc]init];
    app.offsetNumber = app.offsetNumber +1;
    NSString *startoffset;
    YPAPISample *APISample = [[YPAPISample alloc] init];
    //app.arrSearchedRestaurants = [[NSArray alloc]init];
    startoffset = [NSString stringWithFormat:@"%d", ((app.offsetNumber-1) * 20) +1];
    [APISample queryTopBusinessInfoForTerm:app.term location:app.location offset:startoffset completionHandler:^(NSDictionary *searchResponseJSON, NSError *error) {
        if (error) {
            NSLog(@"An error happened during the request: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];/////
            [self.view setUserInteractionEnabled:YES];
            checkScroll = false;
        } else if (searchResponseJSON) {
            NSMutableArray* businessArray = searchResponseJSON[@"businesses"];
            //app.arrSearchedRestaurants = app.businessArray;
            for (NSDictionary *itemRestaurant in businessArray) {
                NSString *resName = (NSString*)[itemRestaurant objectForKey:@"name"]? [itemRestaurant objectForKey:@"name"] : @" ";
                NSString* ResSnippetText = (NSString*)[itemRestaurant objectForKey:@"snippet_text"]? [itemRestaurant objectForKey:@"snippet_text"] : @" ";
                if (!ResSnippetText) {
                    ResSnippetText = @"";
                }
                
                // get location start
                NSDictionary *dic1 = [itemRestaurant objectForKey:@"location"];
                
                NSArray *addressArray = (NSArray*)[dic1 objectForKey:@"display_address"];
                NSString *resAddress;
                for (int count1 = 0; addressArray.count > count1; count1++) {
                    if (count1==1) {
                        resAddress = [NSString stringWithFormat:@"%@", [addressArray objectAtIndex:count1]];
                    }else{
                        resAddress = [NSString stringWithFormat:@"%@, %@",resAddress, [addressArray objectAtIndex:count1]];
                    }
                    
                }
                if (resAddress==nil) {
                    resAddress = @" ";
                }
                //NSString* postalcode = (NSString*)[dic1 objectForKey:@"postal_code"];
                
                NSDictionary *dic2 = [dic1 objectForKey:@"coordinate"];
                NSString* lati = [dic2 objectForKey:@"latitude"] ? [dic2 objectForKey:@"latitude"] : @" ";
                NSString* longgi = [dic2 objectForKey:@"longitude"] ? [dic2 objectForKey:@"longitude"] : @" ";
                NSString* postalcode = (NSString*)[dic1 objectForKey:@"postal_code"] ? [dic1 objectForKey:@"postal_code"] : @" ";
                //get categories
                NSArray *resdicres = (NSArray*)[itemRestaurant objectForKey:@"categories"];
                NSString *resCategories;
                for (int count1 = 0; resdicres.count > count1; count1++) {
                    
                    if (count1==0) {
                        resCategories = [NSString stringWithFormat:@"%@", [[resdicres objectAtIndex:count1] firstObject]];
                    }else if(count1==2){
                        resCategories = [NSString stringWithFormat:@"%@, %@",resCategories, [[resdicres objectAtIndex:count1] firstObject]];
                    }
                }
                
                if (resCategories==nil) {
                    resCategories = @" ";
                }
                
                NSString *resRating = [itemRestaurant objectForKey:@"rating"] ? [itemRestaurant objectForKey:@"rating"] : @" ";
                NSString *resImageURL = [itemRestaurant objectForKey:@"image_url"] ? [itemRestaurant objectForKey:@"image_url"] : @" ";
                NSString *resRatingImageURL = [itemRestaurant objectForKey:@"rating_img_url"] ? [itemRestaurant objectForKey:@"rating_img_url"] : @" ";
                NSString *resDisplayPhoneNumber = [itemRestaurant objectForKey:@"display_phone"] ? [itemRestaurant objectForKey:@"display_phone"] : @" ";
                NSString *resReviewCount = [itemRestaurant objectForKey:@"review_count"] ? [itemRestaurant objectForKey:@"review_count"] : @" ";
                NSString *resMobileURL = [itemRestaurant objectForKey:@"mobile_url"] ? [itemRestaurant objectForKey:@"mobile_url"] : @" ";
                [muarResName addObject:resName];
                NSDictionary *dicRestaurantData = [NSDictionary dictionaryWithObjectsAndKeys:resName, @"name", resCategories, @"categories", resDisplayPhoneNumber, @"display_phone", resAddress, @"address", resRating, @"rating", resReviewCount, @"review_count", postalcode, @"postal_code", lati,@"latitude",longgi, @"longitude", resRatingImageURL, @"rating_img_url", ResSnippetText, @"snippet_text", resImageURL, @"image_url", resMobileURL, @"mobile_url", nil];
                [app.arrSearchedDictinaryRestaurantData addObject:dicRestaurantData];
                
                //snnipet and rating image download
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    /////
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        if (count == businessArray.count) {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];/////
                            [self.view setUserInteractionEnabled:YES];
                            checkScroll = false;
                            [self.tableResList reloadData];
                            
                        }
                        count++;
                    });
                    /////
                    
                });
                
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"No business was found");
            app.IsMatch = false;
            checkScroll = false;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view setUserInteractionEnabled:YES];
            });
        }
    }];
    }

    }

}

- (IBAction)goSideMenu:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}

@end
