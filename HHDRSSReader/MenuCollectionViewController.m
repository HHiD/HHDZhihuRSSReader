//
//  MenuCollectionViewController.m
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/17/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import "MenuCollectionViewController.h"
#import "RSSDataFetching.h"
#import "TransitionManager.h"
#import "DetailViewController.h"
#import "MenuCollectionViewCell.h"
#import "ZhiHuArticle.h"
#import "MenuFlowLayout.h"
#import "LandScapeLayout.h"
#import "HHDZhiHuDBHelper.h"
@interface MenuCollectionViewController ()<UIViewControllerTransitioningDelegate>
{
    UIView *_header;
    TransitionManager *_transitionManager;
    NSArray *_dataArray;
    DetailViewController *_detailVC;
}
@end

@implementation MenuCollectionViewController

static NSString * const reuseIdentifier = @"myCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _transitionManager=[[TransitionManager alloc] init];
    _header=({
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,40)];
        view.backgroundColor=[UIColor colorWithRed:0.0/255 green:160.0/255 blue:233.0/255 alpha:1.0];
        [self.view addSubview:view];
        view;
    });
    
    self.collectionView.frame=(CGRect){0,40,self.view.frame.size.width,self.view.frame.size.height-40};
    self.collectionView.backgroundColor =[UIColor colorWithRed:213.0/255 green:221.0/255
                                                          blue:233.0/255 alpha:1.0];
    
    /*HHDZhiHuDBHelper *dbHelper=[[HHDZhiHuDBHelper alloc] init];
    _dataArray=[dbHelper getArticle];
    [self.collectionView reloadData];*/
    
    //FetchData
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [RSSDataFetching fetchData:^(NSMutableArray *result) {
            _dataArray=result;//[dbHelper getArticle];
//            NSArray *array=[NSArray arrayWithArray:result];
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSMutableArray *indexArr=[NSMutableArray array];
//                for (int i=0; i<array.count; i++) {
//                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
//                    [indexArr addObject:indexPath];
//                }
//                [self.collectionView insertItemsAtIndexPaths:indexArr];
                [self.collectionView reloadData];
            });
        }];
    });
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _dataArray.count>0?_dataArray.count:0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor whiteColor];
    CGFloat width=self.view.frame.size.width;
    CGFloat height=self.view.frame.size.height;
    width=width<height?width:height;
    
    [cell setSplitWidth:width];
    ZhiHuArticle *article=_dataArray[indexPath.row];
    [cell setArticle:article];

    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(nonnull UICollectionView *)collectionView
didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{

    MenuCollectionViewCell *cell=
    (MenuCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [_detailVC loadArticle:cell.articleContent];
    CGRect cellRect=[self.collectionView cellForItemAtIndexPath:indexPath].frame;
    CGRect cellRectSet=(CGRect){cellRect.origin.x,cellRect.origin.y-self.collectionView.contentOffset.y,.size=cellRect.size};
    [_transitionManager setCellRect:cellRectSet];
}


-(void)prepareForSegue:(nonnull UIStoryboardSegue *)segue sender:(nullable id)sender{
    _detailVC=segue.destinationViewController;
    _detailVC.transitioningDelegate=self;

    __weak MenuCollectionViewController*weakSelf=self;
    _detailVC.dismissingStateBegin=^(CGFloat percent){
        [weakSelf gestureStateBegin:percent];
    };
    _detailVC.dismissingStateChanged=^(UIScreenEdgePanGestureRecognizer*gesture,CGFloat percent){
        [weakSelf gestureStateUpdate:gesture Percent:percent];
    };
    _detailVC.dismissingEnd=^(UIScreenEdgePanGestureRecognizer*gesture,CGFloat percent){
        [weakSelf gestureStateEnd:gesture Percent:percent];
    };
}
#pragma mark<DetailStateHandle>

-(void)gestureStateBegin:(CGFloat)percent{
    [_transitionManager setPercentComple:percent];
}

-(void)gestureStateUpdate:(UIScreenEdgePanGestureRecognizer*)gesture Percent:(CGFloat)percent{
//    CGPoint location=[gesture locationInView:gesture.view.window];
    CGPoint velocity=[gesture velocityInView:gesture.view.window];
//    CGFloat persent=location.x/self.view.bounds.size.width;

    _transitionManager.currentVelocity=velocity;
    [_transitionManager updateInteractiveTransition:percent];
    
    
}

-(void)gestureStateEnd:(UIScreenEdgePanGestureRecognizer*)gesture Percent:(CGFloat)percent{
//    CGPoint location=[gesture locationInView:gesture.view.window];
    CGPoint velocity=[gesture velocityInView:gesture.view.window];
//    CGPoint currentPosition=[gesture locationInView:gesture.view.window];
//    CGFloat persent=location.x/self.view.bounds.size.width;
    _transitionManager.currentVelocity=velocity;
    if (percent>0.2/*velocity.x>1&&currentPosition.x>50*/) {
        [_transitionManager setCompletSpeed:(1.0-percent)];
        [_transitionManager finishInteractiveTransition];
    }
    else{
        [_transitionManager setCompletSpeed:percent];
        [_transitionManager cancelInteractiveTransition];
    }
}


#pragma mark <Orentation>
-(void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection
             withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        _header.frame=(CGRect){0, 0, self.view.frame.size.width, 40};
        if (newCollection.verticalSizeClass==UIUserInterfaceSizeClassCompact) {
            NSLog(@"LandScape   :%@",NSStringFromCGRect(self.view.frame));
            
            self.collectionView.frame=(CGRect){
                0,
                40,
                self.view.frame.size.width,
                self.view.frame.size.height-40};
        }else{
            self.collectionView.frame=(CGRect){
                0,
                40,
                self.view.frame.size.width,
                self.view.frame.size.height-40};
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.collectionView reloadData];
    }];
}

#pragma mark <UIViewCOntrollerTransitioningDelegate>

-(nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(nonnull UIViewController *)presented presentingController:(nonnull UIViewController *)presenting sourceController:(nonnull UIViewController *)source{
    _transitionManager.transitionType=ShowDetail;
    return _transitionManager;
}

-(nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(nonnull UIViewController *)dismissed{
    return _transitionManager;
}
-(nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(nonnull id<UIViewControllerAnimatedTransitioning>)animator{

    return nil;
}
-(nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(nonnull id<UIViewControllerAnimatedTransitioning>)animator{
    return _transitionManager;
}



/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
