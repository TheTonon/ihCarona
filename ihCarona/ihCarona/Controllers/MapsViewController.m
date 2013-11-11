//
//  MapsViewController.m
//  ihCarona
//
//  Created by Pedro Freme on 10/23/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "MapsViewController.h"
#import "APIRider.h"

@interface MapsViewController ()

@property int cont;
@property (strong, nonatomic) IBOutlet UITextField *textAddress;

@property(nonatomic) CLLocationCoordinate2D drawPoints;
@property(nonatomic, strong) CLGeocoder *geocoder;
@property(nonatomic, strong) MKDirectionsRequest *request;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) NSMutableArray *mapLocations;
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic, strong) NSMutableArray *routeInstructions;
@property(nonatomic) int contador;
@property(nonatomic, strong) NSString *desiredCity;
@property(nonatomic, strong) NSMutableArray *allRoutePolys;
@property(nonatomic) BOOL readyToDraw;

#pragma mark - Bedelho do Emil
//(Prepare to segue intruction)

#pragma mark - Variáveis de localização
@property (strong, nonatomic) MKMapItem *destination;
@property (strong, nonatomic) MKMapItem *origin;

@end

@implementation MapsViewController

@synthesize contador;

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
    
    self.allRoutePolys = [[NSMutableArray alloc] init];
    //Seta o delegate do MapView e pede autorização do usuário pra usar a localização dele.
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    //Load a AlertView do iOS
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    ai.center = self.view.center;
    [self.view addSubview:ai];
    //Loada a AlertUI/MBProgressHUD
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"Resolvendo tretas.";
    HUD.detailsLabelText = @"Segura os paranauê que já termina.";
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.view addSubview:HUD];
    //Allocs e resets
    self.routeInstructions = [[NSMutableArray alloc] init];
    self.request = [[MKDirectionsRequest alloc] init];
    self.mapLocations = [[NSMutableArray alloc] init];
    self.cont = 0;
    self.desiredCity = [[Repository instance] destinyCity];
    //Call no método de geração de trajeto.
    [self genMap];
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Centraliza o mapa na localização atual do usuário
- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate =
    userLocation.location.coordinate;
    self.coordinate = userLocation.location.coordinate;
}

#pragma mark - Botões
//Gera o mapa a partir da array de locais dadas pela view anterior.
-(void)genMap
{
    self.cont = 0;
    for(int i =0; i<[self.segueIntructions count]; i++)
    {
        APIRider *rider = self.segueIntructions[i];
        NSLog(@"@@@@@@@@@@@@@@@@@ %u", i);
        NSLog(@" %@  %@", rider.user.name, rider.txtAdress);
        NSLog(@"@@@@@@@@@@@@@@@@@");
        
        [self coordWithAdress:rider.txtAdress];
    }
    [self coordWithAdress:[Repository instance].destinyCity];
    self.readyToDraw = YES;
}

#pragma mark - Aquisição da rota
//Retorna a geoposição usuário a partir da string de local.
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
                         //region.center = placemark.region.center;
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
                         {
                             [self coordWithAdress:address];
                         }
                     }
                 }
     ];
}
//Envia request de rota
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
         NSLog(@"%@",error.localizedDescription);

         [self addRouteResponseToArray:response];
     }];
}

// Adiciona a resposta anterior a uma array de rotas.
-(void)addRouteResponseToArray:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.allRoutePolys addObject:route];
    }
    [self drawRoute:self.allRoutePolys];
}


#pragma mark - Desenho da rota
//Desenha cada rota individualmente // Deprecated
-(void)showRoute:(MKDirectionsResponse *)response
{
    NSLog(@"IM FIRING MY ROUTE!");
    self.routeInstructions = [[NSMutableArray alloc]init];
    for (MKRoute *route in response.routes)
    {
        NSLog(@"IM FIRING MY ROUTE! TWICE!");
        
        [_mapView
         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
            [self.routeInstructions addObject:step.instructions];
        }
    }
}
//Desenha as rotas a partir do array criado.
-(void)drawRoute:(NSArray *)arrayOfRoutes
{
    for (MKRoute* routes in arrayOfRoutes)
    {
        [self.mapView
         addOverlay:routes.polyline level:MKOverlayLevelAboveRoads];
        for (MKRouteStep *step in routes.steps)
        {
            [self.routeInstructions addObject:step.instructions];
        }
    }
}
//Seta informações da linha de desenho da rota como tamanho da linha e cor.
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor greenColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

#pragma mark - Bedelho do Emil PrepareToSegue
//Segue das instruções.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"segueToInstructions"]){
        InstructionsViewController *goToInstructions = [segue destinationViewController];
        
        goToInstructions.instructions = self.routeInstructions;
    }
    
}

@end
