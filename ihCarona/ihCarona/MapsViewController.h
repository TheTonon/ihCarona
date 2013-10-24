//
//  MapsViewController.h
//  ihCarona
//
//  Created by Pedro Freme on 10/23/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapsViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) MKMapItem *destination;
@property (weak, nonatomic) IBOutlet MKMapView *routeMap;



@end
