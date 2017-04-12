/***************************************************
 *  ____              ___   ____                   *
 * |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
 * | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
 * |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
 * |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
 *                                                 *
 ***************************************************/


#import "TRSDialScrollView.h"

@interface TRSDialScrollView () <UIScrollViewDelegate> {
    
    NSInteger _currentValue;
}

@property (assign, nonatomic) NSInteger min;
@property (assign, nonatomic) NSInteger max;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) TRSDialView *dialView;

@end

@implementation TRSDialScrollView

- (void)setVideoRanges:(NSArray<TRSDialRange *> *) videoRanges
{
    [self.dialView setVideoRanges:videoRanges];
}

- (void)setEventRanges:(NSArray<TRSDialRange *> *) eventRanges {
    [self.dialView setEventRanges:eventRanges];
}
- (void)commonInit
{
    _max = 0;
    _min = 0;
    
    // Set the default frame size
    // Don't worry, we will be changing this later
    self.dialView = [[TRSDialView alloc] init];
    [self setDialRangeFrom:0 to:1440];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.dialView addGestureRecognizer:pinch];
    
    // Don't let the container handle User Interaction
    //[_dialView setUserInteractionEnabled:NO];
    self.scrollView = [[UIScrollView alloc] init];
    // Disable scroll bars
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setClipsToBounds:YES];

    // Setup the ScrollView
    [self.scrollView setBounces:NO];
    [self.scrollView setBouncesZoom:NO];
    self.scrollView.delegate = self;
    
    [self.scrollView addSubview:self.dialView];
    [self addSubview:self.scrollView];

    
    // Clips the Dial View to the bounds of this view
    self.clipsToBounds = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {

        [self commonInit];
    }
    
    return self;
}
- (void)layoutSubviews {
    
    if (self.dialView) {
        CGRect dialViewFrame = self.dialView.frame ;
        dialViewFrame.size.height = self.bounds.size.height;
        
        [self.dialView setFrame:dialViewFrame];
        [self.scrollView setFrame:self.bounds];
//        NSLog(@"self.bounds = %@",NSStringFromCGRect(self.bounds));
        
        
        self.dialView.minorTickLength = self.frame.size.height/ 8;
        self.dialView.majorTickLength = self.frame.size.height/ 6 ;
        self.dialView.minorTickDistance = self.frame.size.width / 60;
        [self setDialRangeFrom:0 to:1440];
        
        [self.dialView setNeedsDisplay];
        
    }
}


- (void)pinchGesture:(UIPinchGestureRecognizer *)pinch {
    NSLog(@"scale = %f",pinch.scale);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (pinch.scale >= 1) {
            self.dialView.minorTickDistance = self.dialView.minorTickDistance + 3;
        } else {
            self.dialView.minorTickDistance = self.dialView.minorTickDistance - 1;
        }
    });
    
}

#pragma mark - Methods

- (void)setDialRangeFrom:(NSInteger)from to:(NSInteger)to {
    
    self.min = from;
    self.max = to;
    
    // Update the dial view
    [self.dialView setDialRangeFrom:from to:to];
    
    self.scrollView.contentSize = CGSizeMake(self.dialView.frame.size.width, self.bounds.size.height);
}

- (CGPoint)scrollToOffset:(CGPoint)starting {
    
    // Initialize the end point with the starting position
    CGPoint ending = starting;
    
    // Calculate the ending offset
    ending.x = roundf(starting.x / self.minorTickDistance) * self.minorTickDistance;
    
    NSLog(@"starting=%f, ending=%f", starting.x, ending.x);
    
    return ending;
}

#pragma mark - UIScrollViewDelegate

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector])
        return YES;
    
    if ([self.delegate respondsToSelector:aSelector])
        return YES;
    
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.delegate respondsToSelector:aSelector])
        return self.delegate;

    // Always call parent object for default
    return [super forwardingTargetForSelector:aSelector];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    // Make sure that we scroll to the nearest tick mark on the dial.
    *targetContentOffset = [self scrollToOffset:(*targetContentOffset)];
    
    if ([self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        
        [self.delegate scrollViewWillEndDragging:scrollView
                                    withVelocity:velocity
                             targetContentOffset:targetContentOffset];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchBegan");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved");
}

#pragma mark - Properties

- (void)setMinorTicksPerMajorTick:(NSInteger)minorTicksPerMajorTick
{
    self.dialView.minorTicksPerMajorTick = minorTicksPerMajorTick;
}

- (NSInteger)minorTicksPerMajorTick
{
    return self.dialView.minorTicksPerMajorTick;
}

- (void)setMinorTickDistance:(NSInteger)minorTickDistance
{
    self.dialView.minorTickDistance = minorTickDistance;
}

- (NSInteger)minorTickDistance
{
    return self.dialView.minorTickDistance;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.dialView.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor
{
    return self.dialView.backgroundColor;
}

- (void)setLabelStrokeColor:(UIColor *)labelStrokeColor
{
    self.dialView.labelStrokeColor = labelStrokeColor;
}

- (UIColor *)labelStrokeColor
{
    return self.dialView.labelStrokeColor;
}

- (void)setLabelFillColor:(UIColor *)labelFillColor
{
    self.dialView.labelFillColor = labelFillColor;
}

- (void)setLabelStrokeWidth:(CGFloat)labelStrokeWidth
{
    self.dialView.labelStrokeWidth = labelStrokeWidth;
}

- (CGFloat)labelStrokeWidth
{
    return self.dialView.labelStrokeWidth;
}

- (UIColor *)labelFillColor
{
    return self.dialView.labelFillColor;
}

- (void)setLabelFont:(UIFont *)labelFont
{
    self.dialView.labelFont = labelFont;
}

- (UIFont *)labelFont
{
    return self.dialView.labelFont;
}

- (void)setMinorTickColor:(UIColor *)minorTickColor
{
    self.dialView.minorTickColor = minorTickColor;
}

- (UIColor *)minorTickColor
{
    return self.dialView.minorTickColor;
}

- (void)setMinorTickLength:(CGFloat)minorTickLength
{
    self.dialView.minorTickLength = minorTickLength;
}

- (CGFloat)minorTickLength
{
    return self.dialView.minorTickLength;
}

- (void)setMinorTickWidth:(CGFloat)minorTickWidth
{
    self.dialView.minorTickWidth = minorTickWidth;
}

- (CGFloat)minorTickWidth
{
    return self.dialView.minorTickWidth;
}

- (void)setMajorTickColor:(UIColor *)majorTickColor
{
    self.dialView.majorTickColor = majorTickColor;
}

- (UIColor *)majorTickColor
{
    return self.dialView.majorTickColor;
}

- (void)setMajorTickLength:(CGFloat)majorTickLength
{
    self.dialView.majorTickLength = majorTickLength;
}

- (CGFloat)majorTickLength
{
    return self.dialView.majorTickLength;
}

- (void)setMajorTickWidth:(CGFloat)majorTickWidth
{
    self.dialView.majorTickWidth = majorTickWidth;
}

- (CGFloat)majorTickWidth
{
    return self.dialView.majorTickWidth;
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    self.dialView.shadowColor = shadowColor;
}

- (UIColor *)shadowColor
{
    return self.dialView.shadowColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    self.dialView.shadowOffset = shadowOffset;
}

- (CGSize)shadowOffset
{
    return self.dialView.shadowOffset;
}

- (void)setShadowBlur:(CGFloat)shadowBlur
{
    self.dialView.shadowBlur = shadowBlur;
}

- (CGFloat)shadowBlur
{
    return self.dialView.shadowBlur;
}

- (UIColor *)overlayColor
{
    return self.overlayColor;
}

- (void)setCurrentValue:(NSInteger)newValue {
    
    if (newValue >= _max) {
        return;
    }
    
    // Check to make sure the value is within the available range
    if ((newValue < _min) || (newValue > _max)) {
        _currentValue = _min;
        
    }
    else{
        _currentValue = newValue;
    }
    // Update the content offset based on new value
    CGPoint offset = self.scrollView.contentOffset;

    offset.x = (newValue - self.dialView.minimum) * self.dialView.minorTickDistance;
    
    [self.scrollView setContentOffset:offset animated:YES] ;
}

- (NSInteger)currentValue
{
    return roundf(self.scrollView.contentOffset.x / self.dialView.minorTickDistance) + self.dialView.minimum;
}

@end
