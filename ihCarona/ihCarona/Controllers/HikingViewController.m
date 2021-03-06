//
//  HikingViewController.m
//  ihCarona
//
//  Created by Pedro Freme on 10/31/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "HikingViewController.h"
#import <RestKit/RestKit.h>
#import "APIRider.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "FbFriendsViewController.h"

@interface HikingViewController ()

@property(nonatomic, strong) NSString *destination;
@property(nonatomic, strong) NSString *actualLocation;
@property(nonatomic, strong) NSString *dateToGo;
@property(nonatomic, strong) NSDictionary *json;
@property(nonatomic, strong) APIRider *apiRider;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic) BOOL locationRecovered;
@property (nonatomic) BOOL destinationCitySetted;
@property (nonatomic) BOOL isRiderInserted;


@end

@implementation HikingViewController

@synthesize locationManager, currentLocation;


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
    [self startStandardUpdates];
    //[self.locationManager startUpdatingLocation];
    
    self.apiRider = [[APIRider alloc] init];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Destino" message:@"Qual cidade deseja ir" delegate:nil cancelButtonTitle:@"Enviar" otherButtonTitles:nil];
    self.apiRider.desiredDate = @"2013-10-31";
    self.apiRider.isDriver = [Repository instance].isDriver;
    self.apiRider.userId = [Repository instance].user.id;
    self.apiRider.id = 0;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.delegate = self;
    
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    ai.center = self.view.center;
    [self.view addSubview:ai];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"Carregando";
    HUD.detailsLabelText = @"Aguarde alguns instantes";
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [self.view addSubview:HUD];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.apiRider.city = [alertView textFieldAtIndex:0].text;
    [Repository instance].destinyCity= self.apiRider.city;
    self.destinationCitySetted = YES;
    if(buttonIndex == 0)
    {
        [self insertUser];
        [HUD show:YES];
        [self performSegueWithIdentifier:@"segueForFbFriends" sender:self];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Device Location

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager)
        
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500; // meters
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    self.apiRider.latitude = self.locationManager.location.coordinate.latitude;
    self.apiRider.longitude = self.locationManager.location.coordinate.longitude;
    self.locationRecovered = YES;
    [self insertUser];
    [HUD hide:YES];
    if(newLocation.horizontalAccuracy <= 100.0f) { [locationManager stopUpdatingLocation]; }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate

#pragma mark - segue elements

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueForFbFriends"]){
        
        FbFriendsViewController *friendsController = [segue destinationViewController];
        
        friendsController.friendsList = [APIRider getRidersForCity:self.apiRider.city];
    }
}

-(void) insertUser
{
    @synchronized(self){
        if(!self.isRiderInserted && self.locationRecovered && self.destinationCitySetted)
        {
            CLLocation *coord = [[CLLocation alloc] initWithLatitude:self.apiRider.latitude longitude:self.apiRider.longitude];
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:coord completionHandler:^(NSArray *placemarks, NSError *error) {
                if(!error)
                {
                    CLPlacemark *topResult = [placemarks objectAtIndex:0];
                    self.apiRider.txtAdress = [NSString stringWithFormat:@"%@, %@, %@, %@",
                                               [topResult thoroughfare],[topResult locality],
                                               [topResult administrativeArea], [topResult country]];
                    NSLog(@"SUBA NO CHOPPEIRO");
                    NSLog(@"%@",self.apiRider.txtAdress);
                    
                    [APIRider insertRider:self.apiRider];

                }
            }];
        }
    }
}


@end
