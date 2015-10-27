//
//  NSTimer+GLBlock.m
//  TestScrollView
//
//  Created by gongliang on 15/10/27.
//  Copyright © 2015年 AB. All rights reserved.
//

#import "NSTimer+GLBlock.h"

@implementation NSTimer (GLBlock)

+ (NSTimer *)gl_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                       repeats:(BOOL)yesOrNo
                                         block:(void(^)())inBlock {
    void (^block)() = [inBlock copy];
    NSTimer *timer = [self scheduledTimerWithTimeInterval:ti
                                                   target:self
                                                 selector:@selector(gl_excuteTimerBlock:)
                                                 userInfo:block
                                                  repeats:yesOrNo];
    return timer;
}

+ (NSTimer *)gl_timerWithTimeInterval:(NSTimeInterval)ti
                              repeats:(BOOL)yesOrNo
                                block:(void(^)())inBlock {
    void (^block)() = [inBlock copy];
    NSTimer *timer = [self timerWithTimeInterval:ti
                                          target:self
                                        selector:@selector(gl_excuteTimerBlock:)
                                        userInfo:block
                                         repeats:yesOrNo];
    return timer;
}

#pragma mark - prviate
+ (void)gl_excuteTimerBlock:(NSTimer *)inTimer {
    if (inTimer.userInfo) {
        void (^block)() = inTimer.userInfo;
        block();
    }
}

@end
