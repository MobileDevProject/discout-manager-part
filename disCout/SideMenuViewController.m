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

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return [menuItems count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    return cell;
//}
//

        

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        [self.revealViewController performSegueWithIdentifier:@"sw_front" sender:nil];
        [self.revealViewController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
    }else if(indexPath.row==3){
        NSError *error;
        [[FIRAuth auth] signOut:&error];
        NSLog(@"error: %@", error.localizedDescription);
        UINavigationController *homeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignViewController"];
        [self presentViewController:homeViewController animated:YES completion:nil];
    }
    
}


@end
