//
//  PYQFeedCell.h
//  PYQFeed
//
//  Created by BOOM on 16/8/22.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYQFeedCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *sources;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *linkString;

- (void)configWithData:(NSDictionary *)data;
- (void)removeHeaderLayer;

@end
