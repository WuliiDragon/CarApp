//
//  Animaition.m
//  CarApp
//
//  Created by 管理员 on 2017/6/4.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "Animaition.h"

@interface Animaition () <CAAnimationDelegate> {
    CALayer *Layer;

    AnimationFinisnedBlock _animationFinishedHolder;
}

@end

@implementation Animaition


+ (instancetype)shareTool {
    return [[Animaition alloc] init];
}


- (void)startAnimationandView:(UIView *)animationView finishBlock:(AnimationFinisnedBlock)completion {
    _animationFinishedHolder = completion;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;//获得keyWindow


    CGPoint fromCenter = [animationView convertPoint:CGPointMake(animationView.frame.size.width * 0.5f, animationView.frame.size.height * 0.5f) toView:keyWindow];
    CGPoint endCenter = CGPointMake(fromCenter.x - 30, fromCenter.y);
//    NSString *str = ((UIButton *)animationView).titleLabel.text;
//    _animationLayer = [CATextLayer layer];
//    _animationLayer.bounds = animationView.bounds;
//    _animationLayer.position = fromCenter;
//    _animationLayer.alignmentMode = kCAAlignmentCenter;//文字对齐方式
//    _animationLayer.wrapped = YES;
//    _animationLayer.contentsScale = [UIScreen mainScreen].scale;
//    _animationLayer.string = str;
//    _animationLayer.backgroundColor = [UIColor whiteColor].CGColor;
//    [keyWindow.layer addSublayer:_animationLayer];





    Layer = [CALayer layer];
    Layer.frame = animationView.frame;

    //设置layer的属性
    //Layer.bounds=CGRectMake(0, 0, 50, 80);
    Layer.backgroundColor = [UIColor yellowColor].CGColor;
    //Layer.position=CGPointMake(50, 50);
    //Layer.anchorPoint=CGPointMake(0,0);
    Layer.cornerRadius = 20;
    [keyWindow.layer addSublayer:Layer];


    CABasicAnimation *anima = [CABasicAnimation animation];
    anima.keyPath = @"position";
    anima.fromValue = [NSValue valueWithCGPoint:fromCenter];
    anima.toValue = [NSValue valueWithCGPoint:endCenter];

    //旋转
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.removedOnCompletion = YES;
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:5 * M_PI];//转5圈
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    //缩放
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimation.removedOnCompletion = NO;
//    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    //透明度
//    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    alphaAnimation.removedOnCompletion = NO;
//    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//    alphaAnimation.toValue = [NSNumber numberWithFloat:1.0];




    //动画组
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[anima, rotateAnimation];
    groups.duration = 1.0;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [Layer addAnimation:groups forKey:@"group"];
}


- (void)animationDidStart:(CAAnimation *)anim {


}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {//结束动画，移除layer
        [Layer removeFromSuperlayer];
        _animationFinishedHolder(YES);
    }
}
@end
