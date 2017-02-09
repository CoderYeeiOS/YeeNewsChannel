//
//  YeeDetailsListView.m
//  StudyFMDB
//
//  Created by CoderYee on 2017/2/7.
//  Copyright © 2017年 君安信（北京）科技有限公司. All rights reserved.
//

#import "YeeDetailsListView.h"
#import "LMListItem.h"


@interface YeeDetailsListView()

@property (nonatomic,strong) UIView *sectionHeaderView;

@property (nonatomic,strong) NSMutableArray *allItems;

@property (nonatomic,strong) LMListItem *itemSelect;

@end
@implementation YeeDetailsListView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor = RGBColor(238.0, 238.0, 238.0);
        [self addDetailHeaderView];
        [self addScrollView];
        [self addtitleView];

    }
    return self;
}
//添加头部视图
-(void)addDetailHeaderView
{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    [headerView setBackgroundColor:[UIColor colorWithRed:214/255.0 green:9/255.0 blue:21/255.0 alpha:1.0]];
    _closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setFrame:CGRectMake(kScreenW-40, 15, 30, 30)];
    [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _closeButton .titleLabel.font=[UIFont systemFontOfSize:13];
    [headerView addSubview:_closeButton];
    [self addSubview:headerView];
}

//添加滚动视图
-(void)addScrollView
{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,60, self.frame.size.width, self.frame.size.height-60)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentInset = UIEdgeInsetsMake(30, 0, 20, 0);
    [self addSubview:_scrollView];
}
-(void)addtitleView
{
    UIView *describeView=[[UIView alloc] initWithFrame:CGRectMake(0, -30, kScreenW, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.text = @"我的频道";
    [describeView addSubview:label];
    
    if (!self.hitText) {
        self.hitText = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10,10, 100, 11)];
        self.hitText.font = [UIFont systemFontOfSize:11];
        self.hitText.text = @"拖拽可以排序";
        self.hitText.textColor = RGBColor(170.0, 170.0, 170.0);
        self.hitText.hidden = YES;
        [describeView addSubview:self.hitText];
    }
    if (!self.sortBtn)
    {
        self.sortBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW-50-padding, 5, 50, 20)];
        [self.sortBtn setTitle:@"排序" forState:UIControlStateNormal];
        [self.sortBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.sortBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.sortBtn.layer.cornerRadius = 5;
        self.sortBtn.layer.borderWidth = 0.5;
        [self.sortBtn.layer setMasksToBounds:YES];
        self.sortBtn.layer.borderColor = [[UIColor redColor] CGColor];
        [self.sortBtn addTarget:self
                         action:@selector(sortBtnClick:)
               forControlEvents:1<<6];
        [describeView addSubview:self.sortBtn];
    }
    [self.scrollView addSubview:describeView];
    
}
-(void)sortBtnClick:(UIButton *)sender
{
    if (sender.selected)
    {   [sender setTitle:@"排序" forState:UIControlStateNormal];
        self.hitText.hidden = YES;
    }
    else
    {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        self.hitText.hidden = NO;
    }
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sortBtnClick"
                                                        object:sender
                                                      userInfo:nil];
}

-(void)setListAll:(NSMutableArray *)listAll
{
    _listAll = listAll;
    NSArray *listTop = listAll[0];
    NSArray *listBottom = listAll[1];
#pragma 更多频道标签
    self.sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,padding+(padding + kItemH)*((listTop.count -1)/itemPerLine+1),kScreenW, 30)];
    self.sectionHeaderView.backgroundColor = RGBColor(238.0, 238.0, 238.0);
    UILabel *moreText = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    moreText.text = @"推荐频道";
    moreText.font = [UIFont systemFontOfSize:14];
    [self.sectionHeaderView addSubview:moreText];
    [_scrollView addSubview:self.sectionHeaderView];
    __weak typeof(self) unself = self;
    NSInteger count1 = listTop.count;
    for (int i =0; i <count1; i++)
    {
        LMListItem *item = [[LMListItem alloc] initWithFrame:CGRectMake(padding+(padding+kItemW)*(i% itemPerLine), padding+(kItemH + padding)*(i/itemPerLine), kItemW, kItemH)];
        
        YeeChannelModel *channelModel=listTop[i];
        item.itemName = channelModel.channleName;
        item.channeModel=channelModel;
        item.location = top;
        [self.topView addObject:item];
        item->locateView = self.topView;
        item->topView = self.topView;
        item->bottomView = self.bottomView;
        item.hitTextLabel = self.sectionHeaderView;
        item.longPressBlock = ^(){
            if (unself.longPressedBlock) {
                unself.longPressedBlock();
            }
        };
        item.operationBlock = ^(animateType type,YeeChannelModel *itemModel){
            if (self.opertionFromItemBlock) {
                self.opertionFromItemBlock(type,channelModel);
            }
        };
        [_scrollView addSubview:item];
        [self.allItems addObject:item];
        
        if (!self.itemSelect)
        {
            [item setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            self.itemSelect = item;
        }
    }
    
    NSInteger count2 = listBottom.count;
    for (int i=0; i<count2; i++)
    {
        LMListItem *item = [[LMListItem alloc] initWithFrame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine),CGRectGetMaxY(self.sectionHeaderView.frame)+padding+(kItemH+padding)*(i/itemPerLine), kItemW, kItemH)];
        YeeChannelModel *channelModel=listBottom[i];
        item.operationBlock = ^(animateType type, YeeChannelModel *itemModel)
        {
            if (self.opertionFromItemBlock)
            {
                self.opertionFromItemBlock(type,itemModel);
            }
        };
        item.channeModel=channelModel;
        item.itemName = channelModel.channleName;
        item.location = bottom;
        item.hitTextLabel = self.sectionHeaderView;
        [self.bottomView addObject:item];
        item->locateView = self.bottomView;
        item->topView = self.topView;
        item->bottomView = self.bottomView;
        [_scrollView addSubview:item];
        [self.allItems addObject:item];
    }
    _scrollView.contentSize = CGSizeMake(kScreenW, CGRectGetMaxY(self.sectionHeaderView.frame)+padding+(kItemH+padding)*((count2-1)/4+1) + 80);
}

-(void)itemRespondFromListBarClickWithItemnewModel:(YeeChannelModel *)newsModel
{
    for (int i = 0 ; i<self.allItems.count; i++)
    {
        LMListItem *item = (LMListItem *)self.allItems[i];
        if ([newsModel.channelId isEqualToString:item.channeModel.channelId])//根据channelId判断点击的事件
        {
            [self.itemSelect setTitleColor:RGBColor(111.0, 111.0, 111.0) forState:0];
            [item setTitleColor:[UIColor redColor] forState:0];
            self.itemSelect = item;
        }
    }
}
-(void)clickCloseButton:(UIButton *)sender
{
    if (self.closeBtnClick)
    {
        self.closeBtnClick();
    }
}
-(NSMutableArray *)allItems
{
    if (_allItems == nil)
    {
        _allItems = [NSMutableArray array];
    }
    return _allItems;
}

-(NSMutableArray *)topView
{
    if (_topView == nil)
    {
        _topView = [NSMutableArray array];
    }
    return _topView;
}

-(NSMutableArray *)bottomView
{
    if (_bottomView == nil)
    {
        _bottomView = [NSMutableArray array];
    }
    return _bottomView;
}

@end







