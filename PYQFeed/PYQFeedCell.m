//
//  PYQFeedCell.m
//  PYQFeed
//
//  Created by BOOM on 16/8/22.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import "SDLayer.h"
#import "PYQFeedCell.h"
#import "ContentTextManager.h"
#import "NSString+Additions.h"

@interface PYQFeedCell ()

@property (nonatomic, weak) SDLayer *headImgLayer;
@property (nonatomic, assign) CGPoint startLocation;
@property (nonatomic, assign) CGRect nickNameRect;

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *contentStr;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGSize nickNameSize;
@property (nonatomic, assign) CGSize contentSize;

@property (nonatomic, strong) NSArray *resources;
@property (nonatomic, strong) CALayer *separatorLayer;

@property (nonatomic, strong) ContentTextManager *drawer;

@end

@implementation PYQFeedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CALayer *separatorLayer = [[CALayer alloc] init];
        separatorLayer.backgroundColor = UIColorFromRGB(0xe6e6e6).CGColor;
        [self.contentView.layer addSublayer:separatorLayer];
        _separatorLayer = separatorLayer;
    }
    
    return self;
}

- (void)configWithData:(NSDictionary *)data
{
    self.sources = [NSMutableArray array];
    
    self.nickNameSize = [data[NickSizeKey] CGSizeValue];
    self.contentSize = [data[ContentSizeKey] CGSizeValue];
    self.nickNameRect = (CGRect){kTextXOffset, kSpec, self.nickNameSize};
    self.nickName = data[NickNameKey];
    self.contentStr = data[ContentKey];
    
    CGFloat resHeight = [data[ResHeightKey] floatValue];
    CGFloat resWidth = [data[ResWidthKey] floatValue];
    
    self.size = CGSizeMake(ScreenWidth, ceil(self.contentSize.height + kSpec * 4 + self.nickNameSize.height + resHeight));
    
    self.separatorLayer.frame = (CGRect){0, self.size.height - 1, ScreenWidth, 1};
    
    SDLayer *headImgLayer = [[SDLayer alloc] initWithType:ImgKey];
    headImgLayer.frame = CGRectMake(kSpec, kSpec, kAvatar, kAvatar);
    [self.contentView.layer addSublayer:headImgLayer];
    self.headImgLayer = headImgLayer;
    [self.headImgLayer setContentsWithUrl:data[AvatarKey]];
    [self _fillContents:nil];
    
    CGFloat baseHeight = ceil([data[ContentSizeKey] CGSizeValue].height + kSpec * 3 + [data[NickSizeKey] CGSizeValue].height);
    
    NSString *type = data[TypeKey];
    self.resources = data[ResourcesKey];
    if (self.resources.count > 0)
    {
        if ([type isEqualToString:ImgKey])
        {
            if (self.resources.count == 1)
            {
                NSDictionary *resouce = self.resources.lastObject;
                SDLayer *layer = [[SDLayer alloc] initWithType:type];
                layer.frame = CGRectMake(kTextXOffset, baseHeight, resWidth, resHeight);
                [layer setContentsWithUrl:resouce[ImageUrlKey]];
                [self.contentView.layer addSublayer:layer];
                [self.sources addObject:layer];
            }
        }
    }
}

- (void)_fillData:(CGContextRef)context
{
    [self.nickName drawInContext:context
                    withPosition:(CGPoint){kTextXOffset, kSpec}
                         andFont:kNicknameFont
                    andTextColor:UIColorFromRGB(0x556c95)
                       andHeight:self.nickNameSize.height
                        andWidth:self.nickNameSize.width
                   lineBreakMode:kCTLineBreakByTruncatingTail];
    
    [self.drawer setText:self.contentStr context:context contentSize:self.contentSize backgroundColor:[UIColor whiteColor] font:kContentTextFont textColor:[UIColor blackColor] block:nil xOffset:kTextXOffset yOffset:kSpec * 2 + self.nickNameSize.height];
    
}

- (void)_fillContents:(NSArray *)array
{
    UIGraphicsBeginImageContextWithOptions(self.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [UIColorFromRGB(0xffffff) set];
    CGContextFillRect(context, (CGRect){0, 0, self.size});
    
    // 获取需要高亮的链接CGRect，并填充背景色
    if (array) {
        for (NSString *string in array) {
            CGRect rect = CGRectFromString(string);
            [UIColorFromRGB(0xe5e5e5) set];
            CGContextFillRect(context, rect);
        }
    }
    [self _fillData:context];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.contentView.layer.contents = (__bridge id)(tmp.CGImage);
}

@end
