# PhotoSelectManager

首先来看Demo样式：
![photos.gif](photos.gif)

最近看到网上有很多这种图片选择的Demo，闲来无事自己也来尝试一下，这个版本只提供了最基础的图片选择功能，之后还会持续更新新的功能，接下来看一下使用方法:
```
// 首先导入 "PhotoNavigationController.h" 文件.
- (IBAction)handleSelectPhotosAction:(id)sender {
    PhotoNavigationController *navigationController = [[PhotoNavigationController alloc] init];
    // 设置最大可选择相片数量，默认为9张
    navigationController.maxSelectedCount = 10;
    [self presentViewController:navigationController animated:YES completion:nil];
    // 选择图片回调
    WeakSelf(self)
    [navigationController getSelectedPhotosWithBlock:^(NSArray<ALAsset *> *selectedArray) {
        // selectedArray即选择的图片数组, 里面的对象是ALAsset类型
        // 在这里拿到选择后的图片数据, 可以在这里处理你想要做的事
        weakSelf.dataArray = [NSArray arrayWithArray:selectedArray];
        [weakSelf.collectionView reloadData];
    }];
}
```

使用方法就是上边的几行代码，就是这么简单......

如果这个Demo对你有帮助的话请给个star奥，谢谢大家 😄 !!!


