//
//  ETActivityIndicatorView.m
//  ETActivityIndicatorView
//
//  Created by Eugene Trapeznikov on 5/24/13.
//  Copyright (c) 2013 Eugene Trapeznikov. All rights reserved.
//

#import "ETActivityIndicatorView.h"

#import <QuartzCore/QuartzCore.h>

@implementation ETActivityIndicatorView

BOOL isAnimating = NO;

UIImageView *circleImage;

NSTimer *circleDelay; // for creating different circles

int circleNumber;

int maxCircleNumber = 5; //maximum number of circles

float circleSize; //depends on frame.size

float radius; //depends on frame.size

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)startAnimating{
    
    if (!isAnimating){
    
        isAnimating = YES;
        
        circleNumber = 0;
        
        //calculate radius and cicrlce size
        radius = self.frame.size.width/2;
        
        if (self.frame.size.width > self.frame.size.height){
            radius = self.frame.size.height/2;
        }
        
        circleSize = 15*radius/55;
        
        //add circles
        circleDelay = [NSTimer scheduledTimerWithTimeInterval: 0.20 target: self
                                                 selector: @selector(nextCircle) userInfo: nil repeats: YES];
    }
}

-(void)nextCircle{
    if (circleNumber<maxCircleNumber){
        
        circleNumber ++;
        
        UIImageView *circleImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-circleSize)/2, self.frame.size.height-circleSize, circleSize, circleSize)];
        circleImage.image = [UIImage imageNamed:@"circle"];
        circleImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:circleImage];
        
        CGMutablePathRef circlePath = CGPathCreateMutable();
        CGPathMoveToPoint(circlePath, NULL, self.frame.size.width/2, self.frame.size.height-circleSize/2);
        
        CGPathAddArc(circlePath, NULL, self.frame.size.width/2, self.frame.size.height/2, radius-15/2, M_PI_2, -M_PI_2*3, NO);
        
        CAKeyframeAnimation *circleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        circleAnimation.duration = 1.5;
        circleAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.15f :0.60f :0.85f :0.4f];
        [circleAnimation setCalculationMode:kCAAnimationPaced];
        circleAnimation.path = circlePath;
        circleAnimation.repeatCount = HUGE_VALF;
        [circleImage.layer addAnimation:circleAnimation forKey:@"circleAnimation"];
        
        CGPathRelease(circlePath);
        
    } else {
        [circleDelay invalidate];
    }
}


-(void)stopAnimating{
    isAnimating = NO;
    
    for (UIView *v in self.subviews){
        [v removeFromSuperview];
    }
}

-(BOOL)isAnimating{
    return isAnimating;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end