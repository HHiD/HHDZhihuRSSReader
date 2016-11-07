//
//  TransitionManager.m
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/22/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import "TransitionManager.h"
@interface TransitionManager()
{
    CGRect _cellRect;
    id<UIViewControllerContextTransitioning> _transitionContext;
    CAShapeLayer *_maskLayer;
    UIBezierPath *_initaialPath;
    UIBezierPath *_finalPath;
    CGFloat _completeSpeed;
    CGFloat _pausedTime;
    UIViewController *_toVC;
    UIViewController *_fromVC;
    CADisplayLink *_displayLink;
    CGFloat _piceDistance;
    CGFloat _percentComple;
}
@end

@implementation TransitionManager

#pragma mark<Helper Method>
-(void)setCellRect:(CGRect)rect{
    _cellRect=rect;
}
-(CGFloat)completionSpeed{
    return _completeSpeed;
}
-(void)setPercentComple:(CGFloat)percent{
    _percentComple=percent;
}
#pragma mark <AnimationTransitionDelegate>
-(NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

-(void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext{

    _transitionContext=transitionContext;
    UIViewController *fromVC=
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC=
    [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView=[transitionContext containerView];

    _toVC=toVC;
    _fromVC=fromVC;
    [containerView insertSubview:toVC.view aboveSubview:fromVC.view];

    //Create the BezierPath
    UIBezierPath *initailPath=[UIBezierPath bezierPathWithRect:
    (CGRect){.origin={_cellRect.size.width/2,_cellRect.origin.y+_cellRect.size.height/2},
             .size={0.5,0.5}}];
    
    CGFloat radius;
    CGFloat distance;
    if (fromVC.view.frame.size.width>fromVC.view.frame.size.height) {
        distance=fromVC.view.frame.size.width-_cellRect.origin.x;
        radius=distance>_cellRect.origin.x?distance:_cellRect.origin.x+88;
    }else{
        distance=fromVC.view.frame.size.height-_cellRect.origin.y;
        radius=distance>_cellRect.origin.y?distance:_cellRect.origin.y+88;
    }
    radius=radius*2;
    UIBezierPath *finalPath=[UIBezierPath bezierPathWithOvalInRect:CGRectInset(_cellRect,
                                                                               -radius,
                                                                               -radius)];
    _initaialPath=initailPath;
    _finalPath=finalPath;
    //Create a Layer Mask
    _maskLayer=[[CAShapeLayer alloc] init];
    _maskLayer.path=finalPath.CGPath;
    toVC.view.layer.mask=_maskLayer;

    
    [self animateLayer:_maskLayer withCompletion:^{
        
        BOOL isComple=![transitionContext transitionWasCancelled];
        if (!isComple) {
            
            [containerView addSubview:fromVC.view];
            [toVC.view removeFromSuperview];
        }
        [transitionContext completeTransition:isComple];
    }];
}

-(void)startInteractiveTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext{
//    if (_percentComple<=0) {
//        return;
//    }
    _transitionContext=transitionContext;
    [self animateTransition:transitionContext];
    [self pauseTime:[_transitionContext containerView].layer];

}

#pragma mark<LayerAniamtionDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    

    void(^block)() = [anim valueForKeyPath:@"block"];
    if (block){
        block();
    }
}

#pragma mark<InteractiveAnimationTransitionDelegate>
-(void)updateInteractiveTransition:(CGFloat)percentComplete{

//    _percentComple=percentComplete;
    [_transitionContext updateInteractiveTransition:percentComplete];
    [_transitionContext containerView].layer.timeOffset=_pausedTime + [self transitionDuration:_transitionContext]*percentComplete;


}

-(void)finishInteractiveTransition{
    
    

    
    [_transitionContext finishInteractiveTransition];
    [self resumeTime:[_transitionContext containerView].layer];
}

- (void)cancelInteractiveTransition {
    
    CGFloat remainTime=0.2;
    CGFloat frame=60*remainTime;
    _piceDistance=[_transitionContext containerView].layer.timeOffset/frame;
    
    [_transitionContext cancelInteractiveTransition];
    
    if (_displayLink==nil) {
        _displayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(animationTick:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    if (_displayLink) {
        _displayLink.paused=NO;
    }
    //Must Cancel System InteractiveTransition FRIST
    
    
}

-(void)animationTick:(CADisplayLink *)displayLink{
    
    CALayer *maskLayer=[_transitionContext containerView].layer;
    CGFloat timeOffset=maskLayer.timeOffset;
    timeOffset=MAX(0,timeOffset-_piceDistance);
    maskLayer.timeOffset=timeOffset;
    if (timeOffset==0) {
        displayLink.paused=YES;
//        [_transitionContext cancelInteractiveTransition];
        [[_transitionContext containerView ] addSubview:_fromVC.view];
        [_toVC.view removeFromSuperview];
    }

}

#pragma mark<Helper Method>
-(void)setCompletSpeed:(CGFloat)completeSpeed{
    
    _completeSpeed=completeSpeed;
}
-(void)pauseTime:(CALayer*)layer{
    
    layer.speed = 0.0;
    CFTimeInterval pauseTime=[layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.timeOffset = pauseTime;
    _pausedTime=pauseTime;
}

-(void)resumeTime:(CALayer*)layer{
    
    layer.speed=1.0;
    CFTimeInterval pausedTime = layer.timeOffset;
    layer.timeOffset=0.0;
    layer.beginTime=0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime=timeSincePause;
}
- (void)animateLayer:(CALayer *)layer withCompletion:(void(^)())block {
    
    CABasicAnimation *layerAniamtion=[CABasicAnimation animationWithKeyPath:@"path"];
    layerAniamtion.fromValue=(__bridge id)(_initaialPath.CGPath);
    layerAniamtion.toValue=(__bridge id)(_finalPath.CGPath);
    layerAniamtion.duration=[self transitionDuration:nil];
    layerAniamtion.fillMode=kCAFillModeBoth;
    layerAniamtion.removedOnCompletion=YES;
    layerAniamtion.delegate=self;
    [layerAniamtion setValue:block forKey:@"block"];
    [layer addAnimation:layerAniamtion forKey:@"Path"];
    
    /*
     CABasicAnimation *write2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
     write2.fromValue = @0;
     write2.toValue   = @1;
     write2.fillMode = kCAFillModeBoth;
     write2.removedOnCompletion = NO;
     write2.duration = 0.4;
     */
}

@end
