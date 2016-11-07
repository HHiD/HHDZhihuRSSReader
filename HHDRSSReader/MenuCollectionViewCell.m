//
//  MenuCollectionViewCell.m
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/22/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import "MenuCollectionViewCell.h"
#import "ZhiHuArticle.h"
#define CELL_HEIGHT self.frame.size.height
#define CELL_WIDTH  self.frame.size.width
@interface MenuCollectionViewCell()
{
    CGFloat _width;
    CALayer *_splitLayer;
    ZhiHuArticle *_article;
}
@property (strong, nonatomic)  UILabel *authorLabel;
@property (strong, nonatomic)  UILabel *titlLable;
@end
@implementation MenuCollectionViewCell

-(void)awakeFromNib{
    self.authorLabel=({
        UILabel *lable=[[UILabel alloc] init];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.font=[UIFont systemFontOfSize:15];
        lable.center=(CGPoint){self.bounds.size.width/10-3,self.center.y};
        lable.bounds=(CGRect){0,0,100,30};
        [self addSubview:lable];
        lable;
    });
    
    self.titlLable=({
        UILabel *label=[[UILabel alloc] init];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=[UIColor blackColor];
        label.bounds=(CGRect){0,0,self.bounds.size.width/6,self.frame.size.height-10};
        label.center=(CGPoint){self.bounds.size.width/10+self.authorLabel.frame.size.width/2+label.frame.size.width/2+20,self.center.y};
        label.numberOfLines=3;
        [self addSubview:label];
        label;
    });
}


//DataSetting
-(void)setSplitWidth:(CGFloat)width{
    
    _width=width;
    [self adjustWidth:width];
}
-(void)setArticle:(ZhiHuArticle*)article{
    
    if (article!=nil) {
        _article=article;
        [self setAuthor:_article.author andTitle:_article.title];
    }
}

-(void)setAuthor:(NSString*)author andTitle:(NSString*)title{
    
    self.authorLabel.text=author;
    self.titlLable.text=title;
}

-(NSString*)articleContent{
    return _article.content;
}

-(void)adjustWidth:(CGFloat)width{
    
    [self suitableWidth];
    self.titlLable.center=(CGPoint){
        _width*2/6+self.titlLable.frame.size.width/2+16,
        self.titlLable.center.y};
}

-(void)suitableWidth{

    CGFloat selfWidth=self.frame.size.width;
    CGFloat length=self.titlLable.frame.size.width/2+self.titlLable.center.x;
    if (length>selfWidth) {
        CGFloat suitableWidth= (selfWidth-self.titlLable.center.x)*2;
        self.titlLable.bounds=(CGRect){0,0,suitableWidth,self.frame.size.height-10};
        
    }else{
        self.titlLable.bounds=(CGRect){0,0,self.bounds.size.width*3/5,self.frame.size.height-10};
    }

}

//Graphic
-(void)drawRect:(CGRect)rect{
//    _splitLayer=[self getlayer];
    [self.contentView.layer addSublayer:[self getlayer]];
}

-(CAShapeLayer*)getlayer{
    
    CAShapeLayer *layer=[[CAShapeLayer alloc] init];
    layer.path=[self getPath];
    layer.strokeColor=[UIColor grayColor].CGColor;
    layer.lineWidth=0.88f;
    return layer;
}

-(CGPathRef)getPath{

    CGFloat splitWidth=_width*2/6;
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, splitWidth, 8);
    CGPathAddLineToPoint(path, NULL, splitWidth, CELL_HEIGHT-8);
    
    return path;
}

@end
