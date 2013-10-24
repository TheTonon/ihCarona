//
//  MapsViewController.h
//  ihCarona
//
//  Created by Pedro Freme on 10/23/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"



@interface MapsViewController : UIViewController <MKMapViewDelegate>
{
    MBProgressHUD *HUD;
}

-(IBAction)gRoute:(id)sender;

@end
