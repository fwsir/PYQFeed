//
//  SDLayer.m
//  PYQFeed
//
//  Created by BOOM on 16/8/22.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import "SDLayer.h"
#import "UIImage+Filter.h"
#import <SDWebImageManager.h>

static const CFIndex CATransactionCommitRunLoopOrder = 2000000;
static const CFIndex POPAnimationApplyRunLoopOrder = CATransactionCommitRunLoopOrder - 1;

@interface SDLayer ()
{
    CFRunLoopObserverRef _observer;
}

@property (nonatomic, assign) CGPoint startLocation;
@property (nonatomic, strong) NSString *type;

@end

@implementation SDLayer

@end
