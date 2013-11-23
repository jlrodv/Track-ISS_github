//
//  InfoViewController.h
//  Track ISS
//
//  Created by Jose Luis Rodriguez on 20/04/13.
//  Copyright (c) 2013 Jose Luis Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *Infowiki;
@property (weak,nonatomic) NSString *astronauta;

@property(nonatomic,weak) NSString *cadena;

@end
