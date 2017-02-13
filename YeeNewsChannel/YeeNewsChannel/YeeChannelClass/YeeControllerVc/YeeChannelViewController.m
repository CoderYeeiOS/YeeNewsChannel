//
//  YeeChannelViewController.m
//  YeeNewsChannel
//
//  Created by CoderYee on 2017/2/9.
//  Copyright © 2017年 CoderYee. All rights reserved.
//

#import "YeeChannelViewController.h"
#import "SwipeTableView.h"  //用于记录
#import "YeeDetailsListView.h"
#import "LMArrow.h"
#import "YeeNavButton.h"
#import "LMListBar.h"
#import "YeeChannelModel.h"
#import "CustomTableView.h"

@interface YeeChannelViewController ()
<SwipeTableViewDataSource,SwipeTableViewDelegate>

@property (nonatomic, strong) SwipeTableView * swipeTableView;

@property (nonatomic,strong) LMListBar *listBar;

@property (nonatomic,strong) LMArrow *arrow;

@property (nonatomic,strong) YeeDetailsListView *yeedetailsList;


@property(nonatomic,strong)NSMutableArray *listTop;
@property(nonatomic,strong)NSMutableArray *listBottom;
@end

@implementation YeeChannelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addOwnViews];
    [self configureView];
    [self configureNav];
    [self addObserver];
}

-(void)configureNav
{
    self.title=@"首页";
}
-(void)addOwnViews
{
    [self addSwipeTableView];
}
-(void)addObserver
{
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCollectionView) name:@"TabChangedRefreshMainVC" object:nil];
    
}
-(void)configureView
{
    [self.view setBackgroundColor:xBackgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
}
-(void)addSwipeTableView
{
    __weak typeof(self) unself = self;
    //顶部导航栏
    if (!self.listBar) {
        self.listBar = [[LMListBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW-30, kListBarH)];
        self.listBar.scrollsToTop = NO;
        self.listBar.visibleItemList = self.listTop;
        self.listBar.arrowChange = ^()
        {
            if (unself.arrow.arrowBtnClick) {
                unself.arrow.arrowBtnClick();
            }
        };
        self.listBar.listBarItemClickBlock = ^(YeeChannelModel *model)
        {
            [unself.yeedetailsList itemRespondFromListBarClickWithItemnewModel:model];
            [unself swipeTableViewScrollIndexwithModel:model];
        };
    }
    
    // init swipetableview
    self.swipeTableView = [[SwipeTableView alloc]initWithFrame:self.view.bounds];
    //_swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeTableView.delegate   = self;
    _swipeTableView.dataSource = self;
    _swipeTableView.shouldAdjustContentSize = NO;
    _swipeTableView.swipeHeaderView = nil;
    _swipeTableView.swipeHeaderBar = self.listBar;
    _swipeTableView.swipeHeaderTopInset = 0;
    _swipeTableView.swipeHeaderBarScrollDisabled = YES;
    [self.view addSubview:_swipeTableView];
    if (!self.arrow) {
        self.arrow = [[LMArrow alloc] initWithFrame:CGRectMake(kScreenW-kArrowW, 0, kArrowW, kListBarH)];
        self.arrow.arrowBtnClick = ^(){
            [UIView animateWithDuration:kAnimationTime animations:^{
                CGAffineTransform rotation = unself.arrow.imageView.transform;
                unself.arrow.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
                unself.yeedetailsList.transform = (unself.yeedetailsList.frame.origin.y<0)?CGAffineTransformMakeTranslation(0, kScreenH):CGAffineTransformMakeTranslation(0, -kScreenH);
            }];
        };
        [self.view addSubview:self.arrow];
    }
    //频道列表
    if (!self.yeedetailsList)
    {
        self.yeedetailsList = [[YeeDetailsListView alloc] initWithFrame:CGRectMake(0, -kScreenH, kScreenW,  kScreenH)];
        self.yeedetailsList.listAll = [NSMutableArray arrayWithObjects:self.listTop,self.listBottom, nil];
        self.yeedetailsList.longPressedBlock = ^(){
            [unself.yeedetailsList sortBtnClick:unself.yeedetailsList.sortBtn];
        };
        self.yeedetailsList.closeBtnClick=^(){
            [UIView animateWithDuration:kAnimationTime animations:^{
                CGAffineTransform rotation = unself.arrow.imageView.transform;
                unself.arrow.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
                unself.yeedetailsList.transform = (unself.yeedetailsList.frame.origin.y<0)?CGAffineTransformMakeTranslation(0, kScreenH):CGAffineTransformMakeTranslation(0, -kScreenH);
            }];
        } ;
        self.yeedetailsList.opertionFromItemBlock = ^(animateType type,YeeChannelModel *channelModel)
        {
            [unself.listBar operationFromBlock:type channelModel:channelModel];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:self.yeedetailsList];
    }
}
-(void)swipeTableViewScrollIndexwithModel:(YeeChannelModel*)model
{
    for (NSInteger  indexM=0; indexM<self.listTop.count;indexM++)
    {
        YeeChannelModel *channelModel=self.listTop[indexM];
        if ([channelModel.channelId isEqualToString:model.channelId])
        {
            [self.swipeTableView scrollToItemAtIndex:indexM animated:YES];
            break;
        }
    }
}
#pragma mark - 刷新页面
-(void)refreshCollectionView
{
    
    
    self.listTop=[NSKeyedUnarchiver unarchiveObjectWithFile:NewsTopArrPath];
    self.listBottom=[NSKeyedUnarchiver unarchiveObjectWithFile:NewsBottomArrPath];
    [self.swipeTableView reloadData];
    //重新计算偏移量
    for (int i=0; i<self.listTop.count; i++)
    {
        YeeChannelModel *channelModel=self.listTop[i];
        if ([ channelModel.channelId isEqualToString:self.listBar.btnSelect.channeModel.channelId])
        {
            //再次点击当前被选中的。
            [self.listBar itemClickByScrollerWithIndex:i];
            [self.swipeTableView scrollToItemAtIndex:i animated:YES];
        }
    }

    
//    self.listTop=[NSKeyedUnarchiver unarchiveObjectWithFile:NewsTopArrPath];
//    self.listBottom=[NSKeyedUnarchiver unarchiveObjectWithFile:NewsBottomArrPath];
     [self.swipeTableView reloadData];
//    //重新计算偏移量
//    for (int i=0; i<self.listTop.count; i++)
//    {
//        HomePageChannelModel *channelModel=self.listTop[i];
//        if ([ channelModel.channelId isEqualToString:self.listBar.btnSelect.channeModel.channelId])
//        {
//            //再次点击当前被选中的。
//            [self.listBar itemClickByScrollerWithIndex:i];
//            [self.swipeTableView scrollToItemAtIndex:i animated:YES];
//        }
//    }
}
- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView
{
    return self.listTop.count;
}
- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view
{
    CustomTableView * tableView = (CustomTableView *)view;
    // 重用
    if (nil == tableView)
    {
        tableView = [[CustomTableView alloc]initWithFrame:swipeView.bounds style:UITableViewStylePlain];
    }
     [tableView  refreshIds:[NSString stringWithFormat:@"%@",view] Data:@(150) atIndex:10];
//    tableView.superViewVc=self;
//    HomePageChannelModel *model=self.listTop[index];
//    [tableView refreshIds:model.id];
    return tableView;
}
- (void)swipeTableViewDidScroll:(SwipeTableView *)swipeView
{
    
    
    
}
//开始拖拽的时候，当前tableView结束刷新
- (void)swipeTableViewWillBeginDragging:(SwipeTableView *)swipeView
{
    CustomTableView* tableView= (CustomTableView*) swipeView.currentItemView;
    [tableView.mj_header endRefreshing];
    [tableView.mj_footer endRefreshing];
}
- (void)swipeTableViewDidEndDragging:(SwipeTableView *)swipeView willDecelerate:(BOOL)decelerate
{
    
    
}
- (void)swipeTableViewWillBeginDecelerating:(SwipeTableView *)swipeView
{
    
}
- (void)swipeTableViewDidEndScrollingAnimation:(SwipeTableView *)swipeView
{
    
    
}
- (BOOL)swipeTableView:(SwipeTableView *)swipeView shouldSelectItemAtIndex:(NSInteger)index
{
    
    return YES;
}
- (void)swipeTableView:(SwipeTableView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    
    
}
// swipetableView index变化，改变seg的index
- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView
{
    [self.listBar  itemClickBySwipeTableViewWithIndex:swipeView.currentItemIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(NSMutableArray *)listTop
{
    if (!_listTop)
    {
        _listTop = [[NSMutableArray alloc] init];
        NSArray *temp = @[@"推荐",@"电影",@"数码",@"时尚",@"奇葩",@"游戏",@"旅游",@"育儿",@"减肥",@"养生",@"美食",@"政务",@"历史",@"探索",@"故事",@"美文",@"情感",@"语录",@"美图",@"房产",@"家居",@"搞笑",@"星座",@"文化",@"毕业生",@"视频"];
        for (NSInteger i=0; i<temp.count; i++)
        {
            YeeChannelModel *model=[[YeeChannelModel alloc] init];
            model.channleName=temp[i];
            model.channelId=[self generateTradeNO];
            [_listTop addObject:model];
        }
    }
    return _listTop;
}
-(NSMutableArray *)listBottom
{
    if (!_listBottom)
    {  _listBottom = [[NSMutableArray alloc] init];
        NSArray *temp = @[@"推荐",@"热点",@"杭州",@"社会",@"娱乐",@"科技",@"汽车",@"体育",@"订阅",@"财经",@"军事",@"国际",@"正能量",@"段子",@"趣图",@"美女",@"健康",@"教育",@"特卖",@"彩票",@"辟谣"];
        for (NSInteger i=0; i<temp.count; i++)
        {
            YeeChannelModel *model=[[YeeChannelModel alloc] init];
            model.channleName=temp[i];
            model.channelId=[self generateTradeNO];
            [_listBottom addObject:model];
        }
    }
    return _listBottom;
}
#pragma mark 产生随机字符串
- (NSString *)generateTradeNO
{
    static NSInteger kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (int i = 0; i < kNumber; i++)
    {   unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
