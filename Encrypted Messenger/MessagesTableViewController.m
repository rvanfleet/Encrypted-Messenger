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
#import "Message.h"
#import "SingleMessageViewController.h"
#import "ComposeMessageTableViewController.h"

@interface MessagesTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DataSource* dataSource;
@property (nonatomic,strong) MyDataManager *myDataManager;

@property (nonatomic, strong) Contact* contactSentToFromCompose;

@end

@implementation MessagesTableViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _myDataManager = [[MyDataManager alloc] init];
        _dataSource = [[DataSource alloc] initForEntity:@"Message"              //Get all messages
                                               sortKeys:@[@"date"]
                                              ascending:NO
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

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL)contactIsAlreadyInTableViewFromMessage:(Message*)message
{
    BOOL contactInTableView = NO;
    
    for (NSInteger index = 0; index < [self.dataSource numberOfResultsInSection:0]; index++)
    {
        Message* currentMessage = [self.dataSource objectAtIndexPath:
                                   [NSIndexPath indexPathForRow:index inSection:0]];
        
        if (currentMessage == message)
        {
            break;
        }
        else
        {
            if (currentMessage.contact == message.contact)
            {
                contactInTableView = YES;
                break;
            }
        }
    }
    
    return contactInTableView;
}

#pragma mark - Data Source Cell Configurer

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message* message = [self.dataSource objectAtIndexPath:indexPath];
    
    if ([self contactIsAlreadyInTableViewFromMessage:message])
    {
        return 0;
    }
    else
    {
        return 44;
    }
}

-(void)configureCell:(UITableViewCell *)cell withObject:(id)object
{
    Message* message = object;
    
    if ([self contactIsAlreadyInTableViewFromMessage:message])
    {
        cell.hidden = YES;
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                               message.contact.firstName,
                               message.contact.lastName];
        
        cell.detailTextLabel.text = @"";
    }
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
        
        Contact* contactToSegueTo;
        
        if (selectedIndexPath == nil)
        {
            contactToSegueTo = self.contactSentToFromCompose;
        }
        else
        {
            Message* selectedMessage = [self.dataSource objectAtIndexPath:selectedIndexPath];
            
            contactToSegueTo = selectedMessage.contact;
        }
        
        singleMessageViewController.contact = contactToSegueTo;
    }
    else if ([segue.identifier isEqualToString:@"ComposeMessageSegue"])
    {
        ComposeMessageTableViewController* composeMessageController = segue.destinationViewController;
        
        composeMessageController.completionBlock = ^(id obj){
            
            [self dismissViewControllerAnimated:YES completion:NULL];
            
            if (obj)
            {
                Contact* contact = obj;
                
                self.contactSentToFromCompose = contact;
                
                [self performSegueWithIdentifier:@"MessageSegue" sender:self];
            }
        };
    }
}

@end
