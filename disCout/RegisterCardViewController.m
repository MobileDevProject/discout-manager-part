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
@property (strong, nonatomic) IBOutlet UIButton *button5Membership;
@property (strong, nonatomic) IBOutlet UIButton *button10Membership;

@end

@implementation RegisterCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //selected the btnCheckrate button
    [self.button5Membership setBackgroundImage:[UIImage imageNamed:@"btn_Search_InActive.png"] forState:UIControlStateNormal];
    [self.button5Membership setTintColor:[UIColor colorWithWhite:1 alpha:0]];
    [self.button5Membership setBackgroundImage:[UIImage imageNamed:@"btn_Search_Active.png"] forState:UIControlStateSelected];
    [self.button5Membership setSelected:YES];
    
    [self.button10Membership setBackgroundImage:[UIImage imageNamed:@"btn_Search_InActive.png"] forState:UIControlStateNormal];
    [self.button10Membership setTintColor:[UIColor colorWithWhite:1 alpha:0]];
    [self.button10Membership setBackgroundImage:[UIImage imageNamed:@"btn_Search_Active.png"] forState:UIControlStateSelected];
    [self.button10Membership setSelected:NO];

    self.textCardNumber.delegate = self;
    self.textDate.delegate = self;
    self.textCV.delegate= self;
    // Do any additional setup after loading the view.a
}

- (void) viewWillAppear:(BOOL)animated{
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}
- (IBAction)set5Membership:(UIButton *)sender {

    [self.button10Membership setSelected:NO];
    [sender setSelected:YES];

    
}
- (IBAction)set10Membership:(UIButton *)sender {
    
    [self.button5Membership setSelected:NO];
    [sender setSelected:YES];
    
    
}

- (IBAction)registerCard:(UIButton *)sender {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSString *membership;
    if (self.button5Membership.selected) {
        membership = @"5";
    }else{
        membership = @"10";
    }
    //please check  1. user is signup on your app?
    //              2. user's card is corrected as credit card?
    //              3. in user's card is there any money as adequate as membership?
    
    if (app.user.userId) {//1. signup?
        if ([CreditCard_Validator checkCreditCardNumber:self.textCardNumber.text]) {//is the correct credit card? this is not correct now.
            NSError * error = [Request saveCardInfo:self.textCardNumber.text cvid:self.textCV.text date:self.textDate.text membership:membership];
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
- (IBAction)cancelMembership:(UIButton *)sender {
    NSString *membership;
    if (self.button5Membership.selected) {
        membership = @"5";
    }else{
        membership = @"10";
    }
    UIAlertController * loginErrorAlert = [UIAlertController
                                           alertControllerWithTitle:@"Cancel Membership"
                                           message:@"Are you sure cancel your membership?"
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:loginErrorAlert animated:YES completion:nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
        [Request saveCardInfo:@"" cvid:@"" date:@"" membership:@""];
        [Request cancelMembership];
        }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [loginErrorAlert addAction:ok];
    [loginErrorAlert addAction:cancel];
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
