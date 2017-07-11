//
//  ViewController.m
//  UIDynamicAnimation
//
//  Created by Nicholas on 2017/7/10.
//  Copyright © 2017年 nicholas. All rights reserved.
//

#import "ViewController.h"
#import "OfoView.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property (nonatomic, strong) OfoView *ofoView;
@property (nonatomic, strong) OfoView *borderView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.borderView];
    [self.animator addBehavior:self.itemBehavior];
    [self.animator addBehavior:self.collisionBehavior];
    __weak typeof(self) weakSelf = self;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        CGFloat x = motion.gravity.x*3;
        CGFloat y = -motion.gravity.y*3;
        [weakSelf.itemBehavior addLinearVelocity:CGPointMake(x, y) forItem:weakSelf.ofoView];
        
    }];
}

- (UIDynamicItemBehavior *)itemBehavior {
    if (!_itemBehavior) {
        _itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ofoView]];
        _itemBehavior.allowsRotation = YES;
    }
    return _itemBehavior;
}
- (UICollisionBehavior *)collisionBehavior {
    if (!_collisionBehavior) {
        _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.ofoView]];
        _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        [_collisionBehavior addBoundaryWithIdentifier:@"circle" forPath:[UIBezierPath bezierPathWithOvalInRect:self.borderView.bounds]];
    }
    return _collisionBehavior;
}

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.borderView];
    }
    return _animator;
}

- (OfoView *)ofoView {
    if (!_ofoView) {
        
        UIImage *image = [UIImage imageNamed:@"minions_eyes"];
        _ofoView = [[OfoView alloc] initWithFrame:CGRectMake(100, 100, 20, 20)];
        _ofoView.backgroundColor = [UIColor colorWithPatternImage:image];
        _ofoView.collisionBoundsType = UIDynamicItemCollisionBoundsTypeEllipse;
    }
    return _ofoView;
}
- (OfoView *)borderView {
    if (!_borderView) {
        _borderView = [[OfoView alloc] initWithFrame:CGRectMake(50, 50, 300, 300)];
        _borderView.backgroundColor = [UIColor orangeColor];
        _borderView.layer.cornerRadius = CGRectGetHeight(_borderView.bounds)/2.0;
        _borderView.layer.masksToBounds = YES;
        [_borderView addSubview:self.ofoView];
    }
    return _borderView;
}
- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.gyroUpdateInterval = 0.001;
    }
    return _motionManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
