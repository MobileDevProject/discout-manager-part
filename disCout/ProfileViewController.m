

@import Firebase;
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "Login.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "Request.h"
#import "ProfileViewController.h"

@interface ProfileViewController ()

{
    AppDelegate *app;
}
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPhoto;
@end

@implementation ProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view layoutIfNeeded];
    self.imgUserPhoto.layer.cornerRadius = self.imgUserPhoto.frame.size.height/2;
    self.imgUserPhoto.clipsToBounds = YES;
    self.imgUserPhoto.layer.borderWidth = 3.0f;
    self.imgUserPhoto.layer.borderColor = [UIColor colorWithRed:87.0f/255.0f green:71.0f/255.0f blue:47.0f/255.0f alpha:1].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    app = [UIApplication sharedApplication].delegate;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    [self.imgUserPhoto sd_setImageWithURL:app.user.photoURL
                           placeholderImage:[UIImage imageNamed:@"Splash.png"]];
    self.textUserName.text = app.user.name;
    self.textEmail.text = app.user.email;
    if ([[FIRAuth auth]currentUser].anonymous) {
        self.textEmail.text = @"";
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)goSideMenu:(UIButton *)sender {
    [self.revealViewController rightRevealToggle:nil];
    
}
- (IBAction)changePhoto:(UIButton *)sender {
    UIActionSheet *objViewActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Gallery",@"Use Camera", nil];
    
    objViewActionSheet.tag = 100;
    [objViewActionSheet showInView:self.view ];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 100) {
        //btnActionSheetClicked
        
        if (buttonIndex == 0) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
            
        }else if (buttonIndex == 1) {
            //check camera
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:@"Device has no camera"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                
                [myAlertView show];
                
            }
            else{
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
            
        }
        //take photo
        
    }
}

#pragma mark - Image Picker Controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    
    [self.imgUserPhoto setImage:image];
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)goSignUp:(id)sender {
    NSError *rerror;
    if ([[FIRAuth auth]currentUser].anonymous) {
        [[FIRAuth auth] signOut:&rerror];
    }
    

    [self.view endEditing:YES];
    NSString *strUserEmail = _textEmail.text;
    NSString *strUserPass = _textPassword.text;
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
        if ([self.textEmail.text isEqualToString:app.user.email]) {
            [Request registerUser:self.textUserName.text email:self.textEmail.text image:self.imgUserPhoto.image];
            return;
        }
        [self.view setUserInteractionEnabled:NO];
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            
            [[FIRAuth auth] createUserWithEmail:strUserEmail password:strUserPass completion:^(FIRUser *user, NSError *error)
             {
                 //after progress
                 dispatch_async(dispatch_get_main_queue(), ^{///////
                     
                     
                     if (error != nil) {
                         UIAlertController * loginErrorAlert = [UIAlertController
                                                                alertControllerWithTitle:@"Signup Failed"
                                                                message:error.localizedDescription
                                                                preferredStyle:UIAlertControllerStyleAlert];
                         [self presentViewController:loginErrorAlert animated:YES completion:nil];
                         UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                             [loginErrorAlert dismissViewControllerAnimated:YES completion:nil];
                         }];
                         [loginErrorAlert addAction:ok];
                         [MBProgressHUD hideHUDForView:self.view animated:YES];/////
                         [self.view setUserInteractionEnabled:YES];
                     }
                     else{
                         [[NSUserDefaults standardUserDefaults] setObject:strUserEmail forKey:@"preferenceEmail"];
                         [[NSUserDefaults standardUserDefaults] setObject:strUserPass forKey:@"preferencePass"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         UIAlertController * loginErrorAlert = [UIAlertController
                                                                alertControllerWithTitle:@"Success!"
                                                                message:@"Complete your Singup."
                                                                preferredStyle:UIAlertControllerStyleAlert];
                         //current photo save
                         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
                         NSString *documentsDirectory = [paths objectAtIndex:0];
                         NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
                         NSData *imageData = UIImagePNGRepresentation(self.imgUserPhoto.image);
                         [imageData writeToFile:savedImagePath atomically:NO];
                         //register user
                         dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                             // Do something...
                             
                             
                             FIRUser *user = [FIRAuth auth].currentUser;
                             FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
                             NSString *userId = user.uid;
                             FIRStorage *storage = [FIRStorage storage];
                             FIRStorageReference *storageRef = [storage reference];
                             AppDelegate *app = [UIApplication sharedApplication].delegate;
                             dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                 FIRStorageReference *photoImagesRef = [storageRef child:[NSString stringWithFormat:@"users photo/%@/photo.jpg", [Request currentUserUid]] ];
                                 NSData *imageData = UIImagePNGRepresentation(self.imgUserPhoto.image);
                                 
                                 //image compress until size < 1 MB
                                 int count = 0;
                                 while ([imageData length] > 1000000) {
                                     imageData = UIImageJPEGRepresentation(self.imgUserPhoto.image, powf(0.9, count));
                                     count++;
                                     NSLog(@"just shrunk it once.");
                                 }
                                 
                                 // Upload the file to the path "images/userID.PNG"f
                                 
                                 [photoImagesRef putData:imageData metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
                                     if (error != nil) {
                                         // Uh-oh, an error occurred!
                                     } else {
                                         // Metadata contains file metadata such as size, content-type, and download URL.
                                         changeRequest.displayName = strUserEmail;
                                         changeRequest.photoURL = metadata.downloadURL;
                                         [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if (error) {
                                                     // An error happened.
                                                     NSLog(@"%@", error.description);
                                                 } else {
                                                     // Profile updated.
                                                     
                                                     NSDictionary *userData = @{@"name":_textUserName.text,
                                                                                @"email":strUserEmail,
                                                                                @"photourl":[metadata.downloadURL absoluteString],                                                   @"userid":userId,
                                                                                @"numberofcomments":@"0"
                                                                                };
                                                     [[[[[FIRDatabase database] reference] child:@"users"] child:userId]setValue:userData];
                                                     //after progress
                                                     dispatch_async(dispatch_get_main_queue(), ^{///////
                                                         [MBProgressHUD hideHUDForView:self.view animated:YES];/////
                                                         [self.view setUserInteractionEnabled:YES];
                                                         [self presentViewController:loginErrorAlert animated:YES completion:nil];
                                                         UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"                                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                                             Login *DirectionBranchTableScreen = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"];
                                                             [self.navigationController pushViewController:DirectionBranchTableScreen animated:YES];
                                                         }];
                                                         [loginErrorAlert addAction:ok];
                                                     });
                                                     
                                                 }
                                                 
                                             });
                                         }];
                                         
                                     }
                                 }];
                                 
                             });
                             
                             
                             
                             
                             
                             
                             //go sign in
                             
                         });
                         
                         
                     }
                     
                 });
                 //after progress
             }
             ];
        });//Add MBProgressBar (dispatch)
    }
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // do whatever you have to do
    
    [textField resignFirstResponder];
    return YES;
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWasShown:(NSNotification *)aNotification {
    NSDictionary *info = aNotification.userInfo;
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGPoint viewOrigin = self.view.frame.origin;
    
    CGSize viewSize = self.view.frame.size;
    viewOrigin.y = [UIScreen mainScreen].bounds.size.height - viewSize.height - kbSize.height;
    [self.view setFrame:CGRectMake(viewOrigin.x, viewOrigin.y, viewSize.width, viewSize.height)];
}
- (void)keyboardBeHidden:(NSNotification *)aNotification {
    NSDictionary *info = aNotification.userInfo;
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGPoint viewOrigin = self.view.frame.origin;
    
    CGSize viewSize = self.view.frame.size;
    viewOrigin.y = viewOrigin.y + kbSize.height;
    
    [self.view setFrame:CGRectMake(viewOrigin.x, viewOrigin.y, viewSize.width, viewSize.height)];
}
@end
