//
//  ViewController.m
//  LLPageCollectionViewLayout
//
//  Created by 百里沉渊🐱 on 2018/1/10.
//  Copyright © 2018年 百里沉渊🐱. All rights reserved.
//

#import "ViewController.h"
#import "LLTestCollectionViewCell.h"

#import "LLPageCollectionViewLayout.h"

static NSString *testCellId = @"testCell";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

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
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 160) collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    _collectionView.pagingEnabled = YES;
    
//    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:testCellId];
    [_collectionView registerNib:[UINib nibWithNibName:@"LLTestCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:testCellId];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 17;
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

@end
