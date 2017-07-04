
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
    NSMutableArray *arrSelectedCuisine;
    NSArray *arrCuisine;
    __weak IBOutlet UIButton *btnSearchLocation;
    __weak IBOutlet UITextField *txtFieldSearchKey;
    __weak IBOutlet UIButton *btnCheckByName;
    __weak IBOutlet UIButton *btnCheckAll;
    
    __weak IBOutlet UIButton *btnCheckAlphabetical;

    __weak IBOutlet UIButton *btnCheckrate;
    IBOutlet UIButton *btnCheckMatch;
    
    __weak IBOutlet UIView *viewSelectCuisine;
    __weak IBOutlet UICollectionView *tableCuisine;
    __weak IBOutlet UIImageView *imgCheckSelectAll;
    IBOutlet UILabel *lblMSelectedCuisineType;
    
    __weak IBOutlet UIButton *btnDismissKeyboard;
    int count;
}

#pragma mark - set environment
- (void)viewDidLoad {
    [super viewDidLoad];
    //start offset number init
    app = [UIApplication sharedApplication].delegate;
    app.offsetNumber = 0;
    arrCuisine = [[NSMutableArray alloc]init];
    arrCuisine = app.arrCuisine;
    lblMSelectedCuisineType.text = @"All";
    
    arrSelectedCuisine = [[NSMutableArray alloc]init];
    arrSelectedCuisine = app.arrSelectedCuisine;
    [viewSelectCuisine setHidden:YES];
    app.isSelectedAllCuisine = true;
    
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
    
    //selected the checkAll button
    [btnCheckAll setBackgroundImage:[UIImage imageNamed:@"btn_Search_All_InActive.png"] forState:UIControlStateNormal];
    [btnCheckAll setTintColor:[UIColor colorWithWhite:1 alpha:0]];
    [btnCheckAll setBackgroundImage:[UIImage imageNamed:@"btn_Search_All_Active.png"] forState:UIControlStateSelected];
    [btnCheckByName setSelected:NO];
    
    
    //if checkedSearchKeyType ==1 -> check the location button, 2 : by Name, 3:All
    app.intSearchOption2 = 3;
    //selected the btnCheckAlphabetical button
    [btnCheckAlphabetical setBackgroundImage:[UIImage imageNamed:@"btn_Search_InActive.png"] forState:UIControlStateNormal];
    [btnCheckAlphabetical setTintColor:[UIColor colorWithWhite:1 alpha:0]];
    [btnCheckAlphabetical setBackgroundImage:[UIImage imageNamed:@"btn_Search_Active.png"] forState:UIControlStateSelected];
    [btnCheckAlphabetical setSelected:NO];
    
    
    //selected the btnCheckrate button
    [btnCheckrate setBackgroundImage:[UIImage imageNamed:@"btn_Search_InActive.png"] forState:UIControlStateNormal];
    [btnCheckrate setTintColor:[UIColor colorWithWhite:1 alpha:0]];
    [btnCheckrate setBackgroundImage:[UIImage imageNamed:@"btn_Search_Active.png"] forState:UIControlStateSelected];
    [btnCheckrate setSelected:NO];
    
    //selected the btnCheckrate button
    [btnCheckMatch setBackgroundImage:[UIImage imageNamed:@"btn_Search_InActive.png"] forState:UIControlStateNormal];
    [btnCheckMatch setTintColor:[UIColor colorWithWhite:1 alpha:0]];
    [btnCheckMatch setBackgroundImage:[UIImage imageNamed:@"btn_Search_Active.png"] forState:UIControlStateSelected];
    [btnCheckMatch setSelected:YES];
    
    
    [self.tabBarItem setSelectedImage:[[UIImage imageNamed:@"Search_Active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBarItem setImage:[[UIImage imageNamed:@"Search_InActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [btnDismissKeyboard setHidden:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}
-(void)viewWillDisappear:(BOOL)animated{
    app.isSelectedAllCuisine = true;
    for (int index = 0; index<arrCuisine.count; index++) {
        
        
        if ([(NSString*)[arrSelectedCuisine objectAtIndex:index] isEqualToString:@"0"]) {
            app.isSelectedAllCuisine = false;
            
        }
    }
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

- (IBAction)setOptionAlphabetical:(UIButton *)sender {
    [btnCheckrate setSelected:NO];
    [btnCheckMatch setSelected:NO];
    [sender setSelected:YES];
    app.intSearchOption2 = 1;
}

- (IBAction)setOptionRate:(UIButton *)sender {
    [btnCheckAlphabetical setSelected:NO];
    [btnCheckMatch setSelected:NO];
    [sender setSelected:YES];
    app.intSearchOption2 = 2;
    
}
- (IBAction)setOptionMatch:(UIButton *)sender {
    [btnCheckAlphabetical setSelected:NO];
    [btnCheckrate setSelected:NO];
    [sender setSelected:YES];
    app.intSearchOption2 = 3;
}

- (IBAction)hideKyeboard:(UIButton *)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
    [btnDismissKeyboard setHidden:NO];
}
- (void)keyboardBeHidden:(NSNotification *)aNotification {
    [btnDismissKeyboard setHidden:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self search:nil];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - search
- (IBAction)search:(id)sender {
    app.arrSearchedDictinaryRestaurantData = [[NSMutableArray alloc]init];
    if ([txtFieldSearchKey.text isEqualToString:@""] && app.intSearchOption1 != 3) {
        return;
    }
//set search option
    app.offsetNumber = 1;
    count = 1;
    app.IsMatch = true;
    
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
    YPAPISample *APISample = [[YPAPISample alloc] init];
//all restaurant data will be stored in nsdictionary with array components.
    app.arrSearchedDictinaryRestaurantData = [[NSMutableArray alloc]init];
     startoffset = [NSString stringWithFormat:@"%d", ((app.offsetNumber-1) * 20) +1];
    [self.view setUserInteractionEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
    [APISample queryTopBusinessInfoForTerm:app.term location:app.location offset:startoffset completionHandler:^(NSDictionary *searchResponseJSON, NSError *error) {
        
        if (error) {
            NSLog(@"An error happened during the request: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController * loginErrorAlert = [UIAlertController
                                                       alertControllerWithTitle:@"No Result"
                                                       message:error.localizedDescription
                                                       preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:loginErrorAlert animated:YES completion:nil];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                    return;
                }];
                [loginErrorAlert addAction:ok];
                
            [MBProgressHUD hideHUDForView:self.view animated:YES];/////
            [self.view setUserInteractionEnabled:YES];
            });
        } else if (searchResponseJSON) {
            
            NSMutableArray* businessArray = searchResponseJSON[@"businesses"];
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
                
            //filter with cuisine type
                if ([imgCheckSelectAll.image isEqual:[UIImage imageNamed:@"btn_Search_Active.png"]]) {
                    [app.arrSearchedDictinaryRestaurantData addObject:dicRestaurantData];
                }else{
                    
                    for (int count1 = 0;app.arrCuisine.count>count1;count1++) {
                        
                        if ([[app.arrSelectedCuisine objectAtIndex:count1] isEqualToString:@"1"] && [resCategories containsString:[app.arrCuisine objectAtIndex:count1]]) {
                            
                            [app.arrSearchedDictinaryRestaurantData addObject:dicRestaurantData];
                            break;
                            
                        }

                    }
                }
                
                

                dispatch_async(dispatch_get_main_queue(), ^{

                    
                    if (count == businessArray.count) {
                        NSSortDescriptor * descriptor;
                        if (app.intSearchOption2==1) {
                            
                            descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                            app.arrSearchedDictinaryRestaurantData = [[NSMutableArray alloc]initWithArray:[app.arrSearchedDictinaryRestaurantData sortedArrayUsingDescriptors:@[descriptor]]];
                        }else if(app.intSearchOption2==2){
                            
                            descriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:NO];
                            app.arrSearchedDictinaryRestaurantData = [[NSMutableArray alloc]initWithArray:[app.arrSearchedDictinaryRestaurantData sortedArrayUsingDescriptors:@[descriptor]]];
                        }
                    
                        
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController * loginErrorAlert = [UIAlertController
                                                       alertControllerWithTitle:@"No Result"
                                                       message:@"there is no search result"
                                                       preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:loginErrorAlert animated:YES completion:nil];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                    return;
                }];
                [loginErrorAlert addAction:ok];
                [MBProgressHUD hideHUDForView:self.view animated:YES];/////
                [self.view setUserInteractionEnabled:YES];
            });
        }
    }];
        
    });
    
}

#pragma mark - select cuisine

- (IBAction)OpenFilterWithCuisine:(UIButton *)sender {
    [viewSelectCuisine setHidden:NO];
    [self.view bringSubviewToFront:viewSelectCuisine];
    //init all cuisine Image
    arrCuisine = [[NSMutableArray alloc]initWithArray: app.arrCuisine];
    arrSelectedCuisine = [[NSMutableArray alloc]initWithArray: app.arrSelectedCuisine];
    [tableCuisine reloadData];
}

- (IBAction)selectFilterWindow:(UIButton *)sender {
    //add
    [viewSelectCuisine setHidden:YES];
    [self.view sendSubviewToBack:viewSelectCuisine];
    app.arrSelectedCuisine =[[NSMutableArray alloc]initWithArray: arrSelectedCuisine];
    if ([imgCheckSelectAll.image isEqual:[UIImage imageNamed:@"btn_Search_Active.png"]]) {
        lblMSelectedCuisineType.text = @"All";
    }else{
        int numberOfSelectedSuisine = 0;
        for (int count1 = 0;app.arrCuisine.count>count1;count1++) {
            if ([[app.arrSelectedCuisine objectAtIndex:count1] isEqualToString:@"1"]) {
                lblMSelectedCuisineType.text = [NSString stringWithFormat:@"%@...", [app.arrCuisine objectAtIndex:count1]];
                numberOfSelectedSuisine++;
                break;
            }
            
        }
        if (numberOfSelectedSuisine==0) {
            lblMSelectedCuisineType.text = @"empty";
            UIAlertController * loginErrorAlert = [UIAlertController
                                                   alertControllerWithTitle:@"No Cuisine"
                                                   message:@"You have selected no cuisine type to filter."
                                                   preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:loginErrorAlert animated:YES completion:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                
            }];
            [loginErrorAlert addAction:ok];
        }
    }
}
- (IBAction)closeFilterWindow:(id)sender {
    [viewSelectCuisine setHidden:YES];
    [self.view sendSubviewToBack:viewSelectCuisine];
}

- (IBAction)CuisineSelectAll:(UIButton *)sender {
    
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

    app.isSelectedAllCuisine = false;
    [imgCheckSelectAll setImage:[UIImage imageNamed:@"unCheckCuisine.png"]];
    arrSelectedCuisine = [[NSMutableArray alloc]init];
    for (int index = 0; index<arrCuisine.count; index++) {
        
        [arrSelectedCuisine setObject:@"0" atIndexedSubscript:index];
        
    }
    //if index is equal arrCuisine.count then checked the "all select"
    [arrSelectedCuisine setObject:@"0" atIndexedSubscript:arrSelectedCuisine.count];
    [tableCuisine reloadData];

}

#pragma mark - filter cuisine collectionView delegate
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
        
        if (index == arrCuisine.count-1) {
            NSString *assr1 = [arrCuisine objectAtIndex:index-1];
            NSString *assr = [arrCuisine objectAtIndex:index];
        }
        
        if ([(NSString*)[arrSelectedCuisine objectAtIndex:index] isEqualToString:@"0"]) {
            [imgCheckSelectAll setImage:[UIImage imageNamed:@"unCheckCuisine.png"]];
            
        }
    }
    
    return cell;
    
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

#pragma mark - go slide
- (IBAction)goSlide:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}
@end


