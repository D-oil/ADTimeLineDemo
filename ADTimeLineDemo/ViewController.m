//
//  ViewController.m
//  ADTimeLineDemo
//
//  Created by andong on 2017/3/30.
//  Copyright © 2017年 AD.org. All rights reserved.
//

#import "ViewController.h"
#import "TRSDialScrollView.h"
#import "NSDate+Utilities.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet TRSDialScrollView *dialView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong,nonatomic) NSTimer *timer;
@end

@implementation ViewController
- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [_dialView setCurrentValue:_dialView.currentValue+1];
        }];
    }
    return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
//    _dialView.currentValue = 670;
    
    _dialView.delegate = self;
    
    TRSDialRange *range1 = [[TRSDialRange alloc] init];
    range1.location = 10;
    range1.length = 10;
    
    TRSDialRange *range2 = [[TRSDialRange alloc] init];
    range2.location = 20;
    range2.length = 30
    ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_dialView setVideoRanges:@[range1]];
        [_dialView setEventRanges:@[range2]];
    });
    [self.timer fire];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating: %ld",self.dialView.currentValue);
    
    NSUInteger hour = self.dialView.currentValue /60;
    NSUInteger min = (self.dialView.currentValue - hour *60);
    
    self.dateLabel.text = [NSString stringWithFormat:@"%02lu:%02lu:00",(unsigned long)hour,(unsigned long)min];
    
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging:");
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"setContentOffset: animated:YES 才会调用");
    
    NSUInteger hour = self.dialView.currentValue / 60;
    NSUInteger min = (self.dialView.currentValue - hour * 60);
    
    self.dateLabel.text = [NSString stringWithFormat:@"%02lu:%02lu:00",(unsigned long)hour,(unsigned long)min];
    
}
@end
