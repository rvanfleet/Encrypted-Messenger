//
//  ContactsTableViewController.m
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 3/30/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "DataSource.h"
#import "MyDataManager.h"
#import "Contact.h"
#import "AddContactTableViewController.h"
#import "EditContactTableViewController.h"

@interface ContactsTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DataSource* dataSource;
@property (nonatomic,strong) MyDataManager *myDataManager;

@end

@implementation ContactsTableViewController

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
    
    self.tableView.allowsSelectionDuringEditing = YES;
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
}

-(NSString*)cellIdentifierForObject:(id)object
{
    return @"ContactCell";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddContactSegue"])
    {
        AddContactTableViewController* addContactTableViewController = segue.destinationViewController;
        
        addContactTableViewController.completionBlock = ^(id obj){
            [self dismissViewControllerAnimated:YES completion:NULL];
            if (obj)
            {
                NSDictionary* dictionary = obj;
                
                [self.myDataManager addContact:dictionary];
            }
        };
    }
    else if ([segue.identifier isEqualToString:@"EditContactSegue"])
    {
        EditContactTableViewController* editContactTableViewController = segue.destinationViewController;
        
        NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
        
        Contact* selectedContact = [self.dataSource objectAtIndexPath:selectedIndexPath];
        
        editContactTableViewController.contact = selectedContact;
        
        editContactTableViewController.completionBlock = ^(id obj){
        
            [self dismissViewControllerAnimated:YES completion:NULL];
            
            if (obj)
            {
                Contact* contactToSave = obj;

                [self.myDataManager saveContact:contactToSave];
            }
        };
    }
}

@end
