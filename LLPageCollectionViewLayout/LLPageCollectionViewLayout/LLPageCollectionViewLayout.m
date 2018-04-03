//
//  LLPageCollectionViewLayout.m
//  LLPageCollectionViewLayout
//
//  Created by 百里沉渊🐱 on 2018/1/10.
//  Copyright © 2018年 百里沉渊🐱. All rights reserved.
//

#import "LLPageCollectionViewLayout.h"

@implementation LLPageCollectionViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.numberOfRows = 1;
        self.columnsAPage = 5;
        
        self.pageInset = UIEdgeInsetsZero;
        
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.itemSize = CGSizeZero;
        
        
    }
    return self;
}


- (void)prepareLayout {
    [super prepareLayout];
    
    CGSize singlePageSize = self.collectionView.bounds.size;
    CGFloat widthWithoutInset = singlePageSize.width - _pageInset.left - _pageInset.right;
    CGFloat heightWithoutInset = singlePageSize.height - _pageInset.top - _pageInset.bottom;
    
    //计算item size或者每页的行数和列数
    if (!CGSizeEqualToSize(_itemSize, CGSizeZero)) {
        //设置了itemSize，计算行数和列数
        NSInteger maximumColumns = (widthWithoutInset + _minimumInteritemSpacing) / (_itemSize.width + _minimumInteritemSpacing);
        NSInteger maximumRows = (heightWithoutInset + _minimumLineSpacing) / (_itemSize.height + _minimumLineSpacing);
        
        _caculatedColumnsAPage = maximumColumns;
        _caculatedNumberOfRows = maximumRows;
        
        _calculatedItemSize = _itemSize;
        
    } else if (_numberOfRows > 0 && _columnsAPage > 0) {
        //设置了numberOfORows和columnsAPage，计算itemSize
        CGFloat width = (widthWithoutInset - (_columnsAPage - 1) * _minimumInteritemSpacing) / _columnsAPage;
        CGFloat height = (heightWithoutInset - (_numberOfRows - 1) * _minimumLineSpacing) / _numberOfRows;
        
        _calculatedItemSize = CGSizeMake(width, height);
        
        _caculatedNumberOfRows = _numberOfRows;
        _caculatedColumnsAPage = _columnsAPage;
    }
    
    
    /*
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    NSInteger rows = _numberOfRows;
    if (numberOfItems < _numberOfRows * _columnsAPage) {
        rows = ceil(numberOfItems / (double)_columnsAPage);
    }
    
    //根据pageInset和item的间隔计算itemSize
    CGFloat itemWidth = (self.collectionView.bounds.size.width - (self.pageInset.left + self.pageInset.right + self.minimumInteritemSpacing * (self.columnsAPage - 1))) / self.columnsAPage;
    
    CGFloat itemHeight = (self.collectionView.bounds.size.height - (self.pageInset.top + self.pageInset.bottom + self.minimumLineSpacing * (rows - 1))) / rows;
    
    _calculatedItemSize = CGSizeMake(itemWidth, itemHeight);
    
    //    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    //    NSMutableArray *attrArray = [NSMutableArray array];
    //    for (NSIndexPath *oneIndexPath in indexPaths) {
    //        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:oneIndexPath];
    //        [attrArray addObject:attr];
    //    }
    //    _currentAttributes = [NSArray arrayWithArray:attrArray];
    
    
    NSMutableArray *attrArray = [NSMutableArray array];
    for (int i = 0; i < numberOfItems; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attrArray addObject:attrs];
    }
    _currentAttributes = [NSArray arrayWithArray:attrArray];
     */
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

- (CGSize)collectionViewContentSize {
    
    NSInteger numberOfPages = 0;
//    for (int i = 0; i < [self.collectionView numberOfSections]; i++) {
//        NSInteger count = [self.collectionView numberOfItemsInSection:i];
//
//        NSInteger numberOfItemsOnAPage = _caculatedNumberOfRows * _caculatedColumnsAPage;
//        NSInteger pages = ceil(count / (double)numberOfItemsOnAPage);
//        numberOfPages += pages;
//    }
//    
//    if (numberOfPages == 0) {
//        numberOfPages = 1;
//    }
    
    numberOfPages = [self pagesBeforeSection:[self.collectionView numberOfSections]];
    
    return CGSizeMake(self.collectionView.bounds.size.width * numberOfPages, self.collectionView.bounds.size.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger pageSize = _caculatedNumberOfRows * _caculatedColumnsAPage;
    //页码
    NSInteger beforePages = [self pagesBeforeSection:indexPath.section];
    NSInteger page = indexPath.item / pageSize + beforePages;
    
    NSInteger indexOnPage = indexPath.item % pageSize;
    NSInteger column = indexOnPage % _caculatedColumnsAPage;
    NSInteger row = indexOnPage / _caculatedColumnsAPage;
    
    CGSize size = _calculatedItemSize;
//    if (!CGSizeEqualToSize(_itemSize, CGSizeZero)) {
//        size = _itemSize;
//    }
    
    CGFloat itemX = self.pageInset.left + (size.width + self.minimumInteritemSpacing) * column + page * self.collectionView.bounds.size.width;
    
    CGFloat itemY = self.pageInset.top + (size.height + self.minimumLineSpacing) * row;
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(itemX, itemY, size.width, size.height);
    
    return attributes;
    
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (NSInteger section = 0; section < [self.collectionView numberOfSections]; section++) {
        for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            [attributesArray addObject:layoutAttributes];
        }
    }
    
    return attributesArray;
}

- (NSInteger)pagesOfSection:(NSInteger)section {
    
    NSInteger count = [self.collectionView numberOfItemsInSection:section];
    
    NSInteger numberOfItemsOnAPage = _caculatedNumberOfRows * _caculatedColumnsAPage;
    NSInteger pages = ceil(count / (double)numberOfItemsOnAPage);
    
    return pages;
}

- (NSInteger)pagesBeforeSection:(NSInteger)section {
    
    NSInteger totalPages = 0;
    for (int i = 0; i < section; i++) {
        NSInteger pages = [self pagesOfSection:i];
        totalPages += pages;
    }
    
    return totalPages;
}

@end
