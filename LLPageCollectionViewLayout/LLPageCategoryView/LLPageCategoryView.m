//
//  LLPageCategoryView.m
//  LLPageCollectionViewLayout
//
//  Created by 百里沉渊🐱 on 2018/3/31.
//  Copyright © 2018年 百里沉渊🐱. All rights reserved.
//

#import "LLPageCategoryView.h"
#import "LLPageCategoryCollectionViewCell.h"

#import "LLPageCollectionViewLayout.h"

#import "UIImageView+WebCache.h"

static NSString *categoryCellId = @"LLPageCategoryCell";

@implementation LLPageCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _pageControlHeight = 20;
        
        LLPageCollectionViewLayout *layout = [[LLPageCollectionViewLayout alloc]init];
        _collectionViewLayout = layout;
        
        _categoryCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - _pageControlHeight) collectionViewLayout:layout];
        [self addSubview:_categoryCollectionView];
        _categoryCollectionView.backgroundColor = [UIColor whiteColor];
        _categoryCollectionView.pagingEnabled = YES;
        _categoryCollectionView.showsVerticalScrollIndicator = NO;
        _categoryCollectionView.showsHorizontalScrollIndicator = NO;
        [_categoryCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LLPageCategoryCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:categoryCellId];
        _categoryCollectionView.dataSource = self;
        _categoryCollectionView.delegate = self;
        _categoryCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _pageControl = [[UIPageControl alloc]init];
        [self addSubview:_pageControl];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    
    if (_categoryCollectionView.constraints.count == 0) {
        NSLayoutConstraint *categoryTop = [NSLayoutConstraint constraintWithItem:_categoryCollectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *categoryLeading = [NSLayoutConstraint constraintWithItem:_categoryCollectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        NSLayoutConstraint *categoryTrailing = [NSLayoutConstraint constraintWithItem:_categoryCollectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
//        [_categoryCollectionView addConstraints:@[ categoryTop, categoryLeading, categoryTrailing ]];
        [self addConstraints:@[ categoryTop, categoryLeading, categoryTrailing ]];
    }
    
    if (_categoryCollectionView.constraints.count == 0) {
        NSLayoutConstraint *pageControlTop = [NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_categoryCollectionView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *pageControlBottom = [NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *pageControlCenterX = [NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *pageControlHeight = [NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
//        NSLayoutConstraint *pageControlWidth = [NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        _pageControlHeightConstraint = pageControlHeight;
//        [_pageControl addConstraints:@[ pageControlTop, pageControlBottom, pageControlCenterX, pageControlHeight ]];
        [self addConstraints:@[ pageControlTop, pageControlBottom, pageControlCenterX ]];
        [_pageControl addConstraint:pageControlHeight];
    }
    
    [super updateConstraints];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCategoryList:(NSArray<id<LLPageCategoryProtocol>> *)categoryList {
    _categoryList = categoryList;
    
    [_categoryCollectionView reloadData];
    
    if (_numberOfRows > 0 && _columnsAPage > 0) {
        double page = categoryList.count / (double)(_numberOfRows * _columnsAPage);
        _pageControl.numberOfPages = ceil(page);
    }
}

- (void)setNumberOfRows:(NSInteger)numberOfRows {
    _numberOfRows = numberOfRows;
    
    self.collectionViewLayout.numberOfRows = numberOfRows;
}

- (void)setColumnsAPage:(NSInteger)columnsAPage {
    _columnsAPage = columnsAPage;
    
    self.collectionViewLayout.columnsAPage = columnsAPage;
}

#pragma mark -

- (void)registerNib:(UINib *)nib forCategoryCellWithReuseIdentifier:(NSString *)identifier {
    
    _registedCellIdentifier = identifier;
    
    [_categoryCollectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registerClass:(Class)cellClass forCategoryCellReuseIdentifier:(NSString *)identifier {
    
    _registedCellIdentifier = identifier;
    
    [_categoryCollectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _categoryList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_registedCellIdentifier.length > 0) {
        __kindof UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_registedCellIdentifier forIndexPath:indexPath];
        
        if ([_delegate respondsToSelector:@selector(categoryView:configCell:atIndex:)]) {
            [_delegate categoryView:self configCell:cell atIndex:indexPath.item];
        }
        
        return cell;
        
    } else {
        LLPageCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryCellId forIndexPath:indexPath];
        id<LLPageCategoryProtocol> categoryInfo = _categoryList[indexPath.item];
        
        [cell.imageView sd_setImageWithURL:[categoryInfo categoryImageUrl] placeholderImage:_placeholderImage];
        cell.nameLabel.text = [categoryInfo categoryName];
        
        return cell;
    }
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_delegate respondsToSelector:@selector(categoryView:didSelectCategoryAtIndex:)]) {
        [_delegate categoryView:self didSelectCategoryAtIndex:indexPath.item];
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _categoryCollectionView) {
        if (_numberOfRows > 0 && _columnsAPage > 0) {
            NSArray *indexPaths = [_categoryCollectionView indexPathsForVisibleItems];
            NSIndexPath *indexPath = [indexPaths firstObject];
            NSInteger page = indexPath.item / (_numberOfRows * _columnsAPage);
            _pageControl.currentPage = page;
        }
    }
}

@end
