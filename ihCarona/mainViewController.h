//
//  mainViewController.h
//  ihCarona
//
//  Created by Vinicius Tonon on 10/22/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"

@interface mainViewController : UIViewController <MKMapViewDelegate>
{
    MBProgressHUD *HUD;
}



@property (strong, nonatomic) NSMutableArray *mapLocations;

-(void)openInAppleMaps;

-(IBAction)bOpenInAppleMaps:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *textAddress;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKMapItem *destination;
@property (strong, nonatomic) MKMapItem *origin;

@end
