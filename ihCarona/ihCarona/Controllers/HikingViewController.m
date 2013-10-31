//
//  HikingViewController.m
//  ihCarona
//
//  Created by Pedro Freme on 10/31/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "HikingViewController.h"
#import <MapKit/MapKit.h>

@interface HikingViewController ()

@property(nonatomic, strong) NSString *destination;
@property(nonatomic, strong) NSString *actualLocation;
@property(nonatomic, strong) NSString *dateToGo;

@property(nonatomic, strong) NSDictionary *json;
@property(nonatomic) CLLocationCoordinate2D userLocat;


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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Destino" message:@"Qual seu destino" delegate:nil cancelButtonTitle:@"Wololo" otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Map Data
- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    userLocation.location.coordinate;
    self.userLocat = userLocation.location.coordinate;
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
