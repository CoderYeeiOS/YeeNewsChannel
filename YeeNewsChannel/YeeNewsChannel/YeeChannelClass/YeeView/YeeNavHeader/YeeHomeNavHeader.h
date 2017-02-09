//
//  YeeHomeNavHeader.h
//  SmallLook
//
//  Created by CoderYee on 2017/2/8.
//  Copyright © 2017年 余伟. All rights reserved.
//

#ifndef YeeHomeNavHeader_h
#define YeeHomeNavHeader_h


#define kStatusHeight 20
#define kNavHeight 64
#define kListBarH 30
#define kArrowW 40
#define kAnimationTime 0.8
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define padding 20
#define itemPerLine 4
#define kItemW (kScreenW-padding*(itemPerLine+1))/itemPerLine
#define kItemH 25
typedef enum{
    topViewClick = 0,
    FromTopToTop = 1,
    FromTopToTopLast = 2,
    FromTopToBottomHead = 3,
    FromBottomToTopLast = 4
} animateType;



#endif /* YeeHomeNavHeader_h */
