//
//  SettingsViewController.m
//  ihCarona
//
//  Created by Vinicius Tonon on 11/8/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "SettingsViewController.h"
#import "APIUserSettings.h"
#import <MapKit/MapKit.h>

@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet UITextField *txtDeparture;
@property (strong, nonatomic) IBOutlet UITextField *txtDestination;
@property (strong, nonatomic) IBOutlet UITextField *txtSchedule;

@property (strong, nonatomic) APIUserSettings *settings;

@property (nonatomic, strong) MKDirectionsRequest *request;
@end

@implementation SettingsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.settings = [[APIUserSettings alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //initiates loader
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"Resolvendo tretas.";
    HUD.detailsLabelText = @"Segura os paranauê que já termina.";
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.view addSubview:HUD];
    
    //initiates request
    self.request = [[MKDirectionsRequest alloc] init];
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
    //Recover informations from view
    self.settings.departureAddress = self.txtDeparture.text;
    self.settings.destinationAddress = self.txtDestination.text;
    self.settings.schedule = self.txtSchedule.text;

    //recover address informations
    [self geocodeUserInformation:self.settings.departureAddress asDestination:NO];
    [self geocodeUserInformation:self.settings.destinationAddress asDestination:YES];
    
}

/**
 *  recover a complete adress from a address passed by the user
 *
 *  @param address
 *  @param counter counter description
 */
-(void)geocodeUserInformation:(NSString *)address asDestination:(BOOL)isDestination
{
    [HUD show:YES];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //request address informations from Apple
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *topResult = [placemarks objectAtIndex:0];
        MKPlacemark *mPlacemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:mPlacemark];
        
        NSString * resultAddress = [NSString stringWithFormat:@"%@, %@, %@, %@",
                                    [topResult thoroughfare],[topResult locality],
                                    [topResult administrativeArea], [topResult country]];
        
        //gets the best result and set as the address
        if(!isDestination){
            self.settings.departureAddress = resultAddress;
            NSLog(@"%@", self.settings.departureAddress);
            self.request.source = mapItem;
        }else{
            self.settings.destinationAddress =resultAddress;
            self.request.destination = mapItem;
        }
        
        [self getDestinationsForUser];

    }];
}

/**
 *  recupera a melhor rota para o usuario para os enderecos desejados
 */
-(void)getDestinationsForUser
{
    [HUD show:YES];
    self.request.requestsAlternateRoutes = NO;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:self.request];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         NSLog(@"ROTA ROTA ROTA");
         NSLog(@"%@",error.localizedDescription);
         [HUD hide:YES];
         [self setRouteToArray:response];
     }];
}

/**
 *  adiciona as direcoes as instrucoes padrao do usuario
 *
 *  @param response resposta de direcoes para a rota
 */
-(void)setRouteToArray:(MKDirectionsResponse *)response
{
    [HUD show:YES];
    for(MKRoute *route in response.routes)
    {
        for(MKRouteStep *step in route.steps)
        {
            [self.settings.instructions addObject:step.instructions];
        }
    }
    NSLog(@"%@", self.settings.instructions.description);
    [HUD hide:YES];
}
@end
