//
//  MessagesTableViewController.m
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 3/31/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "DataSource.h"
#import "MyDataManager.h"
#import "Contact.h"
#import "SingleMessageViewController.h"

@interface MessagesTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DataSource* dataSource;
@property (nonatomic,strong) MyDataManager *myDataManager;

@end

@implementation MessagesTableViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _myDataManager = [[MyDataManager alloc] init];
        _dataSource = [[DataSource alloc] initForEntity:@"Contact"              //Get all contacts
                                               sortKeys:@[@"lastName"]
                                              ascending:YES
                                              predicate:nil
                                     sectionNameKeyPath:nil
                                    dataManagerDelegate:_myDataManager];
        
        _dataSource.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.dataSource = self.dataSource;
    self.dataSource.tableView = self.tableView;
    
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Data Source Cell Configurer

-(void)configureCell:(UITableViewCell *)cell withObject:(id)object
{
    Contact* contact = object;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    
    cell.detailTextLabel.text = @"";
}

-(NSString*)cellIdentifierForObject:(id)object
{
    return @"MessageCell";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MessageSegue"])
    {
        SingleMessageViewController* singleMessageViewController = segue.destinationViewController;
        
        NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
        
        singleMessageViewController.contact = [self.dataSource objectAtIndexPath:selectedIndexPath];
    }
}

@end
