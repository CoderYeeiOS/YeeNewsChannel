//
//  ViewController.m
//  YeeNewsChannel
//
//  Created by 余伟 on 2017/1/7.
//  Copyright © 2017年 YeeNewsChannel. All rights reserved.
//

#import "ViewController.h"
#import "YeeChannelCollectionViewCell.h"
#import "WJItemsControlView.h"
@interface ViewController ()<UIScrollViewDelegate>
{
    WJItemsControlView   *_topScrollView;
    
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float widht = [UIScreen mainScreen].bounds.size.width;
    float heith = [UIScreen mainScreen].bounds.size.height;
    
    NSArray *array = @[@"新闻",@"房产",@"体育",@"美女美女美女美女美女美女美女美女",@"文化",@"历史",@"故事",@"汽车"];
    
    
    //4页内容的scrollView
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, widht, heith-100)];
    scroll.delegate = self;
    scroll.pagingEnabled = YES;
    scroll.contentSize = CGSizeMake(widht*array.count, 100);
    
    for (int i=0; i<array.count; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(widht*i, 0, widht, heith-100)];
        label.text = array[i];
        label.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [scroll addSubview:label];
    }
    [self.view addSubview:scroll];
    
    
    
    
    //头部控制的segMent
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    config.itemWidth = widht/4.0;
    
    _topScrollView = [[WJItemsControlView alloc]initWithFrame:CGRectMake(0, 64, widht, 44)];
    _topScrollView.tapAnimation = YES;
    _topScrollView.config = config;
    _topScrollView.titleArray = array;
    
    __weak typeof (scroll)weakScrollView = scroll;
    [_topScrollView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        
        [weakScrollView scrollRectToVisible:CGRectMake(index*weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width,weakScrollView.frame.size.height) animated:animation];
        
    }];
    [self.view addSubview:_topScrollView];

    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset/CGRectGetWidth(scrollView.frame);
    [_topScrollView moveToIndex:offset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset/CGRectGetWidth(scrollView.frame);
    [_topScrollView endMoveToIndex:offset];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
