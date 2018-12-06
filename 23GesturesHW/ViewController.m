//
//  ViewController.m
//  23GesturesHW
//
//  Created by Eduard Galchenko on 12/4/18.
//  Copyright © 2018 Eduard Galchenko. All rights reserved.
//

#import "ViewController.h"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView *myView;
@property (assign, nonatomic) CGFloat myViewScale;
@property (assign, nonatomic) CGFloat myViewRotation;
@property (assign, nonatomic) CGPoint centreLocation;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // 1-2. Level "Learner" - Adding Pic on a View
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds)
                                                               - 250, CGRectGetMidY(self.view.bounds) - 250,
                                                               500, 500)];
    
    self.centreLocation = CGPointMake(CGRectGetMidX(self.view.bounds) - 250, CGRectGetMidY(self.view.bounds) - 250);
    
    newView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                               UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    newView.backgroundColor = [UIColor greenColor];
    
    newView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ice_cream_animated.gif"]];

    [self.view addSubview:newView];
    self.myView = newView;
    
    // 3-4. Level "Student" - Moving View by Touch with Animation
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
    UITapGestureRecognizer *doubleTapDoubleTouchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self                        action:@selector(handleDoubleTapDoubleTouch:)];
    doubleTapDoubleTouchGesture.numberOfTapsRequired = 2;
    doubleTapDoubleTouchGesture.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleTapDoubleTouchGesture];
    
    // 5-6-7. Level "Master" - Swipes
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlRightSwipeGesture:)];
    rightSwipeGesture.delegate = self;
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
    
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlLeftSwipeGesture:)];
    leftSwipeGesture.delegate = self;
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    
    // 8. Level "SuperMan" - Picture Zoom with Pinch
    UIPinchGestureRecognizer *pinchGuesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlPinch:)];
    pinchGuesture.delegate = self;
    [self.view addGestureRecognizer:pinchGuesture];
    
    // 9. Level "SuperMan" - Turn Picture with Rotation
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handlRotaion:)];
    rotationGesture.delegate = self;
    [self.view addGestureRecognizer:rotationGesture];
}


#pragma mark - Gestures

// 3-4. Level "Student" - Moving View by Touch with Animation
- (void) handlTap:(UITapGestureRecognizer*) tapGesture {
    
    NSLog(@"Tap: %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
    
    CGPoint tapLocation = [tapGesture locationInView:self.view];
    
    [UIView animateWithDuration:M_PI animations:^{
        
        self.myView.center = tapLocation;
    }];
}

- (void) handleDoubleTap:(UITapGestureRecognizer*) tapGesture {
    
    //[self.myView.layer removeAllAnimations];
    [self.myView.layer removeAnimationForKey:@"swipeRotations"];
}

- (void) handleDoubleTapDoubleTouch:(UITapGestureRecognizer*) tapGesture {
    
    NSLog(@"Double Tap Double Touch: %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
}

// Swipe

- (void) handlRightSwipeGesture:(UISwipeGestureRecognizer*) rightSwipe {
    
    NSLog(@"Right swipe");

    [self rotateView:self.myView duration:25 rotations:360 repeat:0];
}

- (void) handlLeftSwipeGesture:(UISwipeGestureRecognizer*) leftSwipe {
    
    NSLog(@"Left swipe");
    
    [self rotateView:self.myView duration:25 rotations:-360 repeat:0];
}

// 8. Level "SuperMan" - Picture Zoom with Pinch
- (void) handlPinch:(UIPinchGestureRecognizer*) pinchGuesture {
    
    if (pinchGuesture.state == UIGestureRecognizerStateBegan) {
        
        self.myViewScale = 1.f;
    }
    
    CGFloat newScale = 1.f + pinchGuesture.scale - self.myViewScale;
    
    CGAffineTransform currentTransform = self.myView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
    
    self.myView.transform = newTransform;
    
    self.myViewScale = pinchGuesture.scale;
}

// 9. Level "SuperMan" - Turn Picture with Rotation
- (void) handlRotaion:(UIRotationGestureRecognizer*) rotationGesture {
    
    NSLog(@"handlRotaion: %1.3f", rotationGesture.rotation);
    
    if (rotationGesture.state == UIGestureRecognizerStateBegan) {
        
        self.myViewRotation = 0;
    }
    
    CGFloat newRotaion = rotationGesture.rotation - self.myViewRotation;
    
    CGAffineTransform currentTransform = self.myView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, newRotaion);
    
    self.myView.transform = newTransform;
    
    self.myViewRotation = rotationGesture.rotation;
}

#pragma mark - Additional methods

- (void) rotateView:(UIView*) view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat {
    
    CABasicAnimation* newRotation;
    
    newRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    newRotation.toValue = [NSNumber numberWithFloat: DEGREES_TO_RADIANS(rotations)];
    newRotation.duration = duration;
    newRotation.cumulative = YES;
    newRotation.repeatCount = repeat;
    
    [view.layer addAnimation:newRotation forKey:@"swipeRotations"];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

@end
