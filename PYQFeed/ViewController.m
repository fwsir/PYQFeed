//
//  ViewController.m
//  PYQFeed
//
//  Created by BOOM on 16/8/17.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import "ViewController.h"
#import "FpsLabel.h"
#import "NSString+Additions.h"
#import <Masonry.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FpsLabel *fpsLabel;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = [NSMutableArray array];
    self.fpsLabel = [[FpsLabel alloc] init];
    self.fpsLabel.alpha = 0;
    [self.view addSubview:self.fpsLabel];
    
    [self.fpsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(50);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSArray *array;
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
        array = dict[DataKey];
    }
    
    for (NSDictionary *item in array)
    {
        CGSize nickSize = [item[NickNameKey] sizeWithConstrainedToWidth:ScreenWidth / 2.0
                                                               fromFont:kNicknameFont
                                                              lineSpace:0
                                                          lineBreakMode:kCTLineBreakByTruncatingTail];
        
        CGSize contentSize = [item[ContentKey] sizeWithConstrainedToWidth:kContentTextWidth
                                                                 fromFont:kContentTextFont
                                                                lineSpace:5
                                                            lineBreakMode:kCTLineBreakByWordWrapping];
        
        NSMutableDictionary *mItem = [NSMutableDictionary dictionaryWithDictionary:item];
        mItem[NickSizeKey] = [NSValue valueWithCGSize:nickSize];
        mItem[ContentSizeKey] = [NSValue valueWithCGSize:contentSize];
        
        NSString *type = item[TypeKey];
        NSArray *resources = item[ResourcesKey];
        if (resources.count > 0)
        {
            if (resources.count == 1)
            {
                NSDictionary *res = resources.firstObject;
                if (res)
                {
                    CGFloat width = [res[WidthKey] floatValue];
                    CGFloat height = [res[HeightKey] floatValue];
                    if (width > height)
                    {
                        if (width > kMaxContentImageSide)
                        {
                            CGFloat scale = kMaxContentImageSide / width;
                            mItem[ResHeightKey] = @((scale * height) / 2.0);
                            mItem[ResWidthKey] = @(kMaxContentImageSide / 2.0);
                        }
                        else
                        {
                            mItem[ResWidthKey] = @(width / 2.0);
                            mItem[ResHeightKey] = @(height / 2.0);
                        }
                    }
                    else
                    {
                        if (height > kMaxContentImageSide)
                        {
                            CGFloat scale = kMaxContentImageSide / height;
                            mItem[ResHeightKey] = @(kMaxContentImageSide / 2.0);
                            mItem[ResWidthKey] = @(scale * width / 2.0);
                        }
                        else
                        {
                            mItem[ResHeightKey] = @(height / 2.0);
                            mItem[ResWidthKey] = @(width / 2.0);
                        }
                    }
                }
                else
                {
                    NSInteger row = (resources.count - 1) / 3 + 1;
                    mItem[ResHeightKey] = @(row * kContentImageWidth + (row - 1) * kImageGap);
                    mItem[ResWidthKey] = @(kContentImageWidth);
                }
            }
        }
        [self.datas addObject:mItem];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.fpsLabel.alpha == 0) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.fpsLabel.alpha = 1;
        } completion:nil];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.fpsLabel.alpha != 0) {
        [UIView animateWithDuration:.30 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.fpsLabel.alpha = 0;
        } completion:nil];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if (self.fpsLabel.alpha == 0) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.fpsLabel.alpha = 1;
        } completion:nil];
    }
}

@end
