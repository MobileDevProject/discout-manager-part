//
//  customTabbar.m
//  disCout
//
//  Created by Theodor Hedin on 10/28/16.
//  Copyright © 2016 THedin. All rights reserved.
//

#import "customTabbar.h"

@implementation customTabbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGSize)sizeThatFits:(CGSize)size{
    CGSize size1 = size;
    size1.height = 70;
    return size1;
}

@end
