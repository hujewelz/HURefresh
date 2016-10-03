//
//  UIScrollView+RefreshHeader.h
//  HURefresh
//
//  Created by jewelz on 16/7/17.
//  Copyright © 2016年 jewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HURefresh;
@interface UIScrollView (RefreshHeader)

@property (nonatomic, strong) HURefresh *header;

- (void)addRefreshHeader;

@end
