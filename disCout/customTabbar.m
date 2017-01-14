//
//  customTabbar.m
//  disCout
//
//  Created by Theodor Hedin on 10/28/16.
//  Copyright © 2016 THedin. All rights reserved.
//

#import "customTabbar.h"

@implementation customTabbar


//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    [self setFrame:rect];
//    [self setUnselectedItemTintColor:[UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]];
//    [self setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
//    [self setTintColor:[UIColor colorWithRed:243/255.0 green:101/255.0 blue:35/255.0 alpha:1.0]];
//    //[self drawRect:rect];
//    [self setBackgroundColor:[UIColor blackColor]];
//    
//}

-(CGSize)sizeThatFits:(CGSize)size{
    CGSize size1 = size;
    size1.height = 70;
    return size1;
    
}

@end
