//
//  FIViewController.m
//  FlappyIve_TiP
//
//  Created by Kyle Frost on 2/27/14.
//  Copyright (c) 2014 Today's iPhone. All rights reserved.
//

#import "FIViewController.h"

#define JonyStartingFrame CGRectMake(100, CGRectGetMidY([[self view] frame])-25, 50, 50)
#define ScottDelay 1.8
#define JonyAcceleration 15
#define HorizVelocity -120
#define ScottHeight 130
#define TopBottomPadding 50
#define TapJonyVelocity -5.5

@interface FIViewController ()

@end

@implementation FIViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    [background setImage:[UIImage imageNamed:@"background.png"]];
    [background setContentMode:UIViewContentModeScaleAspectFill];
    [[self view] addSubview:background];
    
    UIImageView *jonyFlapper = [[UIImageView alloc] initWithFrame:JonyStartingFrame];
    [jonyFlapper setContentMode:UIViewContentModeScaleAspectFit];
    
    NSArray *birdArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"jony0.png"], [UIImage imageNamed:@"jony1.png"], [UIImage imageNamed:@"jony2.png"], [UIImage imageNamed:@"jony3.png"], nil];
    
    [jonyFlapper setAnimationImages:birdArray];
    [jonyFlapper setAnimationDuration:0.7];
    [jonyFlapper startAnimating];
    [[self view] addSubview:jonyFlapper];
    [self setJony:jonyFlapper];
    
    UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth([[self view] frame]), 80)];
    [score setTextAlignment:NSTextAlignmentCenter];
    [score setFont:[UIFont systemFontOfSize:80.0f]];
    [[self view] addSubview:score];
    [self setScoreLabel:score];
    
    [self setScotts:[NSMutableArray array]];
    
    [self startTimers];
    
}


-(void)startTimers {
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self setDisplayLink:link];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ScottDelay target:self selector:@selector(addNewBar:) userInfo:nil repeats:YES];
    [self setScottTimer:timer];
    
}


-(void)tick:(CADisplayLink *)link {
    
    self.jonyVelocity += [link duration]*JonyAcceleration;
    
    [[self jony] setFrame:CGRectOffset([[self jony] frame], 0, [self jonyVelocity])];
    
    UIView *removeScott = nil;
    for (UIView *scott in [self scotts]) {
        [scott setFrame:CGRectOffset([scott frame], [link duration]*HorizVelocity, 0)];
        
        if (CGRectIntersectsRect([[self jony] frame], [scott frame])) {
            [self failed];
            break;
        }
        
        if ([scott tag] == 0 && CGRectGetMinX([scott frame]) < CGRectGetMinX([[self jony] frame])) {
            [scott setTag:1];
            [self incrementCount];
        }
        
        if (CGRectGetMaxX([scott frame]) < 0)
            removeScott = scott;
    }
    if (removeScott) {
        [removeScott removeFromSuperview];
        [[self scotts] removeObject:removeScott];
    }
    
    if (CGRectGetMaxY([[self jony] frame]) >= CGRectGetHeight([[self view] frame])) {
        [self failed];
    }
    
}

-(void)incrementCount {
    
    NSInteger currentScore = [[[[self scoreLabel] attributedText] string] intValue];
    NSDictionary *scoreLabelAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSAttributedString *attributes = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i", currentScore+1] attributes:scoreLabelAttributes];
    
    [[self scoreLabel] setAttributedText:attributes];
    
}


-(void)addNewBar:(NSTimer *)timer {
    
    NSInteger possibleScottRange = CGRectGetHeight([[self view] frame])-ScottHeight-2*TopBottomPadding;
    NSInteger scottTop = arc4random()%possibleScottRange + TopBottomPadding;
    
    UIImageView *newTopScott = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth([[self view] frame]), 0, 50, scottTop)];
    [newTopScott setImage:[[UIImage imageNamed:@"scott_upside_down.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 20, 0)]];
    [newTopScott setTag:1];
    
    CGFloat scottBottom = scottTop+ScottHeight;
    UIImageView *newBottomScott = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth([[self view] frame]), scottBottom, 50, CGRectGetHeight([[self view] frame])-scottBottom)];
    [newBottomScott setImage:[[UIImage imageNamed:@"scott.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 0, 0, 0)]];
    
    [[self view] insertSubview:newTopScott belowSubview:[self scoreLabel]];
    [[self view] insertSubview:newBottomScott belowSubview:[self scoreLabel]];
    
    [[self scotts] addObject:newTopScott];
    [[self scotts] addObject:newBottomScott];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self setJonyVelocity:TapJonyVelocity];
    
}

-(void)failed {
    
    [[self scottTimer] invalidate];
    [self setScottTimer:nil];
    
    [[self displayLink] invalidate];
    [self setDisplayLink:nil];
    
    [self performSelector:@selector(startOver) withObject:nil afterDelay:1];
    
}

-(void)startOver {
    
    [[self scoreLabel] setAttributedText:nil];
    
    for (UIView *scott in [self scotts]) {
        [scott removeFromSuperview];
    }
    [[self scotts] removeAllObjects];
    
    [[self jony] setFrame:JonyStartingFrame];
    
    [self setJonyVelocity:0];
    
    [self startTimers];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
