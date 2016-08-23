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

- (instancetype)initWithType:(NSString *)type
{
    if (self = [super init]) {
        _type = type;
    }
    
    return self;
}

- (void)setContentsWithUrl:(NSString *)url
{
    self.contents = (__bridge id)([UIImage imageNamed:@"placeholder"].CGImage);
    @weakify(self)
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:url]
                          options:SDWebImageCacheMemoryOnly
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            if (image)
                            {
                                @strongify(self)
                                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                    
                                    if (!_observer) {
                                        _observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting | kCFRunLoopExit, false, POPAnimationApplyRunLoopOrder, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
                                            self.contents = (__bridge id)(image.CGImage);
                                        });
                                        
                                        if (_observer)
                                        {
                                            CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
                                        }
                                    }
                                });
                                self.originImage = image;
                            }
                        }];
}

- (void)highlightedImage
{
    if (!self.highlightImage) {
        self.highlightImage = [self.originImage colorizeImageWithColor:[UIColor grayColor]];
    }
    
    self.contents = (__bridge id)(self.highlightImage.CGImage);
}

- (void)unhighlightedImage
{
    self.contents = (__bridge id)(self.originImage.CGImage);
}

- (void)touchCancelPoint
{
    if (!self.originImage) {
        return;
    }
    
    if ([self.type isEqualToString:@"img"]) {
        [self unhighlightedImage];
    }
}

- (BOOL)touchEndPoint:(CGPoint)point action:(VoidResultBlock)block
{
    if (!self.originImage) {
        return NO;
    }
    
    if ([self.type isEqualToString:@"img"]) {
        [self unhighlightedImage];
    }
    
    if (CGRectContainsRect(self.frame, point) && CGRectContainsPoint(self.frame, <#CGPoint point#>)) {
        <#statements#>
    }
}

@end
