//
//  LMListBar.h
//  StudyFMDB
//
//  Created by limin on 16/11/30.
//  Copyright © 2016年 君安信（北京）科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YeeHomeNavHeader.h"
#import "YeeChannelModel.h"
#import "YeeNavButton.h"
@interface LMListBar : UIScrollView
//被选中的按钮
@property (nonatomic, strong) YeeNavButton *btnSelect;
@property (nonatomic,copy) void(^arrowChange)();
@property (nonatomic,copy) void(^listBarItemClickBlock)(YeeChannelModel *channelModel);

@property (nonatomic,strong) NSMutableArray *visibleItemList;

//
-(void)operationFromBlock:(animateType)type channelModel:(YeeChannelModel *)channelModel;

//点击那个item
-(void)itemClickByScrollerWithIndex:(NSInteger)index;
//swipe滚动的时候需要调整
-(void)itemClickBySwipeTableViewWithIndex:(NSInteger)index;

@end
