//
//  scrollViewVC.m
//  ADTimeLineDemo
//
//  Created by andong on 2017/4/5.
//  Copyright © 2017年 AD.org. All rights reserved.
//

#import "scrollViewVC.h"

@interface scrollViewVC () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation scrollViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"任何方式触发 contentOffset 变化的时候都会被调用");
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖动");
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"只有调用setContentOffset/scrollRectVisible:animated: 才会调用？");
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"targetContentOffset = %@",NSStringFromCGPoint(*targetContentOffset));
    
    
}

@end
