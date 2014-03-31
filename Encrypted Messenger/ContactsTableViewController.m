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

#pragma mark - Table View
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)           //User selected a row from the search results table view
    {
        [self performSegueWithIdentifier:@"MuscleGroupSegue" sender:nil];
    }
    
    if (self.isEditing)
    {
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        
        if ([cell.textLabel.text isEqualToString:@"Cardio"])
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Cannot Edit Cardio" message:@"You cannot edit the Cardio muscle group." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
        else
        {
            [self performSegueWithIdentifier:@"EditMuscleGroupSegue" sender:self];
        }
    }
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
                
                if ([self contactIsInTableView:dictionary])
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Contact Already In Table" message:@"The contact you wanted to add is already included in the table." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                }
                else
                {
                    [self.myDataManager addContact:dictionary];
                }
            }
        };
    }
}

-(BOOL)contactIsInTableView:(NSDictionary*)dictionary
{
    BOOL contactIsInTable = NO;
    
    NSString* firstNameToSearchFor = [dictionary objectForKey:@"firstName"];
    NSString* lastNameToSearchFor = [dictionary objectForKey:@"lastName"];
    
    for (NSInteger i = 0; i < [self.dataSource numberOfResultsInSection:0]; i++)
    {
        Contact* contact = [self.dataSource objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if ([contact.firstName isEqualToString:firstNameToSearchFor] &&
            [contact.lastName isEqualToString:lastNameToSearchFor])
        {
            contactIsInTable = YES;
            
            break;
        }
    }
    
    return contactIsInTable;
}

@end
