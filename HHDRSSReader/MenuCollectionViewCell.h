//
//  MenuCollectionViewCell.h
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/22/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZhiHuArticle;
IB_DESIGNABLE
@interface MenuCollectionViewCell : UICollectionViewCell

@property(nonatomic,copy,readonly)NSString *articleContent;

-(void)setSplitWidth:(CGFloat)width;
-(void)setArticle:(ZhiHuArticle*)article;
@end
