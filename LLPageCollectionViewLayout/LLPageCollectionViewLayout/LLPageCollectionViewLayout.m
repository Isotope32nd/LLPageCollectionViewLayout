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
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

- (CGSize)collectionViewContentSize {
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    NSInteger numberOfItemsOnAPage = self.numberOfRows * self.columnsAPage;
    NSInteger pages = ceil(count / (double)numberOfItemsOnAPage);
    
    /*
     CGFloat pageWidth = self.pageInset.left + self.pageInset.right + (self.itemSize.width + self.minimumInteritemSpacing) * self.columnsAPage - self.minimumInteritemSpacing;
     
     CGFloat width = pages * pageWidth;
     
     CGFloat height = self.pageInset.top + self.pageInset.bottom + self.itemSize.height * self.numberOfRows + self.minimumLineSpacing;
     
     return CGSizeMake(width, height);
     */
    
    return CGSizeMake(self.collectionView.bounds.size.width * pages, self.collectionView.bounds.size.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger pageSize = self.numberOfRows * self.columnsAPage;
    //页码
    NSInteger page = indexPath.item / pageSize;
    
    NSInteger indexOnPage = indexPath.item % pageSize;
    NSInteger column = indexOnPage % self.columnsAPage;
    NSInteger row = indexOnPage / self.columnsAPage;
    
    CGSize size = _calculatedItemSize;
    if (!CGSizeEqualToSize(_itemSize, CGSizeZero)) {
        size = _itemSize;
    }
    
    CGFloat itemX = self.pageInset.left + (size.width + self.minimumInteritemSpacing) * column + page * self.collectionView.bounds.size.width;
    
    CGFloat itemY = self.pageInset.top + (size.height + self.minimumLineSpacing) * row;
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(itemX, itemY, size.width, size.height);
    
    return attributes;
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return _currentAttributes;
}

@end
