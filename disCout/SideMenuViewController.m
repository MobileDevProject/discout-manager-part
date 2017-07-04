//
//  SideMenuViewController.m
//  FoodOrder
//
//  Created by Theodor Hedin on 5/20/16.
//  Copyright © 2016 THedin. All rights reserved.
//
@import Firebase;
@import FirebaseAuth;
#import "SWRevealViewController.h"
#import "SideMenuViewController.h"
#import "Request.h"
#import "AppDelegate.h"
@interface SideMenuViewController ()

@end

@implementation SideMenuViewController
{
    NSArray *menuItems;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        //go main view
        [self.revealViewController performSegueWithIdentifier:@"sw_front" sender:nil];
        [self.revealViewController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
    }else if(indexPath.row==1){
        
        //log out
        NSError *error;
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        app.boolOncePassed = false;
        [[FIRAuth auth] signOut:&error];
        UINavigationController *homeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignViewController"];
        [self presentViewController:homeViewController animated:YES completion:nil];
    }

}


@end
