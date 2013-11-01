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
    self.apiRider.latitude = self.locationManager.location.coordinate.latitude;
    self.apiRider.longitude = self.locationManager.location.coordinate.longitude;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.apiRider.City = [alertView textFieldAtIndex:0].text;
    if(buttonIndex == 0)
    {
        [APIRider insertRider:self.apiRider];
        
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
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500; // meters
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    
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


@end
