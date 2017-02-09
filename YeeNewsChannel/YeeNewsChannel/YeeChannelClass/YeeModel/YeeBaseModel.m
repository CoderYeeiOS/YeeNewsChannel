//
//  YeeBaseModel.m
//  YeeNewsChannel
//
//  Created by CoderYee on 2017/2/9.
//  Copyright © 2017年 CoderYee. All rights reserved.
//

#import "YeeBaseModel.h"

@implementation YeeBaseModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    NSDictionary *dict = @{@"ID":@"id",@"descriptions":@"description"};
    return dict;
}
//把null的字段转换为空字符串
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    //把null属性处理成空字符串
    if ([oldValue isKindOfClass:[NSNull class]])
    {
        if (property.type.isNumberType){
            return 0;
        }else if (property.type.isBoolType)
        {
            return 0;
        }
        else if (property.type.typeClass)
        {
            return nil;
        }else if ([property.type.code isEqualToString:@"NSArray"]){
            return @[];
        }else if([oldValue isKindOfClass:[NSDictionary class]])
        {
            return @{};
        }
        else{
            return @"";//nil
        }
    }
    //把没有的字段处理成空字符串
    if (!oldValue)
    {
        if (property.type.isNumberType)
        {
            return 0;
        }else if (property.type.isBoolType)
        {
            return 0;
        }else if ([property.type.code isEqualToString:@"NSArray"]){
            return @[];
        }else
        {
            return @"";
        }
    }
    return oldValue;
}

@end
