//
//  ViewController.m
//  PYQFeed
//
//  Created by BOOM on 16/8/17.
//  Copyright © 2016年 DEVIL. All rights reserved.
//

#import "ViewController.h"
#import "FpsLabel.h"
#import <Masonry.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FpsLabel *fpsLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        array = dict[@"data"];
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
