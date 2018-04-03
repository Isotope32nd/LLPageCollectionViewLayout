//
//  ViewController.m
//  LLPageCollectionViewLayout
//
//  Created by 百里沉渊🐱 on 2018/1/10.
//  Copyright © 2018年 百里沉渊🐱. All rights reserved.
//

#import "ViewController.h"
#import "LLTestCollectionViewCell.h"
#import "LLTestFlowLayout.h"
#import "LLPageCategoryView.h"
#import "LLCategoryModel.h"

#import "LLPageCollectionViewLayout.h"

static NSString *testCellId = @"testCell";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LLPageCategoryViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LLPageCollectionViewLayout *layout = [[LLPageCollectionViewLayout alloc]init];
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 4;
    layout.columnsAPage = 4;
    layout.numberOfRows = 2;
    layout.pageInset = UIEdgeInsetsMake(8, 8, 8, 8);
    
//    layout.pageInset = UIEdgeInsetsZero;
//    layout.itemSize = CGSizeMake(self.view.bounds.size.width / 4, 80);
    
//    LLTestFlowLayout *flowLayout = [[LLTestFlowLayout alloc]init];
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
//    flowLayout.minimumInteritemSpacing = 4;
//    flowLayout.minimumLineSpacing = 4;
//    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width / 4, 60);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 160) collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    _collectionView.pagingEnabled = YES;
    
//    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:testCellId];
    [_collectionView registerNib:[UINib nibWithNibName:@"LLTestCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:testCellId];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    LLPageCategoryView *categoryView = [[LLPageCategoryView alloc]initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 160)];
    [self.view addSubview:categoryView];
    categoryView.backgroundColor = [UIColor lightGrayColor];
    categoryView.placeholderImage = [UIImage imageNamed:@"image_grouping_store"];
    categoryView.numberOfRows = 2;
    categoryView.columnsAPage = 5;
//    categoryView.collectionViewLayout.numberOfRows = 2;
//    categoryView.collectionViewLayout.columnsAPage = 5;
    [categoryView registerNib:[UINib nibWithNibName:@"LLTestCollectionViewCell" bundle:[NSBundle mainBundle]] forCategoryCellWithReuseIdentifier:@"LLTestCell"];
    categoryView.delegate = self;
    
    NSMutableArray *categoryList = [NSMutableArray array];
    for (int i = 0; i < 17; i++) {
        LLCategoryModel *categoryInfo = [[LLCategoryModel alloc]init];
        categoryInfo.categoryName = [NSString stringWithFormat:@"Category %d", i];
        categoryInfo.categoryImageUrl = nil;
        [categoryList addObject:categoryInfo];
    }
    categoryView.categoryList = categoryList;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger numberOfItems = 0;
    switch (section) {
        case 0:
            numberOfItems = 17;
            break;
        case 1:
            numberOfItems = 6;
            break;
            
        default:
            numberOfItems = 0;
            break;
    }
    return numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LLTestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:testCellId forIndexPath:indexPath];
    
    NSInteger red = random() % 255;
    NSInteger green = random() % 255;
    NSInteger blue = random() % 255;
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"Cell %ld", indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"size for item at section : %ld, item : %ld", indexPath.section, indexPath.item);
    
    return CGSizeMake(self.view.bounds.size.width / 4, 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 4;
}

#pragma mark - LLPageCategoryViewDelegate

- (void)categoryView:(LLPageCategoryView *)categoryView configCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    
    LLTestCollectionViewCell *testCell = cell;
    
    NSInteger red = random() % 255;
    NSInteger green = random() % 255;
    NSInteger blue = random() % 255;
    
    testCell.contentView.backgroundColor = [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1];
    
    testCell.titleLabel.text = [NSString stringWithFormat:@"Cell %ld", index];
}

@end
