//
//  InfoViewController.m
//  Track ISS
//
//  Created by Jose Luis Rodriguez on 20/04/13.
//  Copyright (c) 2013 Jose Luis Rodriguez. All rights reserved.
//

#import "InfoViewController.h"
#import "MBProgressHUD.h"

@interface InfoViewController ()




@end

@implementation InfoViewController
{
    bool loadmovie;

}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    NSLog(@"Muestra a:%@", self.astronauta);
    NSURL *url;
    self.Infowiki.delegate=self;
    
    if([self.cadena isEqualToString:@"video" ]){
        url=[NSURL URLWithString:@"http://www.ustream.tv/embed/9408562?v=3&amp"];
        
    }
    else{
        MBProgressHUD *hud=[[MBProgressHUD alloc]init];
        [hud show:YES];
        [self.view addSubview:hud];
        
        self.astronauta=[self.astronauta stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        url=[NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@",self.astronauta]];
    }
    
        [self.Infowiki loadRequest:[NSURLRequest requestWithURL:url]];
    
}
/*-(void)webViewDidStartLoad:(UIWebView *)webView{
    if(![self.cadena isEqualToString:@"video"]){
   
    }

}
*/
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
