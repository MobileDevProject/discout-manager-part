//
//  RegisterCardViewController.m
//  disCout
//
//  Created by Theodor Hedin on 10/8/16.
//  Copyright © 2016 THedin. All rights reserved.
//

#import "RegisterCardViewController.h"
#import "AppDelegate.h"
@import Firebase;
#import "SWRevealViewController.h"
#import "Request.h"
#import "CreditCard-Validator.h"
#import "SignUp.h"
@interface RegisterCardViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textCardNumber;
@property (strong, nonatomic) IBOutlet UITextField *textDate;
@property (strong, nonatomic) IBOutlet UITextField *textCV;
@end

@implementation RegisterCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.textCardNumber.delegate = self;
    self.textDate.delegate = self;
    self.textCV.delegate= self;
    // Do any additional setup after loading the view.a
}

- (void) viewWillAppear:(BOOL)animated{
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}


- (IBAction)registerCard:(UIButton *)sender {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    //please check  1. user is signup on your app?
    //              2. user's card is corrected as credit card?
    //              3. in user's card is there any money as adequate as membership?
    
    if (app.user.userId) {//1. signup?
        if ([CreditCard_Validator checkCreditCardNumber:self.textCardNumber.text]) {//is the correct credit card? this is not correct now.
            NSError * error = [Request saveManagerCardInfo:self.textCardNumber.text cvid:self.textCV.text date:self.textDate.text];
            if (error) {
                UIAlertController * loginErrorAlert = [UIAlertController
                                                       alertControllerWithTitle:@"register error"
                                                       message:@"There is an error for registering your card. Please try again."
                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:loginErrorAlert animated:YES completion:nil];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [loginErrorAlert addAction:ok];
            }
        }else{
            UIAlertController * loginErrorAlert = [UIAlertController
                                                   alertControllerWithTitle:@"Invalid Card"
                                                   message:@"Please try again."
                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:loginErrorAlert animated:YES completion:nil];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [loginErrorAlert addAction:ok];
        }
    }else{
        UIAlertController * loginErrorAlert = [UIAlertController
                                               alertControllerWithTitle:@"sign up first"
                                               message:@"Please sign up before register your card"
                                               preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:loginErrorAlert animated:YES completion:nil];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //go sign up
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SignUp *signUp = [storyboard instantiateViewControllerWithIdentifier:@"SignUp"];
            [self.navigationController pushViewController:signUp animated:YES];
            //[loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [loginErrorAlert addAction:ok];
    }
    
    
    
}

- (IBAction)goSlide:(UIButton *)sender {
    [self.revealViewController rightRevealToggle:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // do whatever you have to do    
    [textField resignFirstResponder];
    return YES;
}
@end
