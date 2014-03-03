//
//  FIViewController.h
//  FlappyIve_TiP
//
//  Created by Kyle Frost on 2/27/14.
//  Copyright (c) 2014 Today's iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FIViewController : UIViewController

@property (strong, nonatomic) UIView *jony; // Our "bird"
@property (strong, nonatomic) UILabel *scoreLabel; // Label to show score
@property (strong, nonatomic) NSMutableArray *scotts; // Our "pipes"
@property (assign, nonatomic) CGFloat jonyVelocity; // How fast Jony falls
@property (strong, nonatomic) CADisplayLink *displayLink; // Display link timer object
@property (strong, nonatomic) NSTimer *scottTimer; // When Scott should come on screen

@end
