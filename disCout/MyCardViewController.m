//
//  MyCardViewController.m
//  disCout
//
//  Created by Theodor Hedin on 8/4/16.
//  Copyright © 2016 THedin. All rights reserved.
//

#import "MyCardViewController.h"
@import Firebase;

NSArray *ArrResThumbnailsName;
NSArray *ArrResNames;
NSMutableArray *arrImage;
@interface MyCardViewController()
@property (weak, nonatomic) IBOutlet UICollectionView *tablePayList;

@end

@implementation MyCardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    ArrResThumbnailsName = [NSArray arrayWithObjects:@"res1.png", @"res2.png",@"res3.png",@"res5.png",@"res6.png",@"res7.png",@"res8.png",@"res9.png",@"res10.png",@"res11.png", nil];
    ArrResNames = [NSArray arrayWithObjects:@"res1", @"res2",@"res3",@"res5",@"res6",@"res7",@"res8",@"res9",@"res10",@"res11", nil];
    NSString *tiler = [ArrResNames objectAtIndex:3];
    arrImage = [[NSMutableArray alloc]initWithObjects:nil,nil, nil];
    //display all res info
    
    FIRStorageReference *storageRef1 = [[FIRStorage storage] reference];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int index = 0 ; ArrResNames.count>index; index++) {
            FIRStorageReference *imageRef = [[storageRef1 child:@"thumbnails"] child:[ArrResNames objectAtIndex:index]];
            [imageRef dataWithMaxSize:(1 * 1024 * 1024) completion:^(NSData * _Nullable data, NSError * _Nullable error) {
                if(error != nil)
                {
                    NSLog(@"the is error:");
                    NSLog(@"%@", error.localizedDescription);
                    NSString *myID = [NSString stringWithFormat:@"%@", @"yandex mail"];
                }
                else{
                    //UIImage* myimage = [[UIImage alloc]init];
                    UIImage* myimage = [UIImage imageWithData:data];
                    [arrImage addObject: myimage];
                    NSLog(@"download start");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tablePayList reloadData];
                        NSLog(@"download end");
                    });
                }
            }];
        }
        
    });
    
    //UICollectionViewController *resCollection =
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return ArrResThumbnailsName.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *identifier = @"resCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *resImageView = (UIImageView *)[cell viewWithTag:100];
    //resImageView.image = [arrImage objectAtIndex:indexPath.row];
    UILabel *resName = (UILabel *)[cell viewWithTag:101];
    resName.text = [ArrResThumbnailsName objectAtIndex:indexPath.row];
    
    
    FIRStorageReference *storageRef1 = [[FIRStorage storage] reference];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FIRStorageReference *imageRef = [storageRef1 child:[ArrResNames objectAtIndex:2]];
        [imageRef dataWithMaxSize:(1 * 1024 * 1024) completion:^(NSData * _Nullable data, NSError * _Nullable error) {
            if(error != nil)
            {
                NSLog(@"the is error:");
                NSLog(@"%@", error.localizedDescription);
                //NSString *myID = [NSString stringWithFormat:@"%@", @"yandex mail"];
            }
            else{
                //UIImage* myimage = [[UIImage alloc]init];
                UIImage* myimage = [UIImage imageWithData:data];
                //[arrImage addObject: myimage];
                
                NSLog(@"download start");
                dispatch_async(dispatch_get_main_queue(), ^{
                    resImageView.image = myimage;
                    [self.tablePayList reloadData];
                    NSLog(@"download end");
                });
            }
        }];
        
        
    });
    
    
    return cell;
    //UIImageView *resImage =
    
}

@end
