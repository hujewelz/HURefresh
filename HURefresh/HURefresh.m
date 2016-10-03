//
//  HURefresh.m
//  HURefresh
//
//  Created by jewelz on 16/5/2.
//  Copyright © 2016年 jewelz. All rights reserved.
//

#import "HURefresh.h"

#define kObserKey @"contentOffset"

@interface HURefresh () {
    BOOL _isRefreshing;
}

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
//@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation HURefresh


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, -120, 100, 120)];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        [self.layer addSublayer:self.progressLayer];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        _scrollView = (UIScrollView *)newSuperview;
        self.center = CGPointMake(_scrollView.center.x, self.center.y);
        [_scrollView addObserver:self forKeyPath:kObserKey options:NSKeyValueObservingOptionNew context:nil];
    }
    else
        [_scrollView removeObserver:self forKeyPath:kObserKey];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:kObserKey]) return;
    NSValue *value = change[NSKeyValueChangeNewKey];
    CGFloat offsetY = value.CGPointValue.y;
    CGFloat y = - offsetY;
    NSLog(@"offset y: %.2f", y);
    
    if (offsetY > 0) {
        return;
    }
    
    if (!_isRefreshing) {
        CGRect tmp = self.frame;
        //if (y >= 120) {
            
//            tmp.origin.y = -120;
//            self.frame = tmp;
//        }
//        else {
//            tmp.origin.y = -y;
//            self.frame = tmp;
//        }
        
        CGFloat progress =  (60 - (offsetY+120)) / 60;
        [self updateProgress:progress];

    }
    
    //如果到达临界点，则执行刷新动画
    if (-offsetY >=120 && !self.scrollView.isDragging &&!_isRefreshing) {
        [self beginRefreshing];
    }
 
    
}

- (void)updateProgress:(CGFloat)progress {
    CABasicAnimation *strokeAnimatinStart = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimatinStart.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeAnimatinStart.duration = 0.5;
    strokeAnimatinStart.fromValue = @0;
    strokeAnimatinStart.toValue = @(progress);
    strokeAnimatinStart.beginTime = 1;
    strokeAnimatinStart.removedOnCompletion = NO;
    strokeAnimatinStart.fillMode = kCAFillModeForwards;
    //strokeAnimatinStart.repeatCount = 1;
    [self.progressLayer addAnimation:strokeAnimatinStart forKey:nil];
}

- (void)beginRefreshing {
    NSLog(@"begin freshing");
    _isRefreshing = YES;
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = 120;
        self.scrollView.contentInset = inset;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointZero;
            self.scrollView.contentInset = UIEdgeInsetsZero;
            _isRefreshing = NO;
        }];
        
    });
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.bounds = CGRectMake(0, 0, 100, 100);
        _progressLayer.position = CGPointMake(self.frame.size.width/2, 60);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:50 startAngle:0 endAngle:2*M_PI clockwise:YES];
        _progressLayer.path = path.CGPath;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        _progressLayer.lineWidth = 3;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
        _progressLayer.lineCap = kCALineCapRound;
        
    }
    return _progressLayer;
}

@end
