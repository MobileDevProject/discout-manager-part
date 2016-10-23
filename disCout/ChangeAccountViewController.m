//
//  ChangeAccountViewController.m
//  disCout
//
//  Created by Theodor Hedin on 10/21/16.
//  Copyright © 2016 THedin. All rights reserved.
//
@import Firebase;
#import "Request.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "OfferViewController.h"
#import "Login.h"
#import "ChangeAccountViewController.h"

@interface ChangeAccountViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnRegisterCard;
//user info
@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UITextField *textOldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textOldPass;
@property (weak, nonatomic) IBOutlet UITextField *textNewEmail;
@property (weak, nonatomic) IBOutlet UITextField *textNewPass;

@property (strong, nonatomic) IBOutlet UIButton *btnPhoto;

@end

@implementation ChangeAccountViewController
{
    NSArray *businessArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnRegisterCard.layer.cornerRadius = 3;
    self.textUserName.delegate = self;
    self.textOldEmail.delegate = self;
    self.textOldPass.delegate = self;
    self.textNewEmail.delegate = self;
    self.textNewPass.delegate = self;
    //[self.btnPhoto setBackgroundImage:[UIImage imageNamed:@"person0.jpg"] forState:UIControlStateNormal];
    [self.btnPhoto setShowsTouchWhenHighlighted:NO];
}

- (IBAction)changePhoto:(UIButton *)sender {
    
    //UIActionSheet *objViewActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Gallery",@"Use Camera", nil];
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Take photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  //  The user tapped on "Take a photo"
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                  imagePickerController.delegate = self;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Use Gallery"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  //  The user tapped on "Choose existing"
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  imagePickerController.delegate = self;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage*image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.btnPhoto setBackgroundImage:image1 forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ChangeAccount:(UIButton *)sender {
    AppDelegate*app = [UIApplication sharedApplication].delegate;
    [self.view endEditing:YES];
    NSString *strUserEmail = self.textOldEmail.text;
    NSString *strUserPass = self.textOldPass.text;
    // [START headless_email_auth]
    if ([self.textOldEmail.text isEqualToString:app.user.email]) {
        
    
    if ([strUserEmail isEqual:@""] && [strUserPass isEqual:@""]) {
        UIAlertController * loginErrorAlert = [UIAlertController
                                               alertControllerWithTitle:@"Invalid name and password"
                                               message:@"Please enter the UserName and Password."
                                               preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:loginErrorAlert animated:YES completion:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSLog(@"reset password cancelled.");
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
        // [START headless_email_auth]
        [self.view setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            
            [[FIRAuth auth] signInWithEmail:strUserEmail
                                   password:strUserPass
                                 completion:^(FIRUser *user, NSError *error) {
                                     
                                     
                                     // [START_EXCLUDE]
                                     if (error != nil) {
                                         UIAlertController * loginErrorAlert = [UIAlertController
                                                                                alertControllerWithTitle:@"Login Failed"
                                                                                message:@"Authorization was not granted for the given email and password. Please checke for errors and try again."
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
                                             
                                             
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{///////
                                                 
                                                 
                                                 if (error==nil) {
                                                     [MBProgressHUD hideHUDForView:self.view animated:YES];/////
                                                     [self.view setUserInteractionEnabled:YES];
                                                     NSString *email = [Request currentUser].email;
                                                     AppDelegate *app = [UIApplication sharedApplication].delegate;
                                                     app.isManager = NO;
                                                     [self checkNewMail];
                                                 }
                                             });
                                             //after progress
                                         }];
                                         
                                         //NSLog(@"succeed login");
                                     }
                                     
                                     // [END_EXCLUDE]
                                 }];
        });//Add MBProgressBar (dispatch)
        
        // [END headless_email_auth]
    }
    }else{
        UIAlertController * loginErrorAlert = [UIAlertController
                                               alertControllerWithTitle:@"wrong email"
                                               message:@"The old email is wrong. Please checke for errors and try again."
                                               preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:loginErrorAlert animated:YES completion:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view setUserInteractionEnabled:YES];
            [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
            
        }];
        [loginErrorAlert addAction:ok];
    }
}

-(void)checkNewMail{
    [self.view endEditing:YES];
    NSString *strUserEmail = self.textNewEmail.text;
    NSString *strUserPass = self.textNewPass.text;
    // [START headless_email_auth]
    
    if ([strUserEmail isEqual:@""] && [strUserPass isEqual:@""]) {
        UIAlertController * loginErrorAlert = [UIAlertController
                                               alertControllerWithTitle:@"Invalid name and password"
                                               message:@"Please enter the UserName and Password."
                                               preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:loginErrorAlert animated:YES completion:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSLog(@"reset password cancelled.");
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
            // Do something...
            
            [[FIRAuth auth] createUserWithEmail:strUserEmail password:strUserPass completion:^(FIRUser *user, NSError *error)
             {
                 //after progress
                 
                     if (error != nil) {
                         // [START_EXCLUDE]
                         UIAlertController * loginErrorAlert = [UIAlertController
                                                                alertControllerWithTitle:@"Inavalid email address"
                                                                message:@"Wrong username or email. Please checke for errors and try again."
                                                                preferredStyle:UIAlertControllerStyleAlert];
                         [self presentViewController:loginErrorAlert animated:YES completion:nil];
                         UIAlertAction *ok = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                             //NSLog(@"reset password cancelled.");
                             [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                         }];
                         [loginErrorAlert addAction:ok];
                         // [END_EXCLUDE]
                     }
                     else{
                         
                         
                         
                         
                         UIAlertController * loginErrorAlert = [UIAlertController
                                                                alertControllerWithTitle:@"Success!"
                                                                message:@"Complete your Singup."
                                                                preferredStyle:UIAlertControllerStyleAlert];
                         
                         //go sign in
                         [self presentViewController:loginErrorAlert animated:YES completion:nil];
                         UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//                             [Request saveManagerEmail:self.textNewEmail.text];
//                             [Request saveManagerName:self.textUserName.text];
                             AppDelegate *app = [UIApplication sharedApplication].delegate;
                             app.user.userId = self.textNewPass.text;
                             app.user.name = self.textUserName.text;
                             app.user.email = self.textNewEmail.text;
                             
                             //
                                 FIRUser *user = app.userAccount;
                                 FIRAuthCredential *credential;
                             
                             
                                 [user reauthenticateWithCredential:credential completion:^(NSError *_Nullable error) {
                             
                                     if (error) {
                                         // An error happened.
                                     } else {
                                         // User re-authenticated.
                                         [user deleteWithCompletion:^(NSError *_Nullable error) {
                                             dispatch_async(dispatch_get_main_queue(), ^{///////
                                             if (error) {
                                                 // An error happened.
                                             } else {
                                                 // Account deleted.
                                                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                 Login *signUp = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
                                                 [self presentViewController:signUp animated:YES completion:nil];
                                                 
                                             }
                                                 });
                                         }];
                                     }
                                     
                                 }];
                             
                             
                             
                             //update
                             [Request upDateManagerAccount:[Request currentUserUid] email:app.user.email name:app.user.name];
                             //current photo save
//                             if (self.btnPhoto.currentBackgroundImage) {
//                                 
//                                 [Request saveUserPhoto:self.btnPhoto.currentBackgroundImage];
//                                 
//                             }
                             
//                             FIRUser *user = app.userAccount;
//                             [user deleteWithCompletion:^(NSError *_Nullable error) {
//                                 if (error) {
//                                     // An error happened.
//                                 } else {
//                                     // Account deleted.
//                                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                     Login *signUp = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
//                                     [self presentViewController:signUp animated:YES completion:nil];
//                                     
//                                 }
//                             }];
                             
                             [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                             //go register card
                             //[app addTabBar];
                         }];
                         [loginErrorAlert addAction:ok];
                         
                     }
                     [self.view setUserInteractionEnabled:YES];
                 
                 //after progress
             }
             ];
        });//Add MBProgressBar (dispatch)
    }
}
//-(void)removeOldEmail{
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    FIRUser *user = app.userAccount;
//    FIRAuthCredential *credential;
//    
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//    
//    [user reauthenticateWithCredential:credential completion:^(NSError *_Nullable error) {
//        
//        if (error) {
//            // An error happened.
//        } else {
//            // User re-authenticated.
//            [user deleteWithCompletion:^(NSError *_Nullable error) {
//                dispatch_async(dispatch_get_main_queue(), ^{///////
//                if (error) {
//                    // An error happened.
//                } else {
//                    // Account deleted.
//                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                    Login *signUp = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
//                    [self presentViewController:signUp animated:YES completion:nil];
//                    
//                }
//                    });
//            }];
//        }
//        
//    }];
//    });
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // do whatever you have to do
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)goSlide:(UIButton *)sender {
    [self.navigationController.revealViewController rightRevealToggle:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 Get the new view controller using [segue destinationViewController].
 Pass the selected object to the new view controller.
 }
 */

//definition of my functions
#pragma mark - saveUserData
- (void) viewWillAppear:(BOOL)animated{
    if (self.revealViewController) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
    
    UIImage *image1 = self.btnPhoto.currentBackgroundImage;
    if (!image1) {
        [self.btnPhoto setBackgroundImage:[UIImage imageNamed:@"person0.jpg"] forState:UIControlStateNormal];
    }
}

@end
