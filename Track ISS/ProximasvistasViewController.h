//
//  ProximasvistasViewController.h
//  Track ISS
//
//  Created by Jose Luis Rodriguez on 20/04/13.
//  Copyright (c) 2013 Jose Luis Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProximasvistasViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *Tabla;

@end
