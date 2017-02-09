//
//  LMArrow.m
//  StudyFMDB
//
//  Created by limin on 16/11/30.
//  Copyright © 2016年 君安信（北京）科技有限公司. All rights reserved.
//

#import "LMArrow.h"
#import "YeeHomeNavHeader.h"

@implementation LMArrow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"Dark_Menu_Follow"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"Dark_Menu_Follow"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(ArrowClick) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = RGBColor(238.0, 238.0, 238.0);

    }
    return self;
}

-(void)ArrowClick{
    if (self.arrowBtnClick) {
        self.arrowBtnClick();
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageSize = 18;
    return CGRectMake((contentRect.size.width-imageSize)/2, (30-imageSize)/2, imageSize, imageSize);
}


@end
