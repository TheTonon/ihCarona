//
//  RidesViewController.m
//  ihCarona
//
//  Created by Pedro Freme on 10/24/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "RidesViewController.h"

@interface RidesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *ridesTable;
@property (nonatomic, strong)NSMutableArray *ridersList;

@end

@implementation RidesViewController

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
    NSArray *end = @[@"Rua francisco de barros barao geraldo campinas brasil", @"PUCC Campinas", @"Rua das acacias 303 valinhos brasil"];
    self.ridersList = [[NSMutableArray alloc]init];
    for(NSInteger i = 0; i<3; i++){
        self.theRider = [[Rider alloc]init];
        
        self.theRider.riderName = [NSString stringWithFormat: @"Nome %d", i ];
        self.theRider.riderLocation = end[i];
    
        [self.ridersList addObject:self.theRider];
    }
    [self.ridesTable setDelegate:self];
    [self.ridesTable setDataSource:self];
    
    
    #pragma mark - setting list apearence
    self.ridesTable.backgroundColor = [UIColor blackColor];
    [self.ridesTable reloadData];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - prepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueToMap"]){
        
        MapsViewController *goToMaps = [segue destinationViewController];
        
        NSMutableArray *passa = [[NSMutableArray alloc] init];
        for (Rider *rider in self.ridersList) {
            [passa addObject:rider.riderLocation];
        }
        goToMaps.ridersLocation = passa;
    }
    
}

#pragma mark - TableView DataSource
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ridersList count];
}

#pragma mark - TableView Delegate
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"newCell"];
    if(!newCell){
        newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"newCell"];
        newCell.backgroundColor = [UIColor clearColor];
        
        UIColor *textColor = [UIColor whiteColor];
        NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
        if (selectedIndexPath && [indexPath row] == [selectedIndexPath row]) {
            textColor = [UIColor blackColor];
        }
        newCell.textLabel.textColor = textColor;
        newCell.detailTextLabel.textColor = textColor;
        
        
        newCell.textLabel.text = [[self.ridersList objectAtIndex:[indexPath row]] riderName];
        newCell.detailTextLabel.text = [[self.ridersList objectAtIndex:[indexPath row]] riderLocation];
    }
    return newCell;
}

@end
