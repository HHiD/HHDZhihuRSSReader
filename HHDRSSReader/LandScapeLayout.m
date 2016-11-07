//
//  LandScapeLayout.m
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/26/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import "LandScapeLayout.h"

@interface LandScapeLayout()
{
    NSInteger _itemCount;
}
@property(nonatomic,strong)UIDynamicAnimator    *animator;
@property(nonatomic,strong)NSMutableSet         *visiblePathSet;
@property(nonatomic,assign)CGFloat latestDelta;

@end

@implementation LandScapeLayout


-(void)prepareLayout{
    
    if (!self.animator) {
        self.animator=[[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.visiblePathSet=[NSMutableSet new];
    }
//    CGRect visibleRect=CGRectInset((CGRect){
//        .origin = self.collectionView.frame.origin,
//        .size=self.collectionView.frame.size
//    }, 0, -300);
//    NSLog(@"frame :%@",NSStringFromCGRect(self.collectionView.frame));
//    NSLog(@"bounds  :%@",NSStringFromCGRect(self.collectionView.bounds));
//    NSLog(@"visibleRect  :%@",NSStringFromCGRect(self.collectionView.bounds));
    _itemCount=[self.collectionView numberOfItemsInSection:0]/2;
    

}

-(void)dynamicProcess:(NSArray *)originAttributes{
    
    NSSet *visibleAttributes=[NSSet setWithArray:[originAttributes valueForKeyPath:@"indexPath"]];
    
    NSArray *nolongerSeeAttr=[self.animator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior  *evaluatedObject, NSDictionary<NSString *,id> * __nullable bindings) {
        
        BOOL isIn=[visibleAttributes member:[evaluatedObject items].firstObject]!=nil;
        
        return isIn;
    }]];
    
    [nolongerSeeAttr enumerateObjectsUsingBlock:^(UIAttachmentBehavior *obj, NSUInteger idx, BOOL * stop) {
        [self.animator removeBehavior:obj];
        [self.visiblePathSet removeObject:[obj items].firstObject];
    }];
    
    NSArray *newlyAttributes=[originAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary<NSString *,id> * bindings) {
        
        BOOL isIn=[self.visiblePathSet member:[evaluatedObject indexPath]]!=nil;
        
        return !isIn;
    }]];
    
    CGPoint touchLocation=[self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    [newlyAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL * stop) {
        
        
        CGPoint center=item.center;
        UIAttachmentBehavior *springBehavior=[[UIAttachmentBehavior alloc]
                                              initWithItem:item
                                              attachedToAnchor:center];
        springBehavior.length = 0.0f;
        springBehavior.damping = 0.8f;
        springBehavior.frequency = 1.0f;
        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehavior.anchorPoint.y);
            CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehavior.anchorPoint.x);
            CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
            
            if (self.latestDelta < 0) {
                center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
            }
            else {
                center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
            }
            item.center = center;
        }
        [self.animator addBehavior:springBehavior];
        [self.visiblePathSet addObject:item.indexPath];
    }];
}


-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{

    if (CGRectEqualToRect(self.collectionView.bounds, newBounds)) {

        [self.animator removeAllBehaviors];
        [self.visiblePathSet removeAllObjects];
        return YES;
    }
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    self.latestDelta = delta;
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.animator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        
        CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
        
        UICollectionViewLayoutAttributes *item =
        (UICollectionViewLayoutAttributes*)[springBehaviour.items firstObject];
        CGPoint center = item.center;
        if (delta < 0) {
            center.y += MAX(delta, delta*scrollResistance);
        }
        else {
            center.y += MIN(delta, delta*scrollResistance);
        }
        item.center = center;
        
        [self.animator updateItemUsingCurrentState:item];
    }];
    return NO;
}


-(CGSize)collectionViewContentSize{
    
    return self.collectionView.frame.size;
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
//    NSArray *attrs=[self.animator itemsInRect:rect];
//    
//    if (attrs.count>0) {
//
//        NSLog(@"%@",attrs);
//    }
    
    /*
     
     需要计算出来一个合适的空间，再用这个空间来计算存在这个空间里的每个Cell的attributes
     
     */
    
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < _itemCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    return attributes;
    
    
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attr=[self.animator layoutAttributesForCellAtIndexPath:indexPath];
    CGFloat width=self.collectionView.bounds.size.width;
    CGFloat height=100;
    
    NSInteger line=indexPath.row/2;
    NSInteger row=indexPath.row;
    attr.size=(CGSize){width/2-10,height};
    attr.center=CGPointMake(width/4+width/2*line,
                            100*(row+1)/2+height/2*row);

    
    return attr;
}


@end
