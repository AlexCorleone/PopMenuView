//
//  WQKPopItemsMenuView.h
//  CoreAnimation
//
//  Created by AlexCorleone on 2017/9/21.
//  Copyright © 2017年 魏乾坤. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WQKPopItemsMenuViewDefaultDisappear,
    WQKPopItemsMenuViewFallingDisappear,
    WQKPopItemsMenuViewSmallerDisappear
} WQKPopItemsMenuViewDisappear;

@interface WQKPopItemsMenuView : UIView

/*
 *YES,展示动画 NO，隐藏动画
 */
@property (nonatomic, assign) BOOL isShowBtnList;
/*
 *只有title
 */
@property (nonatomic, strong) NSArray <NSString *>*titleArray;
/*
 *标题图片组合初始化
 * @{@"title" : @"imageName"}
 */
@property (nonatomic, strong) NSArray <NSDictionary *>*titleImageArray;
/*
 *item点击回调
 */
@property (nonatomic, copy) void(^itemClickBlock)(id targetItem, NSUInteger index);

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray <NSString *>*)titleArray;

+ (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray <NSString *>*)titleArray;

@end
