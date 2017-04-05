//
//  ViewController.m
//  ADTimeLineDemo
//
//  Created by andong on 2017/3/30.
//  Copyright © 2017年 AD.org. All rights reserved.
//

#import "ViewController.h"
#import "TRSDialScrollView.h"
@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet TRSDialScrollView *dialView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
//    _dialView.currentValue = 670;
    
    _dialView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSLog(@"scrollViewDidEndDecelerating: %ld",self.dialView.currentValue);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging:");
}

@end
