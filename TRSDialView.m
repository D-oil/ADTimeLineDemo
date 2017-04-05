/***************************************************
 *  ____              ___   ____                   *
 * |  _ \ __ _ _ __  ( _ ) / ___|  ___ __ _ _ __   *
 * | |_) / _` | '_ \ / _ \/\___ \ / __/ _` | '_ \  *
 * |  __/ (_| | | | | (_>  <___) | (_| (_| | | | | *
 * |_|   \__,_|_| |_|\___/\/____/ \___\__,_|_| |_| *
 *                                                 *
 ***************************************************/

#import "TRSDialView.h"

NSString * const kTRSDialViewDefaultFont = @"HelveticaNeue"; //大刻度下字体frame

const NSInteger kTRSDialViewDefautLabelFontSize = 12;        //大刻度下字体大小
                                        //小刻度
const CGFloat kTRSDialViewDefaultMinorTickDistance = 5.15f;  //小刻度之间距离
const CGFloat kTRSDialViewDefaultMinorTickLength   = 19.0f;  //小刻度长度
const CGFloat KTRSDialViewDefaultMinorTickWidth    =  0.5f;  //小刻度宽度
                                        //大刻度
const NSInteger kTRSDialViewDefaultMajorTickDivisions = 5; //大刻度之间间距差 12表示12个刻度有一个大刻度
const CGFloat kTRSDialViewDefaultMajorTickLength      = 25.0f; //大刻度长度
const CGFloat kTRSDialViewDefaultMajorTickWidth       = 0.5f;  //大刻度宽度

typedef NS_ENUM(NSUInteger, lineSide) {
    lineSide_Top,
    lineSide_Bottom,
};

//Dial 刻度
@interface TRSDialView ()

@end

@implementation TRSDialView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self commonInit];
    }

    return self;
}


- (void)commonInit {
    _minimum = 0;
    _maximum = 0;
    
    _minorTicksPerMajorTick = kTRSDialViewDefaultMajorTickDivisions;
    _minorTickDistance = kTRSDialViewDefaultMinorTickDistance;
    
    _backgroundColor = [UIColor colorWithRed:50/255.0 green:51/255.0 blue:52/255.0 alpha:0.7];
    
    _labelStrokeColor = [UIColor colorWithRed:0.482 green:0.008 blue:0.027 alpha:1.000];
    _labelFillColor = [UIColor grayColor];
    _labelStrokeWidth = 1.0;
    
    _labelFont = [UIFont fontWithName:kTRSDialViewDefaultFont
                                 size:kTRSDialViewDefautLabelFontSize];
    
    _minorTickColor = [UIColor colorWithRed:216/255.0 green:217/255.0 blue:218/255.0 alpha:1.000];
    _minorTickLength = kTRSDialViewDefaultMinorTickLength;
    _minorTickWidth = KTRSDialViewDefaultMinorTickWidth;
    
    _majorTickColor = [UIColor colorWithRed:216/255.0 green:217/255.0 blue:218/255.0 alpha:1.000];
    _majorTickLength = kTRSDialViewDefaultMajorTickLength;
    _majorTickWidth = kTRSDialViewDefaultMajorTickWidth;
    
    //_shadowColor = [UIColor colorWithWhite:1.000 alpha:1.000];
    //_shadowOffset = CGSizeMake(1, 1);
    //_shadowBlur = 0.9f;

}


- (void)layoutSubviews {
    
    _minorTickLength = self.frame.size.height/ 8;
    _majorTickLength = self.frame.size.height/ 6 ;
    _minorTickDistance = self.superview.frame.size.width / 60;
    [self setDialRangeFrom:self.minimum to:self.maximum];

}

- (void)setDialRangeFrom:(NSInteger)from to:(NSInteger)to {

    _minimum = from;
    _maximum = to;
    
    // Resize the frame of the view
    CGRect frame = self.frame;
    
    frame.size.width = (_maximum - _minimum) * _minorTickDistance + self.superview.frame.size.width;
    
    NSLog(@"frame = %@", NSStringFromCGRect(frame));
    
    self.frame = frame;
}

- (void)updateViewFrame {
    
}

#pragma mark - Drawing

- (void)drawLabelWithContext:(CGContextRef)context
                     atPoint:(CGPoint)point
                        text:(NSString *)text
                   fillColor:(UIColor *)fillColor
                 strokeColor:(UIColor *)strokeColor {
    
    CGSize boundingBox = [text sizeWithFont:self.labelFont];
    
    CGFloat label_y_offset = self.majorTickLength + (boundingBox.height / 2);

    // We want the label to be centered on the specified x value
    NSInteger label_x = point.x + (boundingBox.width / 4);

    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);

    CGContextSetLineWidth(context, self.labelStrokeWidth);
    
    // Set the drawing mode based on the presence of the file and stroke colors
    CGTextDrawingMode mode = kCGTextFillStroke;
    
    if ((fillColor == nil) && (strokeColor == nil))
        mode = kCGTextInvisible;
        
    else if (fillColor == nil)
        mode = kCGTextStroke;
    
    else if (strokeColor == nil)
        mode = kCGTextFill;
    
    CGContextSetTextDrawingMode(context, mode);

    [text drawInRect:CGRectMake(label_x, point.y + label_y_offset, boundingBox.width, boundingBox.height)
            withFont:self.labelFont
       lineBreakMode:NSLineBreakByTruncatingTail
           alignment:NSTextAlignmentCenter];

}

- (void)drawMinorTickWithContext:(CGContextRef)context
                         atPoint:(CGPoint)point
                       withColor:(UIColor *)color
                           width:(CGFloat)width
                          length:(CGFloat)length
                        lineSide:(lineSide)lineSide{

    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);

    CGContextMoveToPoint(context, point.x, point.y);
    if (lineSide == lineSide_Top) {
        CGContextAddLineToPoint(context, point.x, point.y + length);
    } else if (lineSide == lineSide_Bottom) {
        CGContextAddLineToPoint(context, point.x, point.y - length);
    }
    

    CGContextStrokePath(context);
}

- (void)drawMajorTickWithContext:(CGContextRef)context
                         atPoint:(CGPoint)point
                       withColor:(UIColor *)color
                           width:(CGFloat)width
                          length:(CGFloat)length
                        lineSide:(lineSide)lineSide{

    // Draw the line
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, width);
    CGContextSetLineCap(context, kCGLineCapRound);

    CGContextMoveToPoint(context, point.x, point.y);
    if (lineSide == lineSide_Top) {
        CGContextAddLineToPoint(context, point.x, point.y + length);
    } else if (lineSide == lineSide_Bottom) {
        CGContextAddLineToPoint(context, point.x, point.y - length);
    }

    CGContextStrokePath(context);
}

- (BOOL)isMajorTick:(NSInteger)x {
    
    NSInteger tick_number = (x - self.leading) / self.minorTickDistance;
    
    return (tick_number % self.minorTicksPerMajorTick) == 0;
}

-(void)drawTicksWithContext:(CGContextRef)context atX:(NSInteger)x
{

    CGPoint TopPoint = CGPointMake(x, 0);
    CGPoint bottomPoint = CGPointMake(x, self.frame.size.height);
    CGContextSetShadowWithColor(
        context,
        self.shadowOffset,
        self.shadowBlur,
        self.shadowColor.CGColor);

    if ([self isMajorTick:x]) {
        //上面长线
        [self drawMajorTickWithContext:context
                               atPoint:TopPoint
                             withColor:self.majorTickColor
                                 width:self.majorTickWidth
                                length:self.majorTickLength
                              lineSide:lineSide_Top];
        //下面长线
        
        [self drawMajorTickWithContext:context
                               atPoint:bottomPoint
                             withColor:self.majorTickColor
                                 width:self.majorTickWidth
                                length:self.majorTickLength
                              lineSide:lineSide_Bottom];
        // Draw the text
        //
        // 1) Take the existing position and subtract off the lead spacing
        // 2) Divide by the minor ticks to get the major number
        // 3) Add the minimum to get the current value
        //
        int value = (TopPoint.x - self.leading) / self.minorTickDistance + _minimum;
        if (value % 30 == 0 || value == 0) {
            int hour = value / 60;
            int min = (value - hour *60) ;
            NSString *text = [NSString stringWithFormat:@"%02i:%02i",hour,min];
            [self drawLabelWithContext:context
                               atPoint:TopPoint
                                  text:text
                             fillColor:self.labelFillColor
                           strokeColor:self.labelStrokeColor];
        }
        

    } else {

        // Save the current context so we revert some of the changes laster
        CGContextSaveGState(context);

        [self drawMinorTickWithContext:context
                               atPoint:TopPoint
                             withColor:self.minorTickColor
                                 width:self.minorTickWidth
                                length:self.minorTickLength
                              lineSide:lineSide_Top];

        [self drawMinorTickWithContext:context
                               atPoint:bottomPoint
                             withColor:self.minorTickColor
                                 width:self.minorTickWidth
                                length:self.minorTickLength
                              lineSide:lineSide_Bottom];
        // Restore the context
        CGContextRestoreGState(context);
    }
}

/**
 * The number of pixels that need to be prepended to the begining and ending
 * of the dial to make sure that the center mark is able to reach all available
 * values on the range of the dial.
 */
- (NSInteger)leading
{
//    NSLog(@"%f",self.superview.frame.size.width);
    return self.superview.frame.size.width / 2;
}

/**
 * Perform Custom drawing
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"frame = %@\n", NSStringFromCGRect(rect));
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Fill the background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);

    CGContextFillRect(context, rect);
    
    // Add the tick Marks
    for (NSInteger i = self.leading; i < rect.size.width; i += self.minorTickDistance) {

        // After
        if (i > (self.frame.size.width - self.leading))
            break;

        // Middle
        else
            [self drawTicksWithContext:context atX:i];

    }
    
    
}


- (void)setMinorTickDistance:(NSInteger)minorTickDistance{
    if (minorTickDistance <= 5 && minorTickDistance >=1) {
        _minorTickDistance = minorTickDistance;
        [self setDialRangeFrom:_minimum to:_maximum];
        [self setNeedsLayout];
    }
    
}

@end

