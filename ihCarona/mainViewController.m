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
    _mapView.showsUserLocation = YES;
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate,
                                       20000, 20000);
    [_mapView setRegion:region animated:NO];
    _mapView.delegate = self;
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
                         
                         /*self.drawPoints = CLLocationCoordinate2D drawPoints[20];
                         self.drawPoints[self.cont] = CLLocationCoordinate2DMake(adjustedRegion.center.latitude, adjustedRegion.center.longitude);
                         self.cont ++;
                         
                         MKGeodesicPolyline *polyLine = [MKGeodesicPolyline polylineWithCoordinates:self.drawPoints count:20];
                         [self.mapView addOverlay:polyLine];*/
                         
                         MKDirectionsRequest *dRequest = [[MKDirectionsRequest alloc] init];
                         MKMapItem *carItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                         MKMapItem *actualPos = [MKMapItem mapItemForCurrentLocation];
                         dRequest.source = actualPos;
                         dRequest.destination = carItem;
                         dRequest.requestsAlternateRoutes = NO;
                         
                         MKDirections *directions = [[MKDirections alloc] initWithRequest:dRequest];
                         [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                             if (error) {
                                 NSLog(@"Error : %@", error);
                             }
                             else {
                                 [self showDirections:response];
                             }
                         }];
                     }
                 }
     ];
}

-(void)showDirections:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes) {
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)getDirections
{
    MKDirectionsRequest *request =
    [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    request.destination = _destination;
    request.requestsAlternateRoutes = NO;
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle error
         } else {
             [self showRoute:response];
         }
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
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
