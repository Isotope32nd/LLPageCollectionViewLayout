//
//  LLPageCategoryView.h
//  LLPageCollectionViewLayout
//
//  Created by 百里沉渊🐱 on 2018/3/31.
//  Copyright © 2018年 百里沉渊🐱. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLPageCollectionViewLayout.h"
#import "LLPageCategoryProtocol.h"

@protocol LLPageCategoryViewDelegate;

@interface LLPageCategoryView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) LLPageCollectionViewLayout *collectionViewLayout;
@property (nonatomic, strong) UICollectionView *categoryCollectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic) CGFloat pageControlHeight;
@property (nonatomic, strong) NSLayoutConstraint *pageControlHeightConstraint;

@property (nonatomic, copy, readonly) NSString *registedCellIdentifier;

@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic) NSInteger columnsAPage;

@property (nonatomic, strong) NSArray<id<LLPageCategoryProtocol> > *categoryList;
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, weak) id<LLPageCategoryViewDelegate> delegate;

- (void)registerNib:(UINib *)nib forCategoryCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(Class)cellClass forCategoryCellReuseIdentifier:(NSString *)identifier;

@end

@protocol LLPageCategoryViewDelegate <NSObject>

/**
 调用LLPageCategoryView的registerNib:forCategoryCellWithReuseIdentifier:或registerClass:forCategoryCellReuseIdentifier:方法注册cell后可以实现此代理方法来配置cell的数据

 @param categoryView 横向滑动的分类视图
 @param cell 待配置的cell，类型为用户调用注册方法注册的cell
 @param index 索引标记
 */
- (void)categoryView:(LLPageCategoryView *)categoryView configCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index;

- (void)categoryView:(LLPageCategoryView *)categoryView didSelectCategoryAtIndex:(NSInteger)index;

@end
