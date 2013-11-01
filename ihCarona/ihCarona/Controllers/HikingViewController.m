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

@interface HikingViewController ()

@property(nonatomic, strong) NSString *destination;
@property(nonatomic, strong) NSString *actualLocation;
@property(nonatomic, strong) NSString *dateToGo;
@property(nonatomic, strong) NSDictionary *json;
@property(nonatomic, strong) APIRider *apiRider;
@property(nonatomic)CLLocationCoordinate2D coordinate;

@end

@implementation HikingViewController

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
	// Do any additional setup after loading the view.
    [self jsonTestMethod];
    
    self.apiRider = [[APIRider alloc] init];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Destino" message:@"Qual seu destino" delegate:nil cancelButtonTitle:@"Wololo" otherButtonTitles:nil];
    self.apiRider.DesiredDate = @"2013-10-31";
    self.apiRider.IsDriver = @"false";
    self.apiRider.UserId = @"blabla";
    self.apiRider.Id = 0;
    self.apiRider.latitude = self.coordinate.latitude;
    self.apiRider.longitude = self.coordinate.longitude;
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)buttonJSONRider
{
    [self.apiRider insertRider:self.apiRider];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.apiRider.City = [alertView textFieldAtIndex:0].text;
    if(buttonIndex == 0)
    {
        [self buttonJSONRider];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Device Location
- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    self.coordinate = userLocation.location.coordinate;
}

#pragma mark - JSON

-(void)jsonTestMethod
{
    NSError *error = nil;
    NSString *url = [NSString stringWithFormat:@"http://s3.amazonaws.com/ihCarona/testData.json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSDictionary *retornoJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(!error){
        NSString *nome = [retornoJSON objectForKey:@"nome"];
        NSString *endereco = [retornoJSON objectForKey:@"descricao"];
        NSLog(@"Nome: %@, Endereço: %@", nome, endereco);
    }
}

#pragma mark - UIAlertViewDelegate


@end
