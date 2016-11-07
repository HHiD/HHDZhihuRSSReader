//
//  DetailViewController.m
//  HHDRSSReader
//
//  Created by 黄红迪 on 6/22/15.
//  Copyright © 2015 HHDemond. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UIScrollViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>
{
//    UIWebView *_webView;
    __weak IBOutlet UIWebView *_webView;
    CGPoint _beginPoint;
    UIView *_header;
    CGPoint _currentPoint;
}


@end

@implementation DetailViewController

-(void)awakeFromNib{
  
    
//    _webView=({
//        UIWebView *webview=[[UIWebView alloc] init];
//        webview.frame=(CGRect){0,40,.size={self.view.bounds.size.width,self.view.bounds.size.height-40}};
//        webview.backgroundColor=[UIColor whiteColor];
//        webview.delegate=self;
//        webview.scrollView.delegate=self;
//        [webview.scrollView.panGestureRecognizer addTarget:self action:@selector(handlPanGesture:)];
//        [self.view addSubview:webview];
//        webview;
//    });

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _header=({
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,40)];
        view.backgroundColor=[UIColor colorWithRed:0.0/255 green:160.0/255 blue:233.0/255 alpha:1.0];
        [self.view addSubview:view];
        view;
    });
    
    
    /*UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.delegate= self;
//    tapGesture.cancelsTouchesInView =NO;
    [_webView addGestureRecognizer:tapGesture];
    _webView.scrollView.delegate=self;
    [_webView.scrollView.panGestureRecognizer addTarget:self action:@selector(handlPanGesture:)];*/
    

    UIScreenEdgePanGestureRecognizer *panGesture=
    [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handlPanGesture:)];
    panGesture.edges=UIRectEdgeLeft;
    panGesture.delegate=self;
    [_webView addGestureRecognizer:panGesture];

}
#pragma mark<GestureDelegate>
-(BOOL)gestureRecognizer:(nonnull UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void)loadArticle:(nonnull NSString*)htmlString{
    
    [_webView loadHTMLString:[self mergeString:htmlString] baseURL:nil];
}
-(NSString*)mergeString:(NSString*)string{
    
    int width=_webView.scrollView.contentSize.width-30;
    NSMutableString *mergedString=[NSMutableString stringWithString:string];
    [mergedString insertString:[NSString stringWithFormat:@"<body class=\"%@\">",@"imageStyle"]atIndex:0];
    [mergedString insertString:@"</body>" atIndex:mergedString.length];
    [mergedString insertString:[NSString stringWithFormat:@"<head><style>.imageStyle img{max-width:%d;_width:expression(this.width > %d ? \"%d\" : this.width);}.invisible{visibility = hidden;display:none;} </style></head>",width,width,width] atIndex:0];
    [mergedString insertString:@"<html>" atIndex:0];
    [mergedString insertString:@"</html>" atIndex:mergedString.length];
    
    
    
    return mergedString;
}
//-(void)handleTapGesture:(UITapGestureRecognizer*)tapGesture{
//    NSLog(@"Tap");
//}
//
//-(void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
//    NSLog(@"Ok");
//}

-(void)handlPanGesture:(UIScreenEdgePanGestureRecognizer*)gesture{

    CGPoint panLocation=[gesture locationInView:gesture.view];
    CGFloat distance=panLocation.x-_beginPoint.x;
    CGFloat percent=MAX(0, MIN(1.0, distance/self.view.frame.size.width));
    
    if (gesture.state==UIGestureRecognizerStateBegan) {
        
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    else if (gesture.state==UIGestureRecognizerStateChanged) {
        
        self.dismissingStateChanged(gesture,percent);
        return;
    }
    else if(gesture.state==UIGestureRecognizerStateEnded){
        
        self.dismissingEnd(gesture,percent);
        return;
    }
    
//    if ([self isInScale:panLocation]) {

/*        if (CGPointEqualToPoint(_beginPoint, panLocation)) {

            [self dismissViewControllerAnimated:YES completion:^{}];
        }else{
            self.dismissingStateChanged(gesture,percent);
            return;
        }
        if(gesture.state==UIGestureRecognizerStateEnded){
            
            self.dismissingEnd(gesture,percent);
            return;
        }
*/
//    }
}

-(BOOL)isInScale:(CGPoint)position{

    BOOL isIn=YES;
    if (CGPointEqualToPoint(position, _beginPoint)) {
        NSLog(@"BeginPoint ;%@,CurrentPoint :%@",
              NSStringFromCGPoint(_beginPoint),NSStringFromCGPoint(position));
    }
    if (position.y!=_beginPoint.y) {
        isIn=NO;
    }



//    CGFloat x=    tanf(8*M_PI/180);
//    CGFloat bottomLength=self.view.frame.size.width-_beginPoint.x;
//    CGFloat scaleHeight=x*bottomLength;
//    CGFloat upLength=MAX(0,scaleHeight-_beginPoint.y);
//    CGFloat downLength=MIN(_webView.scrollView.contentSize.height, _beginPoint.y+scaleHeight);
//    isIn=(location.y>upLength&&location.y<downLength);
    NSLog(@"%@",isIn?@"YES":@"NO");
    return isIn;
}

#pragma mark<ScrollViewDelegate>

-(void)scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView{
    _beginPoint =[scrollView.panGestureRecognizer locationInView:_webView.scrollView];
}

-(void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView{
    
}
#pragma mark<UIWebVieDelegate>
-(void)webViewDidStartLoad:(nonnull UIWebView *)webView{
    
}

-(void)webViewDidFinishLoad:(nonnull UIWebView *)webView{

    CGSize originalSize =webView.scrollView.contentSize;
    webView.scrollView.contentSize=(CGSize){originalSize.width-100,originalSize.height};

}

#pragma mark<Transition>
-(void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator{

    CGFloat heigth=self.view.frame.size.height;
    CGFloat width=self.view.frame.size.width;
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    if (newCollection.verticalSizeClass==UIUserInterfaceSizeClassCompact) {


        CGFloat theWidth=heigth>width?heigth:width;
        CGFloat theHeigth=heigth<width?heigth:width;
        NSLog(@"Width :%f Height :%f",theWidth,theHeigth);
        _header.frame=(CGRect){0,0,.size={theWidth,40}};
//        _webView.frame=(CGRect){0,40,.size={theWidth,theHeigth-40}};

//        CGSize originalSize =_webView.scrollView.contentSize;
//        _webView.scrollView.frame=CGRectMake(0, 0, theWidth, theHeigth);
//        _webView.scrollView.contentSize=CGSizeMake(theWidth, originalSize.height);
    }else{
        
        CGFloat theWidth=heigth<width?heigth:width;
        CGFloat theHeigth=heigth>width?heigth:width;
        NSLog(@"Width :%f Height :%f",theWidth,theHeigth);
        _header.frame=(CGRect){0,0,.size={theWidth,40}};
//        _webView.frame=(CGRect){0,40,.size={theWidth,theHeigth-40}};

    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
