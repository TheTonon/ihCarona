//
//  HikingViewController.m
//  ihCarona
//
//  Created by Pedro Freme on 10/31/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "HikingViewController.h"

@interface HikingViewController ()

@property(nonatomic, strong) NSString *destination;
@property(nonatomic, strong) NSString *actualLocation;
@property(nonatomic, strong) NSString *dateToGo;

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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Destino" message:@"Qual seu destino" delegate:nil cancelButtonTitle:@"Wololo" otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate


@end
