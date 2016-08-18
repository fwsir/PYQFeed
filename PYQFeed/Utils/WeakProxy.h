//
//  WeakProxy.h
//  PYQFeed
//
//  Created by BOOM on 16/8/18.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;

@end
