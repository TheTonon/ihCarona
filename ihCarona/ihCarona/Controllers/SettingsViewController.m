//
//  SettingsViewController.m
//  ihCarona
//
//  Created by Vinicius Tonon on 11/8/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "SettingsViewController.h"
#import <MapKit/MapKit.h>

@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textPartida;
@property (strong, nonatomic) IBOutlet UITextField *textDestino;
@property (strong, nonatomic) IBOutlet UITextField *textHorario;

@property (strong, nonatomic) NSString *textAddressPartida;
@property (strong, nonatomic) NSString *textAddressDestino;
@property (strong, nonatomic) NSString *horario;

@property (strong, nonatomic) MKMapItem *mapDestino;
@property (strong, nonatomic) MKMapItem *mapPartida;

@property (strong, nonatomic) NSMutableArray *arrayOfInstructions;

@property (nonatomic) BOOL donePartida;
@property (nonatomic) BOOL doneDestino;

@property (nonatomic, strong) MKDirectionsRequest *request;
@end

@implementation SettingsViewController

@synthesize textAddressDestino, textAddressPartida, horario, mapDestino, mapPartida, arrayOfInstructions,
doneDestino, donePartida, request;

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
    arrayOfInstructions = [[NSMutableArray alloc] init];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"Resolvendo tretas.";
    HUD.detailsLabelText = @"Segura os paranauê que já termina.";
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.view addSubview:HUD];
    
    request = [[MKDirectionsRequest alloc] init];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
-(IBAction)salvar:(id)sender
{

    textAddressPartida = self.textPartida.text;
    textAddressDestino = self.textDestino.text;
    horario = self.textHorario.text;
    NSMutableArray *informations = [[NSMutableArray alloc] init];
    [informations addObject:textAddressPartida];
    [informations addObject:textAddressDestino];
    int contador = 0;
    for(NSString *information in informations)
    {
        [self geocodeUserInformation:informations[contador] comContador:contador];
        contador ++;
    }
}

-(void)geocodeUserInformation:(NSString *)address comContador:(int)contador
{
    [HUD show:YES];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *topResult = [placemarks objectAtIndex:0];
        MKPlacemark *mPlacemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
        mapDestino = [[MKMapItem alloc] initWithPlacemark:mPlacemark];
        textAddressDestino = [NSString stringWithFormat:@"%@, %@, %@, %@",
                              [topResult thoroughfare],[topResult locality],
                              [topResult administrativeArea], [topResult country]];
        NSLog(@"%@", textAddressDestino);
        if(contador == 0)
        {
            request.source = mapDestino;
        }
        else if(contador == 1)
        {
            request.destination = mapDestino;
        }
        else
        {
            NSLog(@"Erro. Qual? o contador passou de 2");
        }
        [HUD hide:YES];
        [self getDestinationsForUser];
    }];
}

-(void)getDestinationsForUser
{
    [HUD show:YES];
    request.requestsAlternateRoutes = NO;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         NSLog(@"ROTA ROTA ROTA");
         NSLog(@"%@",error.localizedDescription);
         [HUD hide:YES];
         [self setRouteToArray:response];
     }];
}

-(void)setRouteToArray:(MKDirectionsResponse *)response
{
    [HUD show:YES];
    for(MKRoute *route in response.routes)
    {
        for(MKRouteStep *step in route.steps)
        {
            [arrayOfInstructions addObject:step.instructions];
        }
    }
    NSLog(@"%@", arrayOfInstructions.description);
    [HUD hide:YES];
}
@end
