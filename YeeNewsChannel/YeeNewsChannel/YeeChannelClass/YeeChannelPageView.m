//
//  YeeChannelPageView.m
//  YeeNewsChannel
//
//  Created by 余伟 on 2017/1/8.
//  Copyright © 2017年 YeeNewsChannel. All rights reserved.
//

#import "YeeChannelPageView.h"
#import "YeeChannelCollectionViewCell.h"
@interface YeeChannelPageView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView             *_collectionView;
    UICollectionViewFlowLayout   *_collectionFlowLayout;
}
@end
@implementation YeeChannelPageView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        _collectionView=[[UICollectionView alloc] initWithFrame:self.bounds];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView registerClass:[YeeChannelCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YeeChannelCollectionViewCell class])];
        [self addSubview:_collectionView];
    }
    
    return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YeeChannelCollectionViewCell  *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YeeChannelCollectionViewCell class]) forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor redColor]];
    return  cell;
    
}
@end
