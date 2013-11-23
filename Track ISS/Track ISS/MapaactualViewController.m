//
//  MapaactualViewController.m
//  Track ISS
//
//  Created by Jose Luis Rodriguez on 20/04/13.
//  Copyright (c) 2013 Jose Luis Rodriguez. All rights reserved.
//

#import "MapaactualViewController.h"
#import "Pin.h"
#import "InfoViewController.h"

@interface MapaactualViewController ()
@property(nonatomic,strong) NSDictionary *respuesta;
@property (nonatomic,weak) NSTimer *tiempo;
@end

@implementation MapaactualViewController



- (void)viewDidLoad
{
    
      
    [super viewDidLoad];
    self.Mapa.delegate=self;
    
 
    [self getPosition];
    self.tiempo=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getPosition) userInfo:nil repeats:YES];
    [self.tiempo fire];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self getDict];
    CLLocationCoordinate2D setreg;
    setreg.longitude=[[[self.respuesta objectForKey:@"iss_position"]objectForKey:@"longitude"] doubleValue];
    setreg.latitude=[[[self.respuesta objectForKey:@"iss_position"]objectForKey:@"latitude"] doubleValue];
    NSLog(@"%f,%f", setreg.longitude, setreg.longitude);
    [self.Mapa setRegion:MKCoordinateRegionMakeWithDistance(setreg, 10000000, 10000000) animated:YES];

    
}
-(void)getDict{
    
    NSURL *url=[NSURL URLWithString:@"http://api.open-notify.org/iss-now/v1/"];
    self.respuesta=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:0 error:nil];
}


-(void)getPosition{
    
    
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.Mapa.annotations];
    NSMutableArray *overlays=[NSMutableArray arrayWithArray:self.Mapa.overlays];
    
    [self.Mapa removeAnnotations:annotations];
    [self.Mapa removeOverlays:overlays];
    
    [self getDict];
    
    Pin *pin=[[Pin alloc]init];
    
    CLLocationCoordinate2D loc;
   
    
    NSString *latitude=[[self.respuesta objectForKey:@"iss_position"]objectForKey:@"latitude"];
    loc.latitude=[latitude floatValue];
    
    NSString *longitude=[[self.respuesta objectForKey:@"iss_position"]objectForKey:@"longitude"];
    loc.longitude=[longitude floatValue];
    
    
    MKCircle *circulo=[MKCircle circleWithCenterCoordinate:loc radius:1800000];
    
    [self.Mapa addOverlay:circulo];
    
    
    pin.coordinate=loc;
    //pin.title=@"ISS";
    //pin.subtitle=date;
    self.Info.text=[NSString stringWithFormat:@"LN:%f    LT:%f",[longitude floatValue], [latitude floatValue]];
    
    
    [self.Mapa addAnnotation:pin];
    
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKAnnotationView *annot=[[MKAnnotationView alloc]initWithAnnotation: annotation reuseIdentifier:@"rehuse"];
    annot.image=[UIImage imageNamed:@"ISS.png"];
    return annot;
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    MKCircle* circle = overlay;
    MKCircleView* circleView = [[MKCircleView alloc] initWithCircle: circle];
    
    circleView.fillColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.1];
    circleView.strokeColor = [UIColor blueColor];
    circleView.lineWidth = 2.0;
    
    return circleView;

}

-(void)viewDidDisappear:(BOOL)animated{

    [self.tiempo invalidate];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    InfoViewController *vid=[segue destinationViewController];
    vid.cadena=@"video";
    [self.tiempo invalidate];

}


@end
