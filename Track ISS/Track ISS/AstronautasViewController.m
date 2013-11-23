//
//  AstronautasViewController.m
//  Track ISS
//
//  Created by Jose Luis Rodriguez on 20/04/13.
//  Copyright (c) 2013 Jose Luis Rodriguez. All rights reserved.
//

#import "AstronautasViewController.h"
#import "InfoViewController.h"
#import "MBProgressHUD.h"


@interface AstronautasViewController ()

@property(nonatomic,strong)NSArray *astronautas;
@property (nonatomic,weak)NSString *as;
@end

@implementation AstronautasViewController


- (void)viewDidLoad
{
    
    MBProgressHUD *hud=[[MBProgressHUD alloc]init];
    [hud show:YES];
    [self.view addSubview:hud];
    
    self.Tablaas.backgroundColor=[UIColor clearColor];
    
    [NSThread detachNewThreadSelector:@selector(getAstronautas) toTarget:self withObject:nil];
}

-(void)getAstronautas{
    
    NSURL *url=[NSURL URLWithString:@"http://api.open-notify.org/astros/v1/"];
    NSDictionary *resultado=[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:url] options:0 error:nil];
    
    self.astronautas=[resultado objectForKey:@"people"];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    [self.Tablaas reloadData];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idcelda=@"micelda";
    
    UITableViewCell *celda=[tableView dequeueReusableCellWithIdentifier:idcelda];
    
    if(celda==nil){
        celda=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idcelda];
        
    }
    [celda.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:23]];
    celda.textLabel.text=[NSString stringWithFormat:@" %@", [self nombreastronautaconnumero:indexPath.row]];
    [celda setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    celda.imageView.image=[UIImage imageNamed:@"1385252624_user_male4"];
    
    return celda;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    self.as=[[[self.Tablaas cellForRowAtIndexPath:indexPath] textLabel]text];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self performSegueWithIdentifier:@"Info" sender:self];
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    InfoViewController *vista=[segue destinationViewController];
    
    vista.astronauta=self.as;


}

-(NSString *)nombreastronautaconnumero:(NSInteger)numero{
    return [[self.astronautas objectAtIndex:numero]objectForKey:@"name"];



}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.astronautas.count;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
