
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
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
@interface RestaurantInfoViewController ()<QRCodeReaderDelegate>
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
    NSString *ResID;
    NSString *numberOfCoupons;
    NSURL *ResMobileURL;
    NSDictionary *dicRestaurantData;
    NSDictionary *tempDic;
    AppDelegate *app;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imgMRestaurnat;
@property (strong, nonatomic) IBOutlet UIImageView *registerMarkImage;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (nonatomic, strong) webViewController* webViewVC;
@property (strong, nonatomic) IBOutlet UIImageView *imgRating;
@property (strong, nonatomic) IBOutlet UILabel *lblResName;
@property (strong, nonatomic) IBOutlet UILabel *lblResAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblResCategories;
@property (strong, nonatomic) IBOutlet UILabel *lblResReviewNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblResID;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfCoupons;

@end

@implementation RestaurantInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    app = [UIApplication sharedApplication].delegate;
    self.webViewVC = [[webViewController alloc] initWithNibName:@"webViewController" bundle:nil];
    dicRestaurantData = app.dicRestaurantData ;
    
    ResID = [dicRestaurantData objectForKey:@"resid"];
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
    numberOfCoupons = [dicRestaurantData objectForKey: @"numberOfCoupons"];
    if ([[dicRestaurantData objectForKey:@"mobile_url"] isEqualToString:@""]) {
        
    }else{
        ResMobileURL = [[NSURL alloc]initWithString:(NSString*)[dicRestaurantData objectForKey:@"mobile_url"]];
    }
    
    [self.imgMRestaurnat sd_setImageWithURL:[NSURL URLWithString:ResSnnipetImageURL]
                          placeholderImage:[UIImage imageNamed:@"Splash.png"]];
    [self.imgRating sd_setImageWithURL:[NSURL URLWithString:ResRatingImageURL]
                          placeholderImage:[UIImage imageNamed:@"Splash.png"]];
    
    //check if the restaurant is registered in user database.
    [self.registerMarkImage setImage:[UIImage imageNamed:@"unregisterMark.png"]];
    [self.registerButton setTitle:@"REGISTER" forState:UIControlStateNormal];
    self.lblResName.text = ResName;
    self.lblResAddress.text = ResAddress;
    self.lblResCategories.text = ResCategories;
    self.lblResID.text = ResID;
    self.lblPhoneNumber.text = [dicRestaurantData objectForKey:@"display_phone"];
    if ([numberOfCoupons intValue]==0) {
        [self.lblNumberOfCoupons setText:[NSString stringWithFormat:@"no coupon is accepted"]];
    }else{
        [self.lblNumberOfCoupons setText:[NSString stringWithFormat:@"%@ coupons were accepted", numberOfCoupons]];
    }
    if ([ResReviewCount intValue] == 0) {
        self.lblResReviewNumber.text =[NSString stringWithFormat:@"no review"] ;
    }else{
        self.lblResReviewNumber.text =[NSString stringWithFormat:@"%@ reviews", ResReviewCount];
    }
    
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
    
    
        if ([sender.titleLabel.text isEqualToString:@"REGISTER"]) {
            
            
            UINavigationController *resinfoNavigationC = [[UINavigationController alloc]init];
            resinfoNavigationC = self.navigationController;
            
            
            
            
            UIAlertController * registerRestaurant = [UIAlertController
                                                   alertControllerWithTitle:@"REGISTER THE RESTAURANT"
                                                   message:@"Are sure register the restaurant?"
                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction *typeRestaurantID = [UIAlertAction actionWithTitle:@"Type Restaurant ID" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"RESTAURANT ID"
                                                                                          message: @"Input the RESTAURANT ID"
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = @"Restaurant ID";
                    textField.textColor = [UIColor blackColor];
                    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    textField.borderStyle = UITextBorderStyleRoundedRect;

                }];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSArray * textfields = alertController.textFields;
                    UITextField * resIDTextField = textfields[0];
                    ResID = resIDTextField.text;
                    [self acceptCoupon:ResID];
                    
                    [registerRestaurant dismissViewControllerAnimated:YES completion:nil];
                    [resinfoNavigationC popViewControllerAnimated:YES];
                    
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [registerRestaurant dismissViewControllerAnimated:YES completion:nil];
                    
                }]];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                
            }];
            
            UIAlertAction *captureQRcode = [UIAlertAction actionWithTitle:@"CaptureQRcode" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self scanAction];
                [registerRestaurant dismissViewControllerAnimated:YES completion:nil];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [registerRestaurant dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [registerRestaurant addAction:typeRestaurantID];
            [registerRestaurant addAction:captureQRcode];
            [registerRestaurant addAction:cancel];
            [self presentViewController:registerRestaurant animated:YES completion:nil];
            
            
           }else{
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
    

}


#pragma mark - Scan QR code
- (void)scanAction
{
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self.navigationController pushViewController:vc animated:NO];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [reader stopScanning];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self acceptCoupon:result];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)acceptCoupon: (NSString*)resID{
    
    
    
    UIAlertController * loginErrorAlert = [UIAlertController
                                           alertControllerWithTitle:@"Restourant ID"
                                           message:[NSString stringWithFormat:@"Are sure use the ID.\n%@", resID ]
                                           preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:loginErrorAlert animated:YES completion:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"resid ==[c] %@", resID];
        NSArray* arrSearchedRes = [[NSArray alloc]initWithArray:[app.arrRegisteredDictinaryRestaurantData filteredArrayUsingPredicate:predicate]];
        if (arrSearchedRes.count > 0) {
            
            UIAlertController * loginErrorAlert = [UIAlertController
                                                   alertControllerWithTitle:@"Invalid ID"
                                                   message:@"This ID has been used aleady. Please enter the another ID"
                                                   preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:loginErrorAlert animated:YES completion:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                [self viewDidLoad];
                
            }];
            [loginErrorAlert addAction:ok];
            
        }else{
            
            numberOfCoupons = [NSString stringWithFormat:@"0"];
            NSMutableDictionary *tempMuarDic = [[NSMutableDictionary alloc]initWithDictionary:dicRestaurantData];
            [tempMuarDic setValue:resID forKey:@"resid"];
            [tempMuarDic setValue:@"0" forKey:@"numberOfCoupons"];
            NSString *tempString = [tempMuarDic objectForKey:@"categories"];
            NSArray *strArray = [tempString componentsSeparatedByString:@","];
            [Request addCuisineType:strArray];
            //register the restaurant
            FIRDatabaseReference* savedResData = [[[[FIRDatabase database] reference]child:@"restaurants"] child:ResName];

            
            [savedResData setValue:tempMuarDic withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                if (!error) {
                    [app.arrRegisteredDictinaryRestaurantData addObject:tempMuarDic];
                }else{
                    UIAlertController * loginErrorAlert = [UIAlertController
                                                           alertControllerWithTitle:@"Regisration Failed"
                                                           message:error.localizedDescription
                                                           preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:loginErrorAlert animated:YES completion:nil];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                        
                    }];
                    [loginErrorAlert addAction:ok];
                    
                }
                
            }];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];

    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    [loginErrorAlert addAction:ok];
    [loginErrorAlert addAction:cancel];
    
}
-(void)registerRestaurant{
    
}
- (IBAction)goSideMenu:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}
- (IBAction)goTosite:(UIButton *)sender {
    if (ResMobileURL) {
        self.webViewVC = [[webViewController alloc]initWithNibName:@"webViewController" bundle:nil];
        self.webViewVC.url = ResMobileURL;
        [self.navigationController pushViewController:self.webViewVC animated:YES];
    }
    
}
@end
