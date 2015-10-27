//
//  NSTimer+GLBlock.h
//  TestScrollView
//
//  Created by gongliang on 15/10/27.
//  Copyright © 2015年 AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (GLBlock)

+ (NSTimer *)gl_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                       repeats:(BOOL)yesOrNo
                                         block:(void(^)())inBlock;
+ (NSTimer *)gl_timerWithTimeInterval:(NSTimeInterval)ti
                              repeats:(BOOL)yesOrNo
                                block:(void(^)())inBlock;

@end
