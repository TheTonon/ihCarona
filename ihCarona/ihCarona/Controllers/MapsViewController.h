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
#import "InstructionsViewController.h"



@interface MapsViewController : UIViewController <MKMapViewDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) NSMutableArray *ridersLocation;
@property (nonatomic, strong) NSMutableArray *segueIntructions;

@end
