//
//  TransitionManager.h
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/22/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TransitionType){
    ShowDetail=0,
    BackList
};
@interface TransitionManager : UIPercentDrivenInteractiveTransition<UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign)TransitionType transitionType;
@property(nonatomic,assign)CGPoint currentVelocity;
-(void)setCellRect:(CGRect)rect;
-(void)setCompletSpeed:(CGFloat)completeSpeed;
-(void)setPercentComple:(CGFloat)percent;

@end
