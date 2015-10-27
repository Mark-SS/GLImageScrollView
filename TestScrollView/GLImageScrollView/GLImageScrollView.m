//
//  GLImageScrollView.m
//  TestScrollView
//
//  Created by gongliang on 15/9/24.
//  Copyright © 2015年 AB. All rights reserved.
//

#import "GLImageScrollView.h"
#import <Masonry/Masonry.h>
#import <Masonry/View+MASShorthandAdditions.h>
#import "NSTimer+GLBlock.h"

static const NSInteger kStartTag = 10000;
static const CGFloat kDefaultScrollInterval = 2;

@interface GLImageScrollView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger count;

@end

@implementation GLImageScrollView

- (void)dealloc {
    [_timer invalidate];
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [self setUp];
}

- (void)setUp {

    [self defaultConfig];

    self.scrollView = [UIScrollView new];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    UIEdgeInsets padding = UIEdgeInsetsZero;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding);
    }];
    
    self.contentView = [UIView new];
    [self.scrollView addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
}

- (void)defaultConfig {
    self.cycleScroll = YES;
    self.autoScroll = YES;
    self.scrollInterval = kDefaultScrollInterval;
}

- (NSTimer *)timer {
    if (!_timer || !_timer.isValid) {
        __weak typeof(self) bself = self;
        _timer = [NSTimer gl_scheduledTimerWithTimeInterval:self.scrollInterval repeats:YES block:^{
            [bself handleScrollTimer];
        }];
    }
    return _timer;
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    [self autoScrollAction];
}

- (void)setScrollInterval:(CGFloat)scrollInterval {
    _scrollInterval = scrollInterval;
    [self autoScrollAction];
}

- (void)autoScrollAction {
    [self.timer invalidate];
    self.timer = nil;
    if (self.autoScroll && self.scrollInterval > 0) {
        [self timer];
    }
}

- (void)reloadData {

    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    self.count = [self.delegate numberOfItems];
    if (self.count == 0) {
        return ;
    }
    
    if (self.isCyclScroll && self.count > 1) {
        [self autoScrollAction];
        self.count += 2;
    }
    
    UIView *lastView;
    for (NSInteger i = 0; i < self.count; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = kStartTag + i;
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.equalTo(self.mas_width);
            make.leading.equalTo(lastView ? lastView.mas_trailing : self.contentView.mas_leading) ;
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleTapGesture:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
        NSInteger index = i;
        if (self.isCyclScroll) {
            if (index >= self.count - 2) {
                index -= (self.count - 2);
            }
        }
        lastView = imageView;
        [self.delegate imageScrollView:self
                 loadImageForImageView:imageView
                                 index:index];
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(lastView.mas_trailing);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self timer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat targetX = scrollView.contentOffset.x;
    CGFloat item_width = CGRectGetWidth(scrollView.frame);
    if (self.isCyclScroll) {
        if (targetX >= item_width * (self.count - 1)) {
            targetX = item_width;
            self.scrollView.contentOffset = CGPointMake(targetX, 0);
        } else if (targetX <= 0) {
            targetX = item_width * (self.count - 2);
            self.scrollView.contentOffset = CGPointMake(targetX, 0);
        }
    }
}

- (void)handleScrollTimer {
    if (self.count <= 1) {
        return;
    }
    CGFloat item_width = CGRectGetWidth(self.scrollView.frame);
    CGFloat targetX = self.scrollView.contentOffset.x + item_width;
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    
    //如果不是循环滚动，超出后复原
    if (!self.isCyclScroll && targetX > item_width * (self.count - 1)) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSInteger index = imageView.tag - kStartTag;
    if (self.isCyclScroll) {
        if (index >= self.count - 2) {
            index -= (self.count - 2);
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageScrollView:didTapAtIndex:)]) {
        [self.delegate imageScrollView:self didTapAtIndex:index];
    }
}

@end
