//
//  FIViewController.h
//  FlappyIve_TiP
//
//  Created by Kyle Frost on 2/27/14.
//  Copyright (c) 2014 Today's iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FIViewController : UIViewController

@property (strong, nonatomic) UIView *jony;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) NSMutableArray *scotts;

@property (assign, nonatomic) CGFloat jonyVelocity;

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (strong, nonatomic) NSTimer *scottTimer;

@end
