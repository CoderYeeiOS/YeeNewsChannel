//
//  CustomTableView.h
//  SwipeTableView
//
//  Created by Roy lee on 16/4/1.
//  Copyright © 2016年 Roy lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableView : UITableView
- (void)refreshWithData:(id)numberOfRows atIndex:(NSInteger)index;

- (void)refreshIds:(NSString *)ids Data:(id)numberOfRows  atIndex:(NSInteger)index;

@end
