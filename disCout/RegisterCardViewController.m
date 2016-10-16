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
@interface RegisterCardViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textCardNumber;
@property (strong, nonatomic) IBOutlet UITextField *textDate;
@property (strong, nonatomic) IBOutlet UITextField *textCV;
@end

@implementation RegisterCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    // Do any additional setup after loading the view.a
}

- (void) viewWillAppear:(BOOL)animated{
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
}
- (IBAction)registerCard:(UIButton *)sender {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (app.user.userId) {
        if ([CreditCard_Validator checkCreditCardNumber:self.textCardNumber.text]) {
            [Request saveCardInfo:self.textCardNumber.text cvid:self.textCV.text date:self.textDate.text];
        }else{
            UIAlertController * loginErrorAlert = [UIAlertController
                                                   alertControllerWithTitle:@"Invalid Card"
                                                   message:@"Please try again."
                                                   preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:loginErrorAlert animated:YES completion:nil];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [loginErrorAlert addAction:ok];
        }
    }
    
    
    
}
- (IBAction)goSlide:(UIButton *)sender {
    [self.revealViewController rightRevealToggle:nil];
}

@end
