//
//  SearchViewController.m
//  disCout
//
//  Created by Theodor Hedin on 8/6/16.
//  Copyright © 2016 THedin. All rights reserved.
//
//#import "restaurantData.h"
#import "SearchViewController.h"
#import "YPAPISample.h"
#import "restaurantListViewcontroller.h"
#import "LocationMapOfRestaurants.h"
@import Firebase;
#import "MBProgressHUD.h"
#import "Request.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
@implementation SearchViewController
{
    AppDelegate *app;
    bool checkSelectAll;
    NSMutableArray *arrSelectedCuisine;
    NSArray *arrCuisine;
    __weak IBOutlet UIButton *btnSearchLocation;
    __weak IBOutlet UITextField *txtFieldSearchKey;
    __weak IBOutlet UIButton *btnCheckByName;
    __weak IBOutlet UIButton *btnCheckAll;
    
    __weak IBOutlet UIButton *btnCheckZipCode;

    __weak IBOutlet UIButton *btnCheckLocation;
    
    __weak IBOutlet UIView *viewSelectCuisine;
    __weak IBOutlet UICollectionView *tableCuisine;
    __weak IBOutlet UIImageView *imgCheckSelectAll;
    int count;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //start offset number init
    app.offsetNumber = 1;
    app = [UIApplication sharedApplication].delegate;
    arrCuisine = [[NSMutableArray alloc]init];
    arrCuisine = app.arrCuisine;
    
    arrSelectedCuisine = [[NSMutableArray alloc]init];
    arrSelectedCuisine = app.arrSelectedCuisine;
    [viewSelectCuisine setHidden:YES];
    checkSelectAll = true;
    
    //if checkedSearchKeyType ==1 -> check the location button, 2 : by Name, 3:All
    app.intSearchOption1 = 1;
    //selected the checkSearchLocation button
    [btnSearchLocation setBackgroundImage:[UIImage imageNamed:@"btn_Search_InActive.png"] forState:UIControlStateNormal];
    [btnSearchLocation setTintColor:[UIColor colorWithWhite:1 alpha:0]];
    [btnSearchLocation setBackgroundImage:[UIImage imageNamed:@"btn_Search_Active.png"] forState:UIControlStateSelected];
    [btnSearchLocation setSelected:YES];
    
    //selected the checkByName button
    [btnCheckByName setBackgroundImage:[UIImage imageNamed:@"btn_Search_InActive.png"] forState:UIControlStateNormal];
    [btnCheckByName setTintColor:[UIColor colorWithWhite:1 alpha:0]];
    [btnCheckByName setBackgroundImage:[UIImage imageNamed:@"btn_Search_Active.png"] forState:UIControlStateSelected];
    [btnCheckByName setSelected:NO];
    
    //selected the checkByName button
    [btnCheckAll setBackgroundImage:[UIImage imageNamed:@"btn_Search_All_InActive.png"] forState:UIControlStateNormal];
    [btnCheckAll setTintColor:[UIColor colorWithWhite:1 alpha:0]];
    [btnCheckAll setBackgroundImage:[UIImage imageNamed:@"btn_Search_All_Active.png"] forState:UIControlStateSelected];
    [btnCheckByName setSelected:NO];
    
    
    //if checkedSearchKeyType ==1 -> check the location button, 2 : by Name, 3:All
    app.intSearchOption2 = 1;
    //selected the checkSearchLocation button
    [btnCheckZipCode setBackgroundImage:[UIImage imageNamed:@"btn_Search_InActive.png"] forState:UIControlStateNormal];
    [btnCheckZipCode setTintColor:[UIColor colorWithWhite:1 alpha:0]];
    [btnCheckZipCode setBackgroundImage:[UIImage imageNamed:@"btn_Search_Active.png"] forState:UIControlStateSelected];
    [btnCheckZipCode setSelected:YES];
    
    
    //selected the checkByName button
    [btnCheckLocation setBackgroundImage:[UIImage imageNamed:@"btn_Search_InActive.png"] forState:UIControlStateNormal];
    [btnCheckLocation setTintColor:[UIColor colorWithWhite:1 alpha:0]];
    [btnCheckLocation setBackgroundImage:[UIImage imageNamed:@"btn_Search_Active.png"] forState:UIControlStateSelected];
    [btnCheckLocation setSelected:NO];
    
    [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Search_Active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setImage:[[UIImage imageNamed:@"Search_InActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    }

-(void)viewWillAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}

- (IBAction)setOptionSearchLocation:(UIButton *)sender {
    [btnCheckAll setSelected:NO];
    [btnCheckByName setSelected:NO];
    [sender setSelected:YES];
    app.intSearchOption1 = 1;
}
- (IBAction)setOptionSearchAll:(UIButton *)sender {
    [btnSearchLocation setSelected:NO];
    [btnCheckByName setSelected:NO];
    
    [sender setSelected:YES];
    app.intSearchOption1 = 3;
}
- (IBAction)setOptionSearchByName:(UIButton *)sender {
    [btnCheckAll setSelected:NO];
    [btnSearchLocation setSelected:NO];
    [sender setSelected:YES];
    app.intSearchOption1 = 2;
}

- (IBAction)setOptionZipCode:(UIButton *)sender {
    [btnCheckLocation setSelected:NO];
    [sender setSelected:YES];
    app.intSearchOption2 = 1;
}

- (IBAction)setOptionLocation:(UIButton *)sender {
    [btnCheckZipCode setSelected:NO];
    [sender setSelected:YES];
    app.intSearchOption2 = 3;
    
}



- (IBAction)search:(id)sender {
    app.arrSearchedDictinaryRestaurantData = [[NSMutableArray alloc]init];
    app.offsetNumber = 1;
    count = 1;
    app.IsMatch = true;
    
    //app.arrRestaurantData = [[NSMutableArray alloc]init];
    //app.dicSearchedDictionaryRestaurantData = [[NSDictionary alloc]init];
    
    app.offsetNumber = 1;
    if (app.intSearchOption1 == 1) {
        app.term = [NSString stringWithFormat:@"%@", txtFieldSearchKey.text] ;
        app.location = @"Houston, TX";        
    }else if (app.intSearchOption1==2){
        app.term = @"restaurant";
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([txtFieldSearchKey.text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            app.location = [NSString stringWithFormat:@"%@, TX %@",@"Houston", txtFieldSearchKey.text] ;
        }else{
            app.location = [NSString stringWithFormat:@"%@, %@",@"Houston", txtFieldSearchKey.text] ;
        }
    }
    else{
        app.term = @"restaurant";
        app.location = @"Houston, TX";
    }
    
    
    
    NSString *startoffset;
    //int num = 1;
    
    
    YPAPISample *APISample = [[YPAPISample alloc] init];
    //all restaurant data will be stored in nsdictionary with array components.
    app.arrSearchedDictinaryRestaurantData = [[NSMutableArray alloc]init];
    //app.arrSearchedRestaurants = [[NSArray alloc]init];
     startoffset = [NSString stringWithFormat:@"%d", ((app.offsetNumber-1) * 20) +1];
    [self.view setUserInteractionEnabled:NO];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
    [APISample queryTopBusinessInfoForTerm:app.term location:app.location offset:startoffset completionHandler:^(NSDictionary *searchResponseJSON, NSError *error) {
        
        //            [commonUtils showActivityIndicatorColored:self.view];
        //muarRestaurantImage = [[NSMutableArray alloc]init];
        if (error) {
            NSLog(@"An error happened during the request: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];/////
            [self.view setUserInteractionEnabled:YES];
        } else if (searchResponseJSON) {
            //[[[FIRDatabase database] reference] setValue:searchResponseJSON forKey:@"num"];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:searchResponseJSON options:NSJSONWritingPrettyPrinted error:nil];
                NSString * json = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
            [[[[[[[FIRDatabase database] reference] child:@"users"] child:[Request currentUserUid]]child:@"general info" ] child:@"name"] setValue:json];
            NSMutableArray* businessArray = searchResponseJSON[@"businesses"];
            //[app.arrSearchedRestaurants arrayByAddingObjectsFromArray:businessArray];
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
                    if (count1==0) {
                        resAddress = [NSString stringWithFormat:@"%@", [addressArray objectAtIndex:count1]];
                    }else if(![[addressArray objectAtIndex:count1] isEqualToString:@"Houston"]){
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
                        }else{
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
                
                NSDictionary *dicRestaurantData = [NSDictionary dictionaryWithObjectsAndKeys:resName, @"name", resCategories, @"categories", resDisplayPhoneNumber, @"display_phone", resAddress, @"address", resRating, @"rating", resReviewCount, @"review_count", postalcode, @"postal_code", lati,@"latitude",longgi, @"longitude", resRatingImageURL, @"rating_img_url", ResSnippetText, @"snippet_text", resImageURL, @"image_url", resMobileURL, @"mobile_url", nil];
                [app.arrSearchedDictinaryRestaurantData addObject:dicRestaurantData];
                
                
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                if (count == businessArray.count) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];/////
                    [self.view setUserInteractionEnabled:YES];
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    LocationMapOfRestaurants *LocationMapViewController = [storyboard instantiateViewControllerWithIdentifier:@"LocationMapOfRestaurants"];
                    [self.navigationController pushViewController:LocationMapViewController animated:YES];
                    
                }
                count++;
                    });
               
            }            
        }else {
            
                NSLog(@"No business was found");
                [MBProgressHUD hideHUDForView:self.view animated:YES];/////
                [self.view setUserInteractionEnabled:YES];
            
        }
    }];
 });
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // do whatever you have to do
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)OpenFilterWithCuisine:(UIButton *)sender {
    [viewSelectCuisine setHidden:NO];
    [self.view bringSubviewToFront:viewSelectCuisine];
    //init all cuisine Image
    arrCuisine = [[NSMutableArray alloc]initWithArray: app.arrCuisine];
    arrSelectedCuisine = [[NSMutableArray alloc]initWithArray: app.arrSelectedCuisine];
    [tableCuisine reloadData];
}

//close Cuisine filter window
- (IBAction)selectFilterWindow:(UIButton *)sender {
    [viewSelectCuisine setHidden:YES];
    [self.view sendSubviewToBack:viewSelectCuisine];
    app.arrSelectedCuisine =[[NSMutableArray alloc]initWithArray: arrSelectedCuisine];

}
- (IBAction)closeFilterWindow:(id)sender {
    [viewSelectCuisine setHidden:YES];
    [self.view sendSubviewToBack:viewSelectCuisine];
}


//select all cuisine type
- (IBAction)CuisineSelectAll:(UIButton *)sender {
    
    //init
    //select all cuisine Image
    [imgCheckSelectAll setImage:[UIImage imageNamed:@"btn_Search_Active.png"]];
    arrSelectedCuisine = [[NSMutableArray alloc]init];
    for (int index = 0; index<arrCuisine.count; index++) {
        
        [arrSelectedCuisine setObject:@"1" atIndexedSubscript:index];
        
    }
    //if index is equal arrCuisine.count then checked the "all select"
    [arrSelectedCuisine setObject:@"1" atIndexedSubscript:arrSelectedCuisine.count];
    [tableCuisine reloadData];
}
- (IBAction)clearAllCuisine:(UIButton *)sender {
    //init
    //Clear all cuisine Image
    [imgCheckSelectAll setImage:[UIImage imageNamed:@"unCheckCuisine.png"]];
    arrSelectedCuisine = [[NSMutableArray alloc]init];
    for (int index = 0; index<arrCuisine.count; index++) {
        
        [arrSelectedCuisine setObject:@"0" atIndexedSubscript:index];
        
    }
    //if index is equal arrCuisine.count then checked the "all select"
    [arrSelectedCuisine setObject:@"0" atIndexedSubscript:arrSelectedCuisine.count];
    [tableCuisine reloadData];

}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *identifier = @"CuisineCell1";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        UILabel *CusisineType = (UILabel *)[cell viewWithTag:102];
        CusisineType.text = [arrCuisine objectAtIndex:indexPath.row];
        UIImageView *checkImage = (UIImageView*)[cell viewWithTag:101];
    if ([(NSString*)[arrSelectedCuisine objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        [checkImage setImage:[UIImage imageNamed:@"unCheckCuisine.png"]];
    }
    else{
        [checkImage setImage:[UIImage imageNamed:@"btn_Search_Active.png"]];
    }
    
    //if all cuisine is unchecked then all imagecheck button make check status.
    
    [imgCheckSelectAll setImage:[UIImage imageNamed:@"btn_Search_Active.png"]];
    for (int index = 0; index<arrCuisine.count; index++) {
        
        
        if ([(NSString*)[arrSelectedCuisine objectAtIndex:index] isEqualToString:@"0"]) {
            [imgCheckSelectAll setImage:[UIImage imageNamed:@"unCheckCuisine.png"]];
        }
    }

    return cell;
    //UIImageView *resImage =
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *identifier = @"CuisineCell1";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *checkImage = (UIImageView*)[cell viewWithTag:101];
    if ([(NSString*)[arrSelectedCuisine objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        [imgCheckSelectAll setImage:[UIImage imageNamed:@"unCheckCuisine.png"]];
        [arrSelectedCuisine setObject:@"1" atIndexedSubscript:indexPath.row];
        [checkImage setImage:[UIImage imageNamed:@"unCheckCuisine.png"]];
        
    }
    else{
        
        [arrSelectedCuisine setObject:@"0" atIndexedSubscript:indexPath.row];
        [checkImage setImage:[UIImage imageNamed:@"btn_Search_Active.png"]];
    }
    [tableCuisine reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return arrCuisine.count;
}

- (IBAction)goSlide:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}

@end


