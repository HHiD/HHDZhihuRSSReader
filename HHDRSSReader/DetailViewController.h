//
//  DetailViewController.h
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/22/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol DetailViewDelegate <NSObject>
//
//-(void)dismissUpdate:(UIScreenEdgePanGestureRecognizer*)gesture;
//-(void)dismisEnd:(UIScreenEdgePanGestureRecognizer*)gesture;
//
//@end
typedef void (^dismissingStateBegin)(CGFloat percent);
typedef void(^dismissingStateChanged)( UIScreenEdgePanGestureRecognizer* _Nonnull gesture,CGFloat percent);
typedef void(^dismissingEnd)( UIScreenEdgePanGestureRecognizer* _Nonnull gesture,CGFloat percent);

@interface DetailViewController : UIViewController
//@property(nonatomic,assign)id<DetailViewDelegate>delegate;
@property(nonatomic,strong)__nonnull dismissingStateBegin dismissingStateBegin;
@property(nonatomic,strong)__nonnull dismissingStateChanged   dismissingStateChanged;
@property(nonatomic,strong)__nonnull dismissingEnd            dismissingEnd;

-(void)loadArticle:(nonnull NSString*)htmlString;

@end
