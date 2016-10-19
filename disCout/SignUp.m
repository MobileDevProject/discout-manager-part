//
//  SignUp.m
//  disCout
//
//  Created by Theodor Hedin on 7/20/16.
//  Copyright © 2016 THedin. All rights reserved.
//

@import Firebase;
#import "Request.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "OfferViewController.h"
#import "SignUp.h"

@interface SignUp ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnRegisterCard;
//user info
@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPass;
//card info

@property (strong, nonatomic) IBOutlet UIButton *btnPhoto;

@end

@implementation SignUp
{
    NSArray *businessArray;
    NSNotification *noti;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnRegisterCard.layer.cornerRadius = 3;
    //[self.btnPhoto setBackgroundImage:[UIImage imageNamed:@"person0.jpg"] forState:UIControlStateNormal];
    [self.btnPhoto setShowsTouchWhenHighlighted:NO];
}
- (IBAction)goSignIn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)RegisterCard:(UIButton *)sender {
    [self playSound:@"m3"];
    [self.view endEditing:YES];
    NSString *strUserEmail = self.textEmail.text;
    NSString *strUserPass = self.textPass.text;
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
                 dispatch_async(dispatch_get_main_queue(), ^{///////
                     [MBProgressHUD hideHUDForView:self.view animated:YES];/////
                     //if ([CreditCard_Validator checkCreditCardNumber:self.textCardNumber.text]) {
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
                             [Request saveUserEmail:self.textEmail.text];
                             [Request saveUserName:self.textUserName.text];
                             AppDelegate *app = [UIApplication sharedApplication].delegate;
                             app.user.userId = [Request currentUserUid];
                             app.user.name = self.textUserName.text;
                             app.user.email = self.textEmail.text;
                             app.user.isCancelled = @"false";
                             [Request cancelMembership];
                             //current photo save
                             if (self.btnPhoto.currentBackgroundImage) {
                                
                                 [Request saveUserPhoto:self.btnPhoto.currentBackgroundImage];
                                 
                             }
                             [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                             //go register card
                             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                             SignUp *signUp = [storyboard instantiateViewControllerWithIdentifier:@"SignUp"];
                             [self.navigationController pushViewController:signUp animated:YES];
                             //[app addTabBar];
                         }];
                         [loginErrorAlert addAction:ok];
                         
                     }
                     [self.view setUserInteractionEnabled:YES];
                 });
                 //after progress
             }
             ];
        });//Add MBProgressBar (dispatch)
    }
}
- (IBAction)BackToSignIn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SeeOffer:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OfferViewController *offerViewController = [storyboard instantiateViewControllerWithIdentifier:@"OfferViewController"];
    [self.navigationController pushViewController:offerViewController animated:YES];
}


-(void)playSound:fileName{
    
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
    AudioServicesPlaySystemSound(soundID);
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // do whatever you have to do
    
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//definition of my functions
#pragma mark - saveUserData
- (void) viewWillAppear:(BOOL)animated{
    
    UIImage *image1 = self.btnPhoto.currentBackgroundImage;
    if (!image1) {
        [self.btnPhoto setBackgroundImage:[UIImage imageNamed:@"person0.jpg"] forState:UIControlStateNormal];
    }
    //[self.btnPhoto setBackgroundImage:[UIImage imageNamed:@"person0.jpg"] forState:UIControlStateNormal];
}


@end
