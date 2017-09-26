//
//  WQKPopItemsMenuView.m
//  CoreAnimation
//
//  Created by AlexCorleone on 2017/9/21.
//  Copyright © 2017年 魏乾坤. All rights reserved.
//

#import "WQKPopItemsMenuView.h"

#define tagBaseFlage 10000
@interface WQKPopItemsMenuView ()

@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NSMutableArray <UIView *> *btnArray;

@end

@implementation WQKPopItemsMenuView

#pragma mark - Public Method
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray <NSString *>*)titleArray
{
    self = [self initWithFrame:frame];
    [self setTitleArray:titleArray];
    return self;
}

+ (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray <NSString *>*)titleArray
{
    return [[self alloc] initWithFrame:frame titleArray:titleArray];
}

#pragma mark - setter & getter
- (void)setTitleArray:(NSArray<NSString *> *)titleArray
{
    _titleArray = titleArray;
    [self createBtnArray];
}

- (void)setIsShowBtnList:(BOOL)isShowBtnList
{
    _isShowBtnList = isShowBtnList;
    [self isShowBtnAray:_isShowBtnList];
}

#pragma mark - Private Method
- (NSArray *)createBtnArray
{
    NSUInteger cout = 4;
    NSArray <NSString *>*titleArray = self.titleArray;
    NSArray <UIColor *> *bgColorArray = @[[UIColor purpleColor], [UIColor brownColor],
                                          [UIColor lightGrayColor], [UIColor orangeColor],
                                          [UIColor orangeColor], [UIColor yellowColor],
                                          [UIColor brownColor], [UIColor purpleColor]
                                          ];
    
    self.btnArray = [[NSMutableArray alloc] initWithCapacity:titleArray.count];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat space = 30;
    CGFloat bottomSapce = 150;
    NSUInteger totleNumber = titleArray.count / cout;
    CGFloat btnWith = (screenWidth - (cout + 1) * space) / 4.;
    for (NSInteger i = 0; i < titleArray.count; i++)
    {
        NSUInteger levelNumber = i % cout;
        NSUInteger verticalNumber = i / cout;
        CGFloat X = (space + btnWith) * levelNumber + space;
        CGFloat Y = (screenHeight - bottomSapce) - ((totleNumber - (verticalNumber + 1)) * space + btnWith * (totleNumber - verticalNumber));
            UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tempBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [tempBtn setTitle:titleArray[i] forState:UIControlStateNormal];
            [tempBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [tempBtn setFrame:CGRectMake(X, Y, btnWith, btnWith)];
            [tempBtn setBackgroundColor:bgColorArray[i]];
            [tempBtn.layer setCornerRadius:btnWith / 2.];
            [tempBtn setClipsToBounds:YES];
            [tempBtn setHidden:YES];
            [tempBtn setTag:tagBaseFlage + i];
            [tempBtn addTarget:self
                        action:@selector(itemBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:tempBtn];
            [_btnArray addObject:tempBtn];
    }
    return _btnArray;
}

- (void)itemBtnClick:(UIButton *)btn
{
    if (self.itemClickBlock)
    {
        self.selectBtn = btn;
        [self isShowBtnAray:YES];
        self.itemClickBlock(btn, btn.tag - tagBaseFlage);
    }
}

- (void)isShowBtnAray:(BOOL)flag
{
    for (UIButton *btn in self.btnArray)
    {
        NSString *animationKey = [NSString stringWithFormat:@"Alex.Group %ld", btn.tag];
        [btn.layer removeAnimationForKey:animationKey];
        if (!flag)
        {
            CGFloat animationTime = 0.6;
            CAKeyframeAnimation *springAnimation = (CAKeyframeAnimation *)[self springIntoAnimationViewWith:CGPointMake(btn.center.x, btn.center.y + 100) endPoint:btn.center duration:animationTime];
            springAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.82 :1.13 :0.7 :1.15];
            CABasicAnimation *alphaAnimation = (CABasicAnimation *)[self alphaAnimationViewWith:0.0 toOpacity:1. duration:animationTime - 0.4];
            CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
            [groupAnimation setAnimations:@[springAnimation, alphaAnimation]];
            [groupAnimation setDuration:animationTime];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((btn.tag - tagBaseFlage) * 0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [btn setHidden:flag];
                [btn.layer addAnimation:groupAnimation forKey:animationKey];
            });
        }else
        {
            if (!self.selectBtn)
            {
                CGFloat animationTime = 0.15;
                CAKeyframeAnimation *fallingAanimation = (CAKeyframeAnimation *)[self springIntoAnimationViewWith:btn.center endPoint:CGPointMake(btn.center.x, btn.center.y + 100) duration:animationTime];
                fallingAanimation.calculationMode = kCAAnimationPaced;
                CABasicAnimation *alphaAnimation = (CABasicAnimation *)[self alphaAnimationViewWith:1. toOpacity:0. duration:animationTime];
                CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
                [groupAnimation setAnimations:@[fallingAanimation, alphaAnimation]];
                [groupAnimation setDuration:animationTime];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((_btnArray.count + tagBaseFlage - btn.tag) * 0.08) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [btn.layer addAnimation:groupAnimation forKey:animationKey];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [btn setHidden:flag];
                    });
                });
            }else
            {
                CGFloat scale = 0.;
                CGFloat animationTime = 0.3;
                if ([self.selectBtn isEqual:btn])
                {
                    scale = 3.0;
                }
                CASpringAnimation *scaleAanimation = (CASpringAnimation *)[self springAnimationViewWith:scale duration:animationTime];
                CABasicAnimation *alphaAnimation = (CABasicAnimation *)[self alphaAnimationViewWith:1. toOpacity:0. duration:animationTime];
                CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
                [groupAnimation setAnimations:@[scaleAanimation, alphaAnimation]];
                [groupAnimation setDuration:animationTime];
                [btn.layer addAnimation:groupAnimation forKey:animationKey];
                __weak typeof(self)weakSelf = self;
                //dispatch_after延时操作的时间不是很准确所以这里我将时间提前了几秒让动画隐藏
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    if ([strongSelf.selectBtn isEqual:btn])
                    {
                        [strongSelf setSelectBtn:nil];
                    }
                    [btn setHidden:flag];
                });
            }
        }
    }
}

#pragma mark - Animations
- (CAKeyframeAnimation *)springIntoAnimationViewWith:(CGPoint)startPoint
                                            endPoint:(CGPoint)endPoint
                                            duration:(NSTimeInterval)duration
{
    CGFloat X = startPoint.x;
    CGFloat startY = startPoint.y;
    CGFloat endY = endPoint.y;
    CGFloat space = (endY - startY) / 10.;
    CGFloat backPointY = endY - space;
    CGFloat advancePointY = endY + space;
    NSArray *valueArray = @[[NSValue valueWithCGPoint:CGPointMake(X, startY)],
                   [NSValue valueWithCGPoint:CGPointMake(X, endY)],
                   [NSValue valueWithCGPoint:CGPointMake(X, advancePointY)],
                   [NSValue valueWithCGPoint:CGPointMake(X, endY)],
                   [NSValue valueWithCGPoint:CGPointMake(X, backPointY)],
                   [NSValue valueWithCGPoint:CGPointMake(X, endY)],
                   ];
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.values = valueArray;
    keyFrameAnimation.duration = duration;
    return keyFrameAnimation;
}

- (CAAnimation *)springAnimationViewWith:(CGFloat)scale duration:(CGFloat)duration;
{
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"transform"];
    springAnimation.mass = 13.;
    springAnimation.damping = 2;
    springAnimation.stiffness = 500;
    springAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1.0)];
    springAnimation.duration = duration;
    return springAnimation;
}

- (CABasicAnimation *)alphaAnimationViewWith:(CGFloat)fromOpacity toOpacity:(CGFloat)toOpacity duration:(CGFloat)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(fromOpacity);
    animation.toValue = @(toOpacity);
    animation.duration = duration;
    return animation;
}

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

@end
