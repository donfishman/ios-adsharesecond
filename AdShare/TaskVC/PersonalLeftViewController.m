//
//  PersonalLeftViewController.m
//  PersonalHomePageDemo
//
//  Created by Kegem Huang on 2017/3/15.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "PersonalLeftViewController.h"

@interface PersonalLeftViewController ()<UIWebViewDelegate>
{
    CGFloat *webH;
}
@property (strong, nonatomic) UIWebView *webView;



@end

@implementation PersonalLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KSW, KSH * 0.75)];
    self.webView.backgroundColor = CColor(whiteColor);
    NSString *html_str = self.HtmlStr;
    self.webView.dataDetectorTypes = 0;
    [self.webView loadHTMLString:html_str baseURL:[NSURL URLWithString:@"http://139.196.101.133:8087"]];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    //禁止长按弹出选择框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];

    
    
    //方法1
//    CGFloat documentWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').offsetWidth"] floatValue];
//    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"content\").offsetHeight;"] floatValue];
//    NSLog(@"documentSize = {%f, %f}", documentWidth, documentHeight);
    
    //方法2
            CGRect frame = webView.frame;
            frame.size.width = 768;
            frame.size.height = 1;
            //    wb.scrollView.scrollEnabled = NO;
            webView.frame = frame;
            frame.size.height = webView.scrollView.contentSize.height;
            NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
            webView.frame = frame;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark - Tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KSH * 0.75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    [cell addSubview:self.webView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"点击left-%d",(int)indexPath.row);
}



@end
