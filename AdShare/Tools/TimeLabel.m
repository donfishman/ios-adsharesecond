//
//  TimeLabel.m
//  PNHelper
//
//  Created by ZLWL on 2018/5/16.
//  Copyright © 2018年 YAND. All rights reserved.
//

#import "TimeLabel.h"

@interface TimeLabel ()

@property (nonatomic, strong)NSTimer *timer;

@end


@implementation TimeLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)timeHeadle {
    
    self.second--;
    if (self.second==-1) {
        self.second=59;
        self.minute--;
        if (self.minute==-1) {
            self.minute=59;
            self.hour--;
        }
    }

    if (self.hour>0) {
        self.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",(long)self.hour,(long)self.minute,(long)self.second];
    }else if (self.hour==0) {
        self.text = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)self.minute,(long)self.second];
    }else if (self.minute==0)
    {
        self.text = [NSString stringWithFormat:@"%.2ld",(long)self.second];
    }
    
    if (self.second==0 && self.minute==0 && self.hour==0) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
