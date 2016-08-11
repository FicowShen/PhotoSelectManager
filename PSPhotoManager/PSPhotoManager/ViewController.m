//
//  ViewController.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/8.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "ViewController.h"
#import "PhotoNavigationController.h"
#import "PhotoManagerConfig.h"
#import "PhotoRevealCell.h"

static NSString *const reUse = @"reUse";

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <ALAsset *>*dataArray;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updatePrompt];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"View Controller";
    
    self.dataArray = [NSArray array];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[PhotoRevealCell class] forCellWithReuseIdentifier:reUse];
}

#pragma mark -
#pragma mark - item action
- (IBAction)removePhotosAction:(id)sender {
    self.dataArray = [NSArray array];
    [self.collectionView reloadData];
    [self updatePrompt];
}

- (IBAction)handleSelectPhotosAction:(id)sender {
    PhotoNavigationController *navigationController = [[PhotoNavigationController alloc] init];
    navigationController.maxSelectedCount = 10;
    [self presentViewController:navigationController animated:YES completion:nil];
    // 选择图片回调
    WeakSelf(self)
    [navigationController getSelectedPhotosWithBlock:^(NSArray<ALAsset *> *selectedArray) {
        weakSelf.dataArray = [NSArray arrayWithArray:selectedArray];
        [weakSelf.collectionView reloadData];
    }];
}

#pragma mark -
#pragma mark - update Prompt
- (void)updatePrompt {
    NSTimeInterval delayInSeconds = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataArray.count > 0) {
            [self.navigationItem setPrompt:nil];
        } else {
            [self.navigationItem setPrompt:@"点击右侧按钮选择图片"];
        }
    });
}

#pragma mark -
#pragma mark - collectionView protocol methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoRevealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reUse forIndexPath:indexPath];
    ALAsset *asset = self.dataArray[indexPath.row];
    // 显示缩略图
    UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
    [cell reloadDataWithImage:image];
    return cell;
}

#pragma mark -
#pragma mark - getter methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat kPadding = 3.f;
        CGFloat kWidth = (kScreenWidth - 4 * kPadding) / 3;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kWidth, kWidth);
        layout.sectionInset = UIEdgeInsetsMake(kPadding, kPadding, kPadding, kPadding);
        layout.minimumInteritemSpacing = kPadding;
        layout.minimumLineSpacing = kPadding;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = HEXCOLOR(0xffffff);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


