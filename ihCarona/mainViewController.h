//
//  mainViewController.h
//  ihCarona
//
//  Created by Vinicius Tonon on 10/22/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface mainViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *mapLocations;

-(void)openInAppleMaps;

-(IBAction)bOpenInAppleMaps:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *textAddress;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKMapItem *destination;

@end
