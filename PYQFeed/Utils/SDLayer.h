//
//  SDLayer.h
//  PYQFeed
//
//  Created by BOOM on 16/8/22.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SDLayer : CALayer

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *highlightImage;

- (instancetype)initWithType:(NSString *)type;
- (void)setContentsWithUrl:(NSString *)url;
- (void)highlightedImage;
- (void)unhighlightedImage;
- (BOOL)touchBeginPoint:(CGPoint)point;
- (void)touchCancelPoint;
- (BOOL)touchEndPoint:(CGPoint)point action:(VoidResultBlock)block;
- (void)clearPendingListObserver;

@end
