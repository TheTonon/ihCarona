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
#import "FriendFinderViewController.h"
#import "Repository.h"
@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet UITextField *txtDeparture;
@property (strong, nonatomic) IBOutlet UITextField *txtDestination;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;

@property (nonatomic) BOOL alreadySalved;

@property (strong, nonatomic) APIUserSettings *settings;

@property (nonatomic, strong) MKDirectionsRequest *request;
@end

@implementation SettingsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.settings = [[APIUserSettings alloc]init];
    //initiates loader
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"Carregando";
    HUD.detailsLabelText = @"Aguarde alguns instantes";
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.view addSubview:HUD];
    self.alreadySalved = NO;
    
    //initiates request
    self.request = [[MKDirectionsRequest alloc] init];
    
    //initiate date picker
}

-(void)viewWillAppear:(BOOL)animated
{
    self.alreadySalved = NO;
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
    if(!self.alreadySalved)
    {
        [self.settings.instructions removeAllObjects];
        //Recover informations from view
        self.settings.departureAddress = self.txtDeparture.text;
        self.settings.destinationAddress = self.txtDestination.text;
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
        NSString *dateString = [outputFormatter stringFromDate:self.timePicker.date];
        self.settings.schedule = dateString;
        //recover address informations
        NSLog(@"GEOCODE SALVAR 1");
        [self geocodeUserInformation:self.settings.departureAddress asDestination:NO];
        NSLog(@"GEOCODE SALVAR 2");
        [self geocodeUserInformation:self.settings.destinationAddress asDestination:YES];
    }
    self.alreadySalved = YES;
}

/**
 *  recover a complete adress from a address passed by the user
 *
 *  @param address
 *  @param counter counter description
 */
-(void)geocodeUserInformation:(NSString *)address asDestination:(BOOL)isDestination
{
    NSLog(@"GEOCODER GEOCODER GEOCODER");
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
    NSLog(@"Get Destinations for User");
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
    NSLog(@"Set Route to Array");
    [HUD show:YES];
    for(MKRoute *route in response.routes)
    {
        for(MKRouteStep *step in route.steps)
        {
            [self.settings.instructions addObject:step.instructions];
        }
    }
    [self saveUserSettings];
    
    NSLog(@"%@", self.settings.instructions.description);
    [HUD hide:YES];
}

-(void)saveUserSettings
{
    self.settings.userId = [Repository instance].user.id;
    [APIUserSettings insertSettings:self.settings];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueForFriendFinder"]){
        
        FriendFinderViewController *friendFinder = [segue destinationViewController];
        
        friendFinder.userRoute = self.settings.instructions;
        
    }
}

@end
