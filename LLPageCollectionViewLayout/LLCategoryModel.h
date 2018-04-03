//
//  LLCategoryModel.h
//  LLPageCollectionViewLayout
//
//  Created by 百里沉渊🐱 on 2018/4/2.
//  Copyright © 2018年 百里沉渊🐱. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLPageCategoryProtocol.h"

@interface LLCategoryModel : NSObject

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) NSURL *categoryImageUrl;

@end
