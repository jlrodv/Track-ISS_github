//
//  ProximasvistasViewController.m
//  Track ISS
//
//  Created by Jose Luis Rodriguez on 20/04/13.
//  Copyright (c) 2013 Jose Luis Rodriguez. All rights reserved.
//

#import "ProximasvistasViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <EventKit/EventKit.h>
#import "MBProgressHUD.h"

@interface ProximasvistasViewController ()

@property(nonatomic,strong) NSDictionary *resultado;
@property(nonatomic,strong) NSArray *vistas;

- (IBAction)addToCalendar:(id)sender;
- (IBAction)share:(id)sender;

@end

@implementation ProximasvistasViewController
{

    int section;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
   
    MBProgressHUD *hud=[[MBProgressHUD alloc] init];
    [hud show:YES];
    [self.view addSubview: hud];
   
    [NSThread detachNewThreadSelector:@selector(getInfo) toTarget:self withObject:nil];
    
}

#pragma mark Get JSON info
-(void)getInfo{

    CLLocationManager *locmanager=[[CLLocationManager alloc]init];
    locmanager.delegate=self;
    locmanager.desiredAccuracy=kCLLocationAccuracyBest;
    [locmanager startUpdatingLocation];
    CLLocation *loc=[locmanager location];
    [locmanager stopUpdatingLocation];
    
    NSString *url=[NSString stringWithFormat:@"http://api.open-notify.org/iss/?lat=%f&lon=%f&alt=%f&n=5", loc.coordinate.latitude, loc.coordinate.longitude, loc.altitude];
	self.resultado=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]] options:0 error:nil];
    
    self.vistas=[self.resultado objectForKey:@"response"];
    [self.Tabla reloadData];
    [self.Tabla setUserInteractionEnabled:YES];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

}

#pragma mark TableView Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    UITableViewCell *celda;
    
    if(indexPath.row==0){
        celda=[tableView dequeueReusableCellWithIdentifier:@"duracion"];
        
        UILabel *label=(UILabel *)[celda viewWithTag:1];
        label.text=[NSString stringWithFormat:@"%d min", [[[self.vistas objectAtIndex:indexPath.section]objectForKey:@"duration"]intValue]/60];
    }
    else if(indexPath.row==1){
        celda=[tableView dequeueReusableCellWithIdentifier:@"fecha"];
        
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:[[[self.vistas objectAtIndex:indexPath.section]objectForKey:@"risetime" ]intValue]];
        NSString *fecha=[NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterShortStyle];
        
        UILabel *label=(UILabel *)[celda viewWithTag:1];
        label.text=[NSString stringWithFormat:@"%@", fecha];
        
    }
    else
        celda=[tableView dequeueReusableCellWithIdentifier:@"botones"];
    
    return celda;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.vistas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(self.vistas.count>3)
        return 3;
    
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row==1)
        return 88;

    return 44;
}

#pragma mark Event Actions
- (IBAction)addToCalendar:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Agregar al calendario" message:@"¿Deseas agregar un evento a tu calendario para recordarte cuando va a pasar la ISS cerca de ti?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Agregar", nil];
    alert.delegate=self;
    [alert show];
    section=[self.Tabla indexPathForCell:(UITableViewCell *)[sender superview]].section;
}


- (IBAction)share:(id)sender {
    
    
    NSIndexPath *index=[self.Tabla indexPathForCell:(UITableViewCell *)[sender superview]];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[[[self.vistas objectAtIndex:index.section]objectForKey:@"risetime" ]intValue]];
    NSString *fecha=[NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterShortStyle];
    
    UIActivityViewController *share=[[UIActivityViewController alloc] initWithActivityItems:@[[NSString stringWithFormat:@"La ISS va a pasar cerca de mi el %@ Descarga la app de TRACK-ISS", fecha],[NSURL URLWithString:@"http://2013.spaceappschallenge.org/location/mexico-city/"]] applicationActivities:nil];
    [self presentViewController:share animated:YES completion:nil];
    
}

#pragma mark Alert View Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
    
        MBProgressHUD *hud=[[MBProgressHUD alloc]init];
        hud.center=self.view.center;
        [hud show:YES];
        [self.view addSubview:hud];
        
        EKEventStore *storeCalendar=[[EKEventStore alloc]init];
        [storeCalendar requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            
            
            if(error){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"La app no tiene permisos para agregar eventos al calendario." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }else{
                
                EKEvent *issEvento=[EKEvent eventWithEventStore:storeCalendar];
                issEvento.title=@"Avistamiento de la ISS";
                
                NSDate *date=[NSDate dateWithTimeIntervalSince1970:[[[self.vistas objectAtIndex:section]objectForKey:@"risetime" ]intValue]];
                
                issEvento.startDate=date;
                issEvento.endDate=[date dateByAddingTimeInterval:[[[self.vistas objectAtIndex:section]objectForKey:@"duration"]intValue]];
                
                issEvento.calendar=[storeCalendar defaultCalendarForNewEvents];
                NSError *errorCal;
                [storeCalendar saveEvent:issEvento span:EKSpanThisEvent commit:YES error:&errorCal];
                if(errorCal){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSLog(@"%@", errorCal);
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Hubo un error favor de volver a intentar." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
                else{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Exito" message:@"El evento ha sido agregado a tu calendario." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    
                }
                
            }
            
        }];

    
    
    
    
    
    }
        

}

@end
