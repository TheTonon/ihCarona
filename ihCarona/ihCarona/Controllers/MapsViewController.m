//
//  MapsViewController.m
//  ihCarona
//
//  Created by Pedro Freme on 10/23/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "MapsViewController.h"

@interface MapsViewController ()

@property int cont;
@property (strong, nonatomic) IBOutlet UITextField *textAddress;

@property(nonatomic) CLLocationCoordinate2D drawPoints;
@property(nonatomic, strong) CLGeocoder *geocoder;
@property(nonatomic, strong) MKDirectionsRequest *request;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) NSMutableArray *mapLocations;
@property(nonatomic) CLLocationCoordinate2D coordinate;

#pragma mark - Variáveis de localização
@property (strong, nonatomic) MKMapItem *destination;
@property (strong, nonatomic) MKMapItem *origin;

@end

@implementation MapsViewController

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
    _mapView.delegate = self;
    
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    ai.center = self.view.center;
    [self.view addSubview:ai];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"Resolvendo tretas.";
    HUD.detailsLabelText = @"Segura os paranauê que já termina.";
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.view addSubview:HUD];
    
    self.request = [[MKDirectionsRequest alloc] init];
    self.mapLocations = [[NSMutableArray alloc] init];
    self.cont = 0;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate =
    userLocation.location.coordinate;
    self.coordinate = userLocation.location.coordinate;
}

#pragma mark - Botões
-(IBAction)gRoute:(id)sender
{
    NSLog(@"PEDIU AS CORDENATA");
    [self genMap];
    [self.view endEditing:YES];
}

-(void)genMap
{
    self.cont = 0;
    for(int i =0; i<[self.ridersLocation count]; i++)
    {
        NSLog(@"@@@@@@@@@@@@@@@@@ %u", i);
        NSLog(@" %@", self.ridersLocation[i]);
        NSLog(@"@@@@@@@@@@@@@@@@@");
        
        [self coordWithAdress:self.ridersLocation[i]];
    }
}

#pragma mark - Aquisição da rota
-(void)coordWithAdress:(NSString *)address
{
    NSLog(@"GEOCODER");
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray *placemarks, NSError* error){
                     NSLog(@"ENTREI NO GEOCODER");
                     if (placemarks && [placemarks count] > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = self.mapView.region;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 3000.0;
                         region.span.latitudeDelta /= 3000.0;
                         
                         MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
                         
                         //adjustedRegion.span.latitudeDelta = 0.005;
                         //adjustedRegion.span.longitudeDelta = 0.005;
                         
                         [self.mapLocations addObject:placemark];
                         NSLog(@"COORDENADAS ATUAIS");
                         //NSLog(@"%@", [self.mapLocations description]);
                         
                         [self.mapView setRegion:adjustedRegion animated:YES];
                         
                         [self.mapView addAnnotation:placemark];
                         NSLog(@"%@", [placemarks objectAtIndex:0]);
                         
                         MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                         self.destination = destinationItem;
                    
                         MKMapItem *sourceItem = nil;
                         if(self.cont == 0)
                         {
                             MKPlacemark *localPlaceMark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil];
                             sourceItem = [[MKMapItem alloc]initWithPlacemark:localPlaceMark];
                             self.request.source =sourceItem;
                         }
                         else
                         {
                              sourceItem= [[MKMapItem alloc] initWithPlacemark:self.mapLocations[self.cont - 1]];
                             self.request.source = sourceItem;
                         }
                         
                         NSLog(@"################# %@",sourceItem.description);
                         
                         self.cont ++;
                         [self getDirections];
                         
                         if(self.cont == 1)
                            [self coordWithAdress:address];
                         
                     }
                 }
     ];
}

- (void)getDirections
{
    NSLog(@"ROTA ROTA ROTA");
    
    self.request.destination = _destination;
    NSLog(@"DESTINATION");
    self.request.requestsAlternateRoutes = NO;
    NSLog(@"Alternate routes");
    MKDirections *directions = [[MKDirections alloc] initWithRequest:self.request];
    [HUD show:YES];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         [HUD hide:YES];
         NSLog(@"ROTA ROTA ROTA");
         [self showRoute:response];
     }];
}
#pragma mark - Desenho da rota
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
