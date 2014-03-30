//
//  MessagesTableViewController.m
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 3/30/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "DataSource.h"
#import "MyDataManager.h"
#import "Contact.h"

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

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    if (![contact.phoneNumber  isEqual: @""])
    {
        cell.detailTextLabel.text = contact.phoneNumber;
    }
    else if (![contact.emailAddress isEqual: @""])
    {
        cell.detailTextLabel.text = contact.emailAddress;
    }
    else
    {
        cell.detailTextLabel.text = @"";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

-(NSString*)cellIdentifierForObject:(id)object
{
    return @"Contact";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
