//
//  ViewController.m
//  TestScrollView
//
//  Created by gongliang on 15/9/24.
//  Copyright © 2015年 AB. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "GLImageScrollView.h"

@interface ViewController ()<GLImageScrollViewDelegate>

@property (nonatomic, strong) GLImageScrollView *imageScrollView;

@end

@implementation ViewController

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _imageScrollView = [[GLImageScrollView alloc] init];
    _imageScrollView.backgroundColor = [UIColor yellowColor];
    _imageScrollView.delegate = self;
    
    [self.view addSubview:_imageScrollView];
    [_imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(140);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.height.mas_equalTo(160);
    }];
    [_imageScrollView reloadData];
 
    self.automaticallyAdjustsScrollViewInsets = NO;
}


#pragma mark - ImageScrollViewDelegate 
- (NSInteger)numberOfItems {
    return 3;
}

- (void)imageScrollView:(GLImageScrollView *)imageScrollView
  loadImageForImageView:(UIImageView *)imageView
                  index:(NSInteger)index {
    NSArray *array = @[@"test1.jpg", @"test2.jpg", @"test3.jpg"];
    NSArray *colors = @[[UIColor redColor], [UIColor yellowColor], [UIColor greenColor]];
    imageView.image = [UIImage imageNamed:array[index]];
    imageView.backgroundColor = colors[index];
}

- (void)imageScrollView:(GLImageScrollView *)imageScrollView didTapAtIndex:(NSInteger)index {
    NSLog(@"tap %@", @(index));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
