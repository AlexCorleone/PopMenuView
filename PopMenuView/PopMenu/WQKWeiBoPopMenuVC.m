//
//  WQKWeiBoPopMenuVC.m
//  CoreAnimation
//
//  Created by AlexCorleone on 2017/9/21.
//  Copyright © 2017年 魏乾坤. All rights reserved.
//

#import "WQKWeiBoPopMenuVC.h"
#import "WQKPopItemsMenuView.h"

@interface WQKWeiBoPopMenuVC ()

@property (nonatomic, strong) WQKPopItemsMenuView *popMenuView;

@end

@implementation WQKWeiBoPopMenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configSubViews];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
}

- (WQKPopItemsMenuView *)popMenuView
{
    if (!_popMenuView)
    {
        self.popMenuView = [WQKPopItemsMenuView initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100)
                                                   titleArray:@[@"title1", @"title2", @"title3", @"title4",@"title5", @"title6", @"title7", @"title8"]];
        __weak typeof(self)weakSelf = self;
        [_popMenuView setItemClickBlock:^(id target, NSUInteger index){
            __strong typeof (weakSelf)strongSelf = weakSelf;
            NSLog(@"-- %@ -- %ld -- ", target, index);
            [((UIButton *)[strongSelf.view viewWithTag:100001]) setSelected:NO];
        }];
    }
    return _popMenuView;
}
#pragma mark - Private
- (void)configSubViews
{
    [self configBottomBtn];
    [self.view addSubview:self.popMenuView];
}

- (UIButton *)configBottomBtn
{
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [bottomBtn setTitle:@"开始动画" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
    [bottomBtn setTitle:@"结束动画" forState:UIControlStateSelected];
    [bottomBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [bottomBtn setBackgroundColor:[UIColor clearColor]];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setTag:100001];
    [self.view addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.height.equalTo(@(40));
    }];
    return bottomBtn;
}

- (void)bottomBtnClick:(UIButton *)btn
{
    [self.popMenuView setIsShowBtnList:btn.selected];
    btn.selected = !btn.selected;
}

#pragma mark - WQKPopItemsMenuViewDelegate
- (UIView *)wqkCustomViewForShowItem
{
    UIView *showItemView = [UIView new];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestueClick:)];
    [showItemView addGestureRecognizer:tapGes];
    return showItemView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
