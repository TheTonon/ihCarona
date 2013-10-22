//
//  mainViewController.h
//  ihCarona
//
//  Created by Vinicius Tonon on 10/22/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface mainViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *mapLocations;

-(void)openInAppleMaps;

-(IBAction)bOpenInAppleMaps:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textAddress;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
