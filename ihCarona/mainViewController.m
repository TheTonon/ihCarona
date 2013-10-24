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
@property(nonatomic) CLLocationCoordinate2D drawPoints;
@property(nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation mainViewController

@synthesize geocoder = geocoder;

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
    _mapView.showsUserLocation = YES;
    MKUserLocation *userLocation = _mapView.userLocation;
    _mapView.delegate = self;
    
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    ai.center = self.view.center;
    [self.view addSubview:ai];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"Resolvendo tretas.";
    HUD.detailsLabelText = @"Segura os paranauê que já termina.";
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.view addSubview:HUD];
}

-(void)waiting
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)bOpenInAppleMaps:(id)sender
{
    NSLog(@"PEDIU AS CORDENATA");
    [self coordWithAdress:[self.textAddress text]];
}

- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate =
    userLocation.location.coordinate;
}

-(void)coordWithAdress:(NSString *)address
{
    NSLog(@"GEOCODER");
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray *placemarks, NSError* error){
                     NSLog(@"ENTREI NO GEOCODER");
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:self.cont];
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
                         
                         [self.mapView addAnnotation:placemark];
                         NSLog(@"%@", [placemarks objectAtIndex:self.cont]);
                         
                         [self getDirections];
                     }
                 }
     ];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)getDirections
{
    NSLog(@"ROTA ROTA ROTA");
    
    MKDirectionsRequest *request =
    [[MKDirectionsRequest alloc] init];
    
    request.destination = _destination;
    request.source = [MKMapItem mapItemForCurrentLocation];
    NSLog(@"DESTINATION");
    request.requestsAlternateRoutes = NO;
    NSLog(@"Alternate routes");
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [HUD show:YES];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         [HUD hide:YES];
         NSLog(@"ROTA ROTA ROTA");
         [self showRoute:response];
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    NSLog(@"IM FIRING MY ROUTE!");
    for (MKRoute *route in response.routes)
    {
        NSLog(@"IM FIRING MY ROUTE! TWICE!");
   
        [_mapView
         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

@end
