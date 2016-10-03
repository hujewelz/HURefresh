//
//  UIScrollView+RefreshHeader.m
//  HURefresh
//
//  Created by jewelz on 16/7/17.
//  Copyright © 2016年 jewelz. All rights reserved.
//

#import "UIScrollView+RefreshHeader.h"
#import <objc/runtime.h>
#import "HURefresh.h"

@implementation UIScrollView (RefreshHeader)

- (void)addRefreshHeader {
    HURefresh *header = [[HURefresh alloc] init];
    self.header = header;
    [self insertSubview:header atIndex:10];
}

#pragma mark - Associate
- (void)setHeader:(HURefresh *)header {
    objc_setAssociatedObject(self, @selector(header), header, OBJC_ASSOCIATION_ASSIGN);
}

- (HURefresh *)header {
    return objc_getAssociatedObject(self, @selector(header));
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
