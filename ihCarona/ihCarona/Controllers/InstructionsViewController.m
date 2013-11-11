//
//  InstructionsViewController.m
//  ihCarona
//
//  Created by Pedro Freme on 10/28/13.
//  Copyright (c) 2013 Vinicius Tonon. All rights reserved.
//

#import "InstructionsViewController.h"

@interface InstructionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *instructionsTable;

@end

@implementation InstructionsViewController

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
    
    [self.instructionsTable setDelegate:self];
    [self.instructionsTable setDataSource:self];
    [self.instructionsTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.instructions count];
}

#pragma mark - TableView Delegate
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"newCell"];
    if(!newCell){
        newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"newCell"];
        newCell.backgroundColor = [UIColor clearColor];
        
        UIColor *textColor = [UIColor blackColor];
        NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
        if (selectedIndexPath && [indexPath row] == [selectedIndexPath row]) {
            textColor = [UIColor blackColor];
        }
        newCell.textLabel.textColor = textColor;
        newCell.detailTextLabel.textColor = textColor;
        
        
        newCell.textLabel.text = [self.instructions objectAtIndex:[indexPath row]];
        
        newCell.selectionStyle = UITableViewCellSelectionStyleNone;
        newCell.userInteractionEnabled = NO;
        
    }
    return newCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    }


@end
