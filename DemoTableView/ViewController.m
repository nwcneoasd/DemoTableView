//
//  ViewController.m
//  DemoTableView
//
//  Created by px on 14-12-26.
//  Copyright (c) 2014年 px. All rights reserved.
//

#import "ViewController.h"

#define UPDONTLOAD @"上拉可以查看第二页"
#define UPLOAD @"松开查看第二页"
#define DOWNDONTLOAD @"下拉可以查看第一页"
#define DOWNLOAD @"松开查看第一页"
@interface ViewController ()<UIScrollViewDelegate>{
    BOOL ISUP; //判断是否在上
    float  contentInset; //初始ContentInset;
    float  HeightForSecton1; //第一个区的高
    float  HeightForAlertView;//中间过渡框的高度
    float  HeightForSecton2;//第二个区的高
    
    float whenDown;//设置拖动到什么时候 页面往下翻页
    float whenUp;//设置拖动到什么时候 页面往上翻页
    
}
@property (strong, nonatomic) IBOutlet UILabel *label;//过渡框提示文字
@property (strong, nonatomic) IBOutlet UIImageView *IMG;//过渡框箭头
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ISUP=YES;
    self.scrollView.alwaysBounceVertical=YES;//scrollview无论什么情况都可以上下滑动 section比较小的时候无法滑动。
    
    self.scrollView.frame=self.view.bounds;
    contentInset =self.scrollView.contentInset.top;
    
    [self setFloat];//设置基础数值
}
-(void)setFloat{
    self.scrollView.contentInset=UIEdgeInsetsMake(contentInset, 0, 0, 0);
    HeightForSecton1=700;  //这里这是第一页的高度
    HeightForAlertView=50;//这里设置过渡提醒页的高度
    HeightForSecton2=850;//这里设置第二页的高度
    whenDown=HeightForSecton1-self.view.frame.size.height+HeightForAlertView;//当前是第一页。这里设置的是当过渡框完全显示时 滑动到下一页。可具体修改
    
    whenUp=HeightForSecton1;//当前是第二页。这里设置的是当过渡框完全显示时 滑动到上一页。  可具体修改
    [self.scrollView setContentSize:CGSizeMake(0, HeightForSecton1)];//一开始是第一页,所以只用显示第一页的滑动大小
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
   //   NSLog(@"contentInset=%F",scrollView.contentInset.top);
   //   NSLog(@"contentOffset=%f",scrollView.contentOffset.y);
    
    if (ISUP==YES) {
        //当前是第一页时
        if (scrollView.contentOffset.y>=whenDown) {
            self.label.text=UPLOAD;
            
        }else{
            self.label.text=UPDONTLOAD;
        }
    }else{
        //当前是第二页时
        if (scrollView.contentOffset.y<=whenUp) {
            self.label.text=DOWNLOAD;
        }else{
            self.label.text=DOWNDONTLOAD;
        }
    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
    if (ISUP==YES) {
        //当前是第一页时
        
        if (scrollView.contentOffset.y>=whenDown) {
            //下滑
            //此处动画有2个   第一个为过渡动画  不设置第一个动画的话 将会有一个闪屏的问题。
            //第一个动画将contentInset 设置到当前contentOffset.y
            
            [UIView animateWithDuration:0.01 animations:^{
                //这里是第一个动画
                scrollView.contentInset= UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            } completion:^(BOOL finished) {
                //第一个动画完成后执行第二个动画
            [UIView animateWithDuration:0.4 animations:^{
                //这里是第二个动画
                scrollView.contentInset= UIEdgeInsetsMake(-(HeightForSecton1+HeightForAlertView)-contentInset, 0, 0, 0);
                //将contentInset 设置到第二页
            } completion:^(BOOL finished) {
                
                //第二个动画完成后 设置滑动范围:注意 此处的滑动范围为第一页面+过渡页面+第二页
                
                 [self.scrollView setContentSize:CGSizeMake(0, HeightForSecton1+HeightForSecton2+HeightForAlertView)];
                ISUP=NO;
                
            }];
            
              }];

        }
        
    }else{
        //当前是第二页时
        //同上。
        
        if (scrollView.contentOffset.y<=whenUp) {
            [UIView animateWithDuration:0.01 animations:^{
                  scrollView.contentInset= UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            } completion:^(BOOL finished) {
                
            [UIView animateWithDuration:0.4 animations:^{
                scrollView.contentInset= UIEdgeInsetsMake(-contentInset, 0, 0, 0);
            [self.scrollView setContentSize:CGSizeMake(0, HeightForSecton1)];
     
            } completion:^(BOOL finished) {
                ISUP=YES;
  
            }];
              }];
        }
    }
    
    
}


@end
