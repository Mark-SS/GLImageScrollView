//
//  GLImageScrollView.h
//  TestScrollView
//
//  Created by gongliang on 15/9/24.
//  Copyright © 2015年 AB. All rights reserved.
//  
//

#import <UIKit/UIKit.h>
@class GLImageScrollView;

@protocol GLImageScrollViewDelegate <NSObject>

@required

- (NSInteger)numberOfItems;

- (void)imageScrollView:(GLImageScrollView *)imageScrollView
  loadImageForImageView:(UIImageView *)imageView
                  index:(NSInteger)index;

@optional

- (void)imageScrollView:(GLImageScrollView *)imageScrollView
          didTapAtIndex:(NSInteger)index;

@end

@interface GLImageScrollView : UIView

@property (nonatomic, weak) IBOutlet id<GLImageScrollViewDelegate> delegate;

@property (nonatomic, assign, getter=isAutoScroll) BOOL autoScroll;

@property (nonatomic, assign, getter=isCyclScroll) BOOL cycleScroll;

@property (nonatomic, assign) CGFloat scrollInterval;

- (void)reloadData;

@end
