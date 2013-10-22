//
//  mainViewController.m
//  ihCarona
//
//  Created by Vinicius Tonon on 10/22/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "mainViewController.h"

@interface mainViewController ()
@property int cont;
@end

@implementation mainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapLocations = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)bOpenInAppleMaps:(id)sender
{
    [self coordWithAdress:[self.textAddress text]];
}

-(void)coordWithAdress:(NSString *)address
{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray *placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = self.mapView.region;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 5000.0;
                         region.span.latitudeDelta /= 5000.0;
                         
                         MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
                         
                         //adjustedRegion.span.latitudeDelta = 0.005;
                         //adjustedRegion.span.longitudeDelta = 0.005;
                         
                         self.mapLocations[[NSNumber numberWithDouble:adjustedRegion.center.latitude]] = [NSNumber numberWithDouble:adjustedRegion.center.longitude];
                         NSLog(@"COORDENADAS ATUAIS");
                         NSLog(@"%@", [self.mapLocations description]);
                         
                         
                         [self.mapView setRegion:adjustedRegion animated:YES];
                         
                         self.mapView.showsUserLocation = YES;
                         [self.mapView addAnnotation:placemark];
                     }
                 }
     ];
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
