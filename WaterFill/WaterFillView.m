//
//  WaterFillView.m
//  WaterFillView
//
//  Created by Wang Yandong on 4/21/14.
//  Copyright (c) 2014 wangyandong@outlook.com. All rights reserved.
//

#import "WaterFillView.h"

static const CGFloat kAmplitude = 6.0;
static const CGFloat kFrequency = 0.04;
static const CGFloat kPhaseStep = 0.2;

@interface WaterFillView ()
{
    CADisplayLink *_displayLink;
    CGFloat _phrase;
    CGFloat _y;
}

@end


@implementation WaterFillView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }

    return self;
}

- (void) setup
{
    [self startDisplayLink];
}

- (void) dealloc
{
    [self stopDisplayLink];
}

- (void) startDisplayLink
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    _displayLink.frameInterval = 2;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void) stopDisplayLink
{
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void) update:(CADisplayLink *)displayLink
{
    _phrase += kPhaseStep;
    _y -= kPhaseStep * 2;
    
    if (-_y >= CGRectGetHeight(self.bounds))
    {
        _y = 0;
    }

    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    CGFloat halfHeight = CGRectGetHeight(bounds) / 2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, halfHeight);

    NSUInteger times = (NSUInteger)CGRectGetWidth(bounds);
    CGPoint start;
    for (NSUInteger t = 0; t <= times; ++t)
    {
        CGFloat y = (CGFloat)(kAmplitude * sin(t * kFrequency + _phrase));

        if (0 == t)
        {
            CGContextMoveToPoint(context, 0.0, y + halfHeight + _y);
            start = CGPointMake(0, y);
        }
        else
        {
            CGContextAddLineToPoint(context, t, y + halfHeight + _y);
        }
    }

    CGContextAddLineToPoint(context, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    CGContextAddLineToPoint(context, 0, CGRectGetHeight(bounds));
    CGContextAddLineToPoint(context, start.x, start.y);

    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.00f green:0.70f blue:1.00f alpha:1.00f].CGColor);
    CGContextFillPath(context);
}

@end
