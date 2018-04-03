//
//  LLTestFlowLayout.m
//  LLPageCollectionViewLayout
//
//  Created by 百里沉渊🐱 on 2018/3/30.
//  Copyright © 2018年 百里沉渊🐱. All rights reserved.
//

#import "LLTestFlowLayout.h"

@implementation LLTestFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    
    NSLog(@"----count of layoutAttributes : %ld, in rect : %@", layoutAttributes.count, [NSValue valueWithCGRect:rect]);
    
    for (UICollectionViewLayoutAttributes *attributes in layoutAttributes) {
//        NSLog(@">>>>section %ld, item %ld, frame : %@", attributes.indexPath.section, attributes.indexPath.item, [NSValue valueWithCGRect:attributes.frame]);
    }
    
    return layoutAttributes;
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    return attributes;
}

//- (CGSize)collectionViewContentSize {
//    
//    return CGSizeMake(667, 667);
//}

@end
