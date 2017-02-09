//
//  YeeDetailsListView.h
//  StudyFMDB
//
//  Created by CoderYee on 2017/2/7.
//  Copyright © 2017年 君安信（北京）科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YeeHomeNavHeader.h"
#import "YeeChannelModel.h"

@interface YeeDetailsListView : UIView

@property (nonatomic,strong) NSMutableArray *topView;
@property (nonatomic,strong) NSMutableArray *bottomView;
@property (nonatomic,strong) NSMutableArray *listAll;
@property(nonatomic,retain)  UIButton       *closeButton;
@property(nonatomic,retain)  UIScrollView   *scrollView;

@property (nonatomic,strong) UILabel        *hitText;
@property (nonatomic,strong) UIButton       *sortBtn;

-(void)sortBtnClick:(UIButton *)sender;

@property (nonatomic,copy) void(^closeBtnClick)();

@property (nonatomic,copy) void(^longPressedBlock)();
@property (nonatomic,copy) void(^opertionFromItemBlock)(animateType type,YeeChannelModel *channelModel);
-(void)itemRespondFromListBarClickWithItemnewModel:(YeeChannelModel *)newsModel ;

@end
