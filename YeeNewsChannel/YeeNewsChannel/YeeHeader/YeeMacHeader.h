//
//  YeeMacHeader.h
//  YeeNewsChannel
//
//  Created by CoderYee on 2017/2/9.
//  Copyright © 2017年 CoderYee. All rights reserved.
//

#ifndef YeeMacHeader_h
#define YeeMacHeader_h

//主窗口的宽、高
#define kMainScreenWidth  MainScreenWidth()
#define kMainScreenHeight MainScreenHeight()

#define Localized(Str) NSLocalizedString(Str, Str)

static __inline__ CGFloat MainScreenWidth()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
}

static __inline__ CGFloat MainScreenHeight()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
}
#define paths             [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#define NewsTopArrPath    [paths stringByAppendingString:@"/leaderTop.plist"]
#define NewsBottomArrPath [paths stringByAppendingString:@"/leaderTopBottom.plist"]

#endif /* YeeMacHeader_h */
