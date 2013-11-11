//
//  SettingsViewController.m
//  ihCarona
//
//  Created by Vinicius Tonon on 11/8/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "SettingsViewController.h"
#import "APIUserSettings.h"

@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet UITextField *txtDeparture;
@property (strong, nonatomic) IBOutlet UITextField *txtDestination;

@property (strong, nonatomic) MKMapItem *mapDestination;
@property (strong, nonatomic) MKMapItem *mapDeparture;

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
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"Resolvendo tretas.";
    HUD.detailsLabelText = @"Segura os paranauê que já termina.";
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.view addSubview:HUD];
    
    self.request = [[MKDirectionsRequest alloc] init];

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
    //recover the adresses from view
    self.settings.departureAddress= self.txtDeparture.text;
    self.settings.destinationAddress = self.txtDestination.text;
    
    NSMutableArray *informations = [[NSMutableArray alloc] init];
    [informations addObject:self.settings.departureAddress];
    [informations addObject:self.settings.destinationAddress];
    
    int counter = 0;
    for(NSString *information in informations)
    {
        [self geocodeUserInformation:informations[counter] withCounter:counter];
        counter ++;
    }
}

-(void)geocodeUserInformation:(NSString *)address withCounter:(int)counter
{
    [HUD show:YES];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *topResult = [placemarks objectAtIndex:0];
        MKPlacemark *mPlacemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
        self.mapDestination = [[MKMapItem alloc] initWithPlacemark:mPlacemark];
        self.settings.destinationAddress = [NSString stringWithFormat:@"%@, %@, %@, %@",
                              [topResult thoroughfare],[topResult locality],
                              [topResult administrativeArea], [topResult country]];
        NSLog(@"%@", self.settings.destinationAddress);
        if(counter == 0)
        {
            self.request.source = self.mapDestination;
        }
        else if(counter == 1)
        {
            self.request.destination = self.mapDestination;
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
