//
//  MenuFlowLayout.m
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/18/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import "MenuFlowLayout.h"

@interface MenuFlowLayout(){
    CGFloat _cellWidth;
}
@property(nonatomic,strong)NSMutableSet *visiblePathSet;
@property(nonatomic,strong)UIDynamicAnimator *animator;
@property(nonatomic,assign)CGFloat latestDelta;
@end

@implementation MenuFlowLayout

-(void)prepareLayout{
    
    if (!self.animator) {
        self.animator=[[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.visiblePathSet=[NSMutableSet new];
    }
    
    CGRect visibleRect=CGRectInset((CGRect){
        .origin = self.collectionView.bounds.origin,
        .size = self.collectionView.frame.size},0, -300);
    
    self.itemSize=(CGSize){self.collectionViewContentSize.width,100};

    if (CGRectGetWidth(self.collectionView.frame)>CGRectGetHeight(self.collectionView.frame)) {
        
        self.itemSize=(CGSize){self.collectionViewContentSize.width/2-3,100};
    }
    
    NSArray *visibleAttr=[super layoutAttributesForElementsInRect:visibleRect];
    
    NSSet *itemsIndexPathInVisibleSet=[NSSet setWithArray:[visibleAttr valueForKeyPath:@"indexPath"]];
    
     NSArray *nolongerSee=[self.animator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(
                                                                                 UIAttachmentBehavior *attributes,
                                                                                 NSDictionary<NSString *,id> * bindings){
     
     BOOL isIn=[itemsIndexPathInVisibleSet member:[attributes items].firstObject]!=nil;
         return isIn;
     }]];
     
     [nolongerSee enumerateObjectsUsingBlock:^(UIAttachmentBehavior *obj, NSUInteger idx, BOOL *  stop) {
     
     [self.animator removeBehavior:obj];
     [self.visiblePathSet removeObject:[obj items].firstObject];
     }];
    
    NSArray *newlyAttributes=[visibleAttr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *attribute, NSDictionary<NSString *,id> *  bindings) {
        
        BOOL isIn=[self.visiblePathSet member:[attribute indexPath]]==nil;
        return isIn;
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
        if (CGRectGetWidth(self.collectionView.frame)>CGRectGetHeight(self.collectionView.frame)) {
            springBehavior.frequency = 0.0f;
        }
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
    
    CGRect oldBounds=self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
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

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSArray *attrs=[self.animator itemsInRect:rect];
    return attrs;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribute=[self.animator
                                                 layoutAttributesForCellAtIndexPath:indexPath];
    return attribute;
}


@end
