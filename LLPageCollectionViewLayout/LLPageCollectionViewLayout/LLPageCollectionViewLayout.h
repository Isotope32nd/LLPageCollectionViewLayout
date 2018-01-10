//
//  LLPageCollectionViewLayout.h
//  LLPageCollectionViewLayout
//
//  Created by 百里沉渊🐱 on 2018/1/10.
//  Copyright © 2018年 百里沉渊🐱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLPageCollectionViewLayout : UICollectionViewLayout {
    
    CGSize _calculatedItemSize;
    
    NSArray<UICollectionViewLayoutAttributes *> *_currentAttributes;
}

@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic) NSInteger columnsAPage;

@property (nonatomic) UIEdgeInsets pageInset;

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGSize itemSize;

@end
