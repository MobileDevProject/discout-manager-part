//
//  Login.m
//  disCout
//
//  Created by Theodor Hedin on 7/20/16.
//  Copyright © 2016 THedin. All rights reserved.
//
#import "Request.h"
#import "Login.h"
#import "SignUp.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
@import Firebase;
@import FirebaseDatabase;
@interface Login ()<UITextFieldDelegate>

{
    int childCount;
    AppDelegate* app;
    NSString* checkMail;
}

@property (weak, nonatomic) IBOutlet UITextField *txtFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnSignWithFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnHideKeyboard;
@end

@implementation Login
#pragma mark - set environment
-(void)viewDidLoad{
    app = [UIApplication sharedApplication].delegate;
    
    //change textfield placeholder text color
    NSDictionary * attributes = (NSMutableDictionary *)[ (NSAttributedString *)self.txtFieldEmail.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL];
    NSMutableDictionary * newAttributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
    [newAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.txtFieldEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.txtFieldEmail.attributedPlaceholder string] attributes:newAttributes];
    self.txtFieldPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[self.txtFieldPassword.attributedPlaceholder string] attributes:newAttributes];
    
    [self CheckMailAndGo];
    
    //to show / hidden "dismiss keyboard button"
    [self.btnHideKeyboard setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.view setUserInteractionEnabled:YES];
    
    if (app.user.email !=nil) {
        self.txtFieldEmail.text = app.user.email;
    }
}

//set text field placeholder
- (void) drawPlaceholderInRect:(CGRect)rect{
    [[UIColor whiteColor] setFill];
    
}

//keyboard show/hidden
- (IBAction)dismissKeyboard:(UIButton *)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
    [self.btnHideKeyboard setHidden:NO];
}

- (void)keyboardBeHidden:(NSNotification *)aNotification {
    
    [self.btnHideKeyboard setHidden:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //
    if (textField.tag == 101) {
        
        [(UITextField*)[self.view viewWithTag:102] becomeFirstResponder];
        return YES;
    }else if(textField.tag == 102){
        [textField resignFirstResponder];
        [self goFromLogin:nil];
        return YES;
        
    }
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - login
- (IBAction)goFromLogin:(id)sender {
    [self.view endEditing:YES];
    NSString *strUserEmail = _txtFieldEmail.text;
    NSString *strUserPass = _txtFieldPassword.text;
    
    //check mail and password
    if ([strUserEmail isEqual:@""] && [strUserPass isEqual:@""]) {
        UIAlertController * loginErrorAlert = [UIAlertController
                                               alertControllerWithTitle:@"Invalid name and password"
                                               message:@"Please enter the UserName and Password."
                                               preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:loginErrorAlert animated:YES completion:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [loginErrorAlert addAction:ok];
        
    } else if ([strUserEmail isEqual:@""]) {
        
        UIAlertController * loginErrorAlert = [UIAlertController
                                               alertControllerWithTitle:@"Invalid username or email"
                                               message:@"Please enter the UserName."
                                               preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:loginErrorAlert animated:YES completion:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [loginErrorAlert addAction:ok];
        
    } else if([strUserPass isEqual:@""]) {
        
        UIAlertController * loginErrorAlert = [UIAlertController
                                               alertControllerWithTitle:@"Invalid password"
                                               message:@"Please enter the Password."
                                               preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:loginErrorAlert animated:YES completion:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [loginErrorAlert addAction:ok];
    } else{

        [self.view setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

            
            [[FIRAuth auth] signInWithEmail:strUserEmail
                                   password:strUserPass
                                 completion:^(FIRUser *user, NSError *error) {
                                     
                                     
                                     // check login
                                     if (error != nil) {
                                         UIAlertController * loginErrorAlert = [UIAlertController
                                                                                alertControllerWithTitle:@"Login Failed"
                                                                                message:error.localizedDescription
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                         [self presentViewController:loginErrorAlert animated:YES completion:nil];
                                         UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                             [self.view setUserInteractionEnabled:YES];
                                             [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                                         [loginErrorAlert addAction:ok];
                                         NSError *error1;
                                         [[FIRAuth auth] signOut:&error1];
                                     }
                                     else
                                     {
                                         
                                         FIRAuthCredential *credential = [FIREmailPasswordAuthProvider credentialWithEmail:strUserEmail password:strUserPass];
                                         [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser * user, NSError * error) {
                                             
                                             
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 

                                                 if (error==nil) {
                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                     [self.view setUserInteractionEnabled:YES];
                                                     [self CheckMailAndGo];
                                                     
                                                 }
                                             });
                                             //after progress
                                         }];
                                         
                                         //NSLog(@"succeed login");
                                     }
                                     
                                 }];
        });
        
    }
    
    
}
#pragma mark - load and prepare data from backend
-(void)CheckMailAndGo{
    
    FIRUser *user = [Request currentUser];
    if (user !=nil) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.view setUserInteractionEnabled:NO];
        
        // get compared mail <checkMail>
        FIRDatabaseReference* refManger = [[[FIRDatabase database] reference] child:@"manager"];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [refManger observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary*dic = snapshot.value;
                NSArray *keys;
                if (![dic isKindOfClass:[NSNull class]]) {
                    keys = dic.allKeys;
                }
                //manager mail
                checkMail = [[dic objectForKey:[keys lastObject]] objectForKey:@"email"];
                
                dispatch_async(dispatch_get_main_queue(), ^{///////
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.view setUserInteractionEnabled:YES];
                    
                    
                    
                    ///////////////***********************************************************************************
                    //Manager Module
                    NSString *email = [Request currentUser].email;
                    app.isManager = NO;
                    if ([email isEqualToString:checkMail]) {
                        app.isManager = YES;
                        app.userAccount = [FIRAuth auth].currentUser;
                        [self loadResDataAndGo];
                        
                    }else{
                        NSError *error;
                        [[FIRAuth auth] signOut:&error];
                    }
                    
                });
            }];
        });//Add MBProgressBar (dispatch)
    }
}

- (void)loadUserDataAndGo{
    
    app.user.userId = [NSString stringWithFormat:@"%@", [Request currentUserUid]];
    app.arrPayDictinaryData = [[NSMutableArray alloc]init];
    
    childCount = 1;
    [self.view setUserInteractionEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadResData];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //get manager data
        app.user.userId = [NSString stringWithFormat:@"%@", [Request currentUserUid]];
        NSString *userID = app.user.userId;
        FIRDatabaseReference *refManagerInfor = [[[Request dataref] child:@"manager"]child: userID];
        [refManagerInfor observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (snapshot.exists) {
                app.user.name = [(NSDictionary*)(snapshot.value) objectForKey:@"name"];
                app.user.userId = userID;
                app.user.email = [(NSDictionary*)(snapshot.value) objectForKey:@"email"];
                app.user.photoURL = [NSURL URLWithString:[(NSDictionary*)(snapshot.value) objectForKey:@"photourl"]];
                app.user.cardCVID = [(NSDictionary*)(snapshot.value) objectForKey:@"cardcvid"];
                app.user.cardDate = [(NSDictionary*)(snapshot.value) objectForKey:@"carddate"];
                app.user.cardNumber = [(NSDictionary*)(snapshot.value) objectForKey:@"cardnumber"];
                
                FIRDatabaseReference* refPay = [[[FIRDatabase database] reference] child:@"users"];
                [refPay observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSDictionary*dic = snapshot.value;
                    NSArray *keys;
                    if (![dic isKindOfClass:[NSNull class]]) {
                        keys = dic.allKeys;
                    }
                    
                    
                    NSDictionary *payData = [[dic objectForKey:[Request currentUserUid]] objectForKey:@"pay info"];
                    NSString *userName = (NSString*)[[[dic objectForKey:[Request currentUserUid]] objectForKey:@"general info"] objectForKey:@"name"];
                    NSDictionary* PersonPayData = [[NSDictionary alloc]initWithObjectsAndKeys:userName, @"name", payData,@"pay info", nil];
                    [app.arrPayDictinaryData addObject:PersonPayData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self.view setUserInteractionEnabled:YES];
                        [app addTabBar];
                        
                    });
                }];
            }else{
                UIAlertController * loginErrorAlert = [UIAlertController
                                                       alertControllerWithTitle:@"Cannot find manager info"
                                                       message:@"you cannot access manager info. please check your manager membership."
                                                       preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:loginErrorAlert animated:YES completion:nil];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.view setUserInteractionEnabled:YES];
                    [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                }];
                [loginErrorAlert addAction:ok];
                
            }
        }];
    });
    
}

-(void)loadResData{
    app.arrRegisteredDictinaryRestaurantData = [[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //get all restaurant info
        FIRDatabaseReference* ref = [[[FIRDatabase database] reference] child:@"restaurants"];
        [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary*dic = snapshot.value;
            
            NSArray *keys;
            if (![dic isKindOfClass:[NSNull class]]) {
                keys = dic.allKeys;
            }
            for (int countData = 0;keys.count>countData;countData++) {
                NSDictionary *restaurantData = [dic objectForKey:[keys objectAtIndex:countData]];
                [app.arrRegisteredDictinaryRestaurantData addObject:restaurantData];
            }
        }];
        
    });
    
}

- (void)loadResDataAndGo{
    
    [self.view setUserInteractionEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //get all restaurant info
        FIRDatabaseReference* ref = [[[FIRDatabase database] reference] child:@"restaurants"];
        [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            app.arrRegisteredDictinaryRestaurantData = [[NSMutableArray alloc]init];
            
            if (snapshot.exists) {
                NSDictionary*dic = snapshot.value;
                
                NSArray *keys;
                if (![dic isKindOfClass:[NSNull class]]) {
                    keys = dic.allKeys;
                }
                for (int countData = 0;keys.count>countData;countData++) {
                    NSDictionary *restaurantData = [dic objectForKey:[keys objectAtIndex:countData]];
                    [app.arrRegisteredDictinaryRestaurantData addObject:restaurantData];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!app.boolOncePassed) {
                        app.boolOncePassed = true;
                        [app addTabBar];
                    }
                    
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!app.boolOncePassed) {
                        [app addTabBar];
                    }
                });
            }
            
        }];
        
        
        //get users' pay data
        FIRDatabaseReference* refPay = [[[FIRDatabase database] reference] child:@"users"];
        [refPay observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            app.arrPayDictinaryData = [[NSMutableArray alloc]init];
            NSDictionary*dic = snapshot.value;
            NSArray *keys;
            if (![dic isKindOfClass:[NSNull class]]) {
                keys = dic.allKeys;
            }
            
            
            for (int countData = 0;keys.count>countData;countData++) {
                NSDictionary *payData = [[dic objectForKey:[keys objectAtIndex:countData]] objectForKey:@"pay info"];
                
                
                NSMutableArray * dataarray = [[NSMutableArray alloc]init];
                NSArray *keysPay = [payData allKeys];
                NSArray *values = [payData allValues];
                
                
                for (int count = 0 ; keysPay.count > count; count++) {
                    NSString *datetext = [NSString stringWithFormat:@"%@", [keysPay objectAtIndex:count]] ;
                    datetext = [NSString stringWithFormat:@"%@/%@/%@", [datetext substringWithRange:NSMakeRange(5, 2)], [datetext substringWithRange:NSMakeRange(8, 2)], [datetext substringWithRange:NSMakeRange(0, 4)]];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                    NSDate *date = [dateFormatter dateFromString:datetext];
                    NSDictionary *dicpay = [[NSDictionary alloc]initWithObjectsAndKeys:date, @"date", [values objectAtIndex:count], @"amount",  nil];
                    [dataarray addObject:dicpay];
                }
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"date" ascending: NO];
                dataarray = [[NSMutableArray alloc]initWithArray:[dataarray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
                NSString *email = (NSString*)[[[dic objectForKey:[keys objectAtIndex:countData]] objectForKey:@"general info"] objectForKey:@"email"];
                
                if (![email isEqualToString:@" "]) {
                    NSString *userName = (NSString*)[[[dic objectForKey:[keys objectAtIndex:countData]] objectForKey:@"general info"] objectForKey:@"name"];
                    NSString *userPhotoURL = (NSString*)[[[dic objectForKey:[keys objectAtIndex:countData]] objectForKey:@"general info"] objectForKey:@"photourl"];
                    NSDictionary* PersonPayData = [[NSDictionary alloc]initWithObjectsAndKeys:userName, @"name", dataarray,@"pay info", userPhotoURL,@"photourl",  nil];
                    [app.arrPayDictinaryData addObject:PersonPayData];
                }
                
            }
            
        }];
        
        //get manager data
        app.user.userId = [NSString stringWithFormat:@"%@", [Request currentUserUid]];
        NSString *userID = app.user.userId;
        FIRDatabaseReference *refManagerInfor = [[[Request dataref] child:@"manager"]child: userID];
        [refManagerInfor observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            
            
            
            if (snapshot.exists) {
                app.user.name = [(NSDictionary*)(snapshot.value) objectForKey:@"name"];
                app.user.userId = userID;
                app.user.email = [(NSDictionary*)(snapshot.value) objectForKey:@"email"];
                app.user.photoURL = [NSURL URLWithString:[(NSDictionary*)(snapshot.value) objectForKey:@"photourl"]];
                app.user.cardCVID = [(NSDictionary*)(snapshot.value) objectForKey:@"cardcvid"];
                app.user.cardDate = [(NSDictionary*)(snapshot.value) objectForKey:@"carddate"];
                app.user.cardNumber = [(NSDictionary*)(snapshot.value) objectForKey:@"cardnumber"];
                
                
                
            }else{
                UIAlertController * loginErrorAlert = [UIAlertController
                                                       alertControllerWithTitle:@"Cannot find manager info"
                                                       message:@"you cannot access manager info. please check your manager membership."
                                                       preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:loginErrorAlert animated:YES completion:nil];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                    [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                
                [loginErrorAlert addAction:ok];
                
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view setUserInteractionEnabled:YES];
            
            
        }];
    });
    
    
}


#pragma mark - go SignUp
- (IBAction)goSignUp:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignUp *signUp = [storyboard instantiateViewControllerWithIdentifier:@"SignUp"];
    [self.navigationController pushViewController:signUp animated:YES];
    
}
#pragma mark - reset password
- (IBAction)didRequestPasswordReset:(UIButton *)sender {
    
    UIAlertController *requestResetPass = [UIAlertController
                                            alertControllerWithTitle:@"Reset Password"
                                            message:@"are you sure want reset your password?"
                                            preferredStyle:UIAlertControllerStyleAlert];
    

    UIAlertAction *prompt = [UIAlertAction actionWithTitle:@"reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UITextField *emailTextField = requestResetPass.textFields.firstObject;
        NSString* email = emailTextField.text;
        if ([email isEqualToString:@""]) {
            [requestResetPass dismissViewControllerAnimated:YES completion:nil];
        }
        [[FIRAuth auth] sendPasswordResetWithEmail:(email) completion:^(NSError *error){
            if (error) {
                NSLog(@"%@-%ld",error.localizedDescription, (long)error.code);
            }
            else
            {
                NSLog(@"request is sent to your email");
            }
        }];
        [requestResetPass dismissViewControllerAnimated:YES completion:nil];
        
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSLog(@"reset password cancelled.");
        [requestResetPass dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [requestResetPass addAction:prompt];
    [requestResetPass addAction:cancel];
    [requestResetPass addTextFieldWithConfigurationHandler:^(UITextField *emailText){
        emailText.placeholder = NSLocalizedString(@"email", "Address");
    }];
    
    [self presentViewController:requestResetPass animated:YES completion:nil];

}

@end
