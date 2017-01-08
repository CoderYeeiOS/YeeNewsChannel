//
//  YeeChannelPageView.h
//  YeeNewsChannel
//
//  Created by 余伟 on 2017/1/8.
//  Copyright © 2017年 YeeNewsChannel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YeeChannelPageView : UIView

@property(nonatomic,retain)NSMutableArray   *childArray;

@property(nonatomic,retain)NSMutableArray   *titleArray;

-(instancetype)initWithFrame:(CGRect)frame;

-(void)moveTo
@end
