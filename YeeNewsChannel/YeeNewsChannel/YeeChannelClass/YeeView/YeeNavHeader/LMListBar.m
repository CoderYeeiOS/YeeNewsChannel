//
//  LMListBar.m
//  StudyFMDB
//
//  Created by limin on 16/11/30.
//  Copyright © 2016年 君安信（北京）科技有限公司. All rights reserved.
//

#import "LMListBar.h"
#define kDistanceBetweenItem 32
#define kExtraPadding 20
#define itemFont 13
@interface LMListBar()

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, strong) UIView *btnBackView;
@property (nonatomic, strong) NSMutableArray *btnLists; //导航条上的button集合

@end
@implementation LMListBar
-(NSMutableArray *)btnLists
{
    if (_btnLists == nil)
    {
        _btnLists = [NSMutableArray array];
    }
    return _btnLists;
}

-(void)setVisibleItemList:(NSMutableArray *)visibleItemList
{
    _visibleItemList = visibleItemList;
    self.maxWidth = 20;
    self.backgroundColor = RGBColor(238.0, 238.0, 238.0);
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 50);
    self.showsHorizontalScrollIndicator = NO;
    for (int i =0; i<visibleItemList.count; i++)
    {
        [self makeItemWithTitle:visibleItemList[i]];
    }
    self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
}

//根据channelmodel上的字 设置frame
-(void)makeItemWithTitle:(YeeChannelModel *)channel
{
    CGFloat itemW = [self calculateSizeWithFont:itemFont Text:channel.channleName].size.width;
    YeeNavButton *item = [[YeeNavButton alloc] initWithFrame:CGRectMake(self.maxWidth, 0, itemW, self.frame.size.height)];
    item.channeModel=channel;
    item.titleLabel.font = [UIFont systemFontOfSize:itemFont];
    [item setTitle:channel.channleName forState:UIControlStateNormal];
    [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [item setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [item setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    self.maxWidth += itemW+kDistanceBetweenItem;
    [self.btnLists addObject:item];
    [self addSubview:item];
    if (!self.btnSelect)//默认选中第一个
    {
        [item setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.btnSelect = item;
    }
    self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
}


-(void)itemClick:(YeeNavButton *)sender
{
    if (self.btnSelect != sender)
    {
        [self.btnSelect setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.btnSelect = sender;
        if (self.listBarItemClickBlock)//判断点击的是哪个按钮
        {
            self.listBarItemClickBlock(sender.channeModel);
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint changePoint;
        if (sender.frame.origin.x >= kScreenW - 150 && sender.frame.origin.x < self.contentSize.width-200) {changePoint = CGPointMake(sender.frame.origin.x - 200, 0);}
        else if (sender.frame.origin.x >= self.contentSize.width-200){changePoint = CGPointMake(self.contentSize.width-350, 0);}
        else{changePoint = CGPointMake(0, 0);}
        self.contentOffset = changePoint;
    }];
}

-(void)itemClickByScrollerWithIndex:(NSInteger)index
{
    YeeNavButton *item = (YeeNavButton *)self.btnLists[index];
    [self itemClick:item];
}
-(void)itemClickBySwipeTableViewWithIndex:(NSInteger)index
{
    YeeNavButton *sender = (YeeNavButton *)self.btnLists[index];
    if (self.btnSelect != sender)
    {
        [self.btnSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.btnSelect = sender;
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint changePoint;
        if (sender.frame.origin.x >= kScreenW - 150 && sender.frame.origin.x < self.contentSize.width-200) {changePoint = CGPointMake(sender.frame.origin.x - 200, 0);}
        else if (sender.frame.origin.x >= self.contentSize.width-200){changePoint = CGPointMake(self.contentSize.width-350, 0);}
        else{changePoint = CGPointMake(0, 0);}
        self.contentOffset = changePoint;
        
    }];
}
-(void)operationFromBlock:(animateType)type channelModel:(YeeChannelModel *)channelModel

{
    switch (type)
    {
        case topViewClick:
            [self itemClick:self.btnLists[[self findIndexOfListsWithchannelModel:channelModel]]];
            if (self.arrowChange) {
                self.arrowChange();
            }
            break;
        case FromTopToTop:
            [self  switchPositionWithItemchannelModel:channelModel];
            break;
        case FromTopToTopLast:
            [self switchPositionWithItemchannelModel:channelModel];
            break;
        case FromTopToBottomHead:
            if ([self.btnSelect.channeModel.channelId isEqualToString:channelModel.channelId])
            {
                [self itemClick:self.btnLists[0]];
            }
            [self removeItemWithchannelModel:channelModel];
            [self resetFrame];
            break;
        case FromBottomToTopLast:
            [self.visibleItemList addObject:channelModel];
            [self makeItemWithTitle:channelModel];
            break;
        default:
            break;
    }
}

-(void)switchPositionWithItemchannelModel:(YeeChannelModel*)channelModel
{
    YeeNavButton *button = self.btnLists[[self findIndexOfListsWithchannelModel:channelModel]];
    [self.visibleItemList removeObject:channelModel];
    [self.btnLists removeObject:button];
    for (NSInteger indexM=0; indexM<self.visibleItemList.count; indexM++)
    {   YeeChannelModel *model=self.visibleItemList[indexM];
        if ([model.channelId isEqualToString:channelModel.channelId])
        {
            [self.visibleItemList insertObject:channelModel atIndex:indexM];
            [self.btnLists insertObject:button atIndex:indexM];
            break;
        }
    }
    [self itemClick:self.btnSelect];
    [self resetFrame];
}

-(void)removeItemWithchannelModel:(YeeChannelModel *)channelModel
{
    NSInteger index = [self findIndexOfListsWithchannelModel:channelModel];
    YeeNavButton *select_button = self.btnLists[index];
    [self.btnLists[index] removeFromSuperview];
    [self.btnLists removeObject:select_button];
    [self.visibleItemList removeObject:channelModel];
}

-(NSInteger)findIndexOfListsWithchannelModel:(YeeChannelModel *)channelModel
{
    for (int i =0; i < self.visibleItemList.count; i++)
    {
        YeeChannelModel *btnChannelModel=self.visibleItemList[i];
        if ([channelModel.channelId isEqualToString:btnChannelModel.channelId])
        {
            return i;
        }
    }
    return 0;
}

-(void)resetFrame
{
    self.maxWidth = 20;
    for (int i = 0; i < self.visibleItemList.count; i++)
    {
        YeeChannelModel *channelModel=self.visibleItemList[i];
        [UIView animateWithDuration:0.0001 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            CGFloat itemW = [self calculateSizeWithFont:itemFont Text:channelModel.channleName].size.width;
            [[self.btnLists objectAtIndex:i] setFrame:CGRectMake(self.maxWidth, 0, itemW, self.frame.size.height)];
            self.maxWidth += kDistanceBetweenItem + itemW;
        } completion:^(BOOL finished){
        }];
    }
    self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
}

-(CGRect)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text
{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect size = [Text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return size;
}


@end
