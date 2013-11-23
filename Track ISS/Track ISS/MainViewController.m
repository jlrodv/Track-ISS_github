//
//  MainViewController.m
//  Track ISS
//
//  Created by Jose Luis Rodriguez on 20/04/13.
//  Copyright (c) 2013 Jose Luis Rodriguez. All rights reserved.
//

#import "MainViewController.h"

#import <Social/Social.h>

@interface MainViewController ()

- (IBAction)share:(id)sender;
- (IBAction)nasa:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


-(void)viewWillDisappear:(BOOL)animated{
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Twitter:(UIButton *)sender {
    SLComposeViewController *tw=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tw setInitialText:@"I'm catching the International Space Station(@Space_Station) with TRACK-ISS, join me at: http://bit.ly/XXXfkV #spaceapps"];
    [self presentViewController:tw animated:YES completion:nil];
}
- (IBAction)share:(id)sender {
    UIActivityViewController *share=[[UIActivityViewController alloc] initWithActivityItems:@[@"I'm catching the International Space Station(@Space_Station) with TRACK-ISS #spaceapps, join me at:",[NSURL URLWithString:@"http://bit.ly/XXXfkV"]] applicationActivities:nil];
    
    [self presentViewController:share animated:YES completion:nil];
}

- (IBAction)nasa:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://spaceappschallenge.org/"]];
}
@end
