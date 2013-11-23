//
//  MapaactualViewController.h
//  Track ISS
//
//  Created by Jose Luis Rodriguez on 20/04/13.
//  Copyright (c) 2013 Jose Luis Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapaactualViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *Mapa;

@property (weak, nonatomic) IBOutlet UILabel *Info;

@end
