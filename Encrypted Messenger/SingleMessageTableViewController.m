//
//  SingleMessageTableViewController.m
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 4/2/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import "SingleMessageTableViewController.h"
#import "DataSource.h"
#import "MyDataManager.h"
#import "Message.h"

@interface SingleMessageTableViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UITextField *cipherTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

@property (strong, nonatomic) DataSource* dataSource;
@property (nonatomic, strong) MyDataManager *myDataManager;


@end

@implementation SingleMessageTableViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _myDataManager = [[MyDataManager alloc] init];
        
        _dataSource = [DataSource alloc];
        
        _dataSource.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"contact.identifier == %@", self.contact.identifier];
    
     self.dataSource = [self.dataSource initForEntity:@"Message"              //Get all messages
     sortKeys:@[@"date"]
     ascending:YES
     predicate:predicate
     sectionNameKeyPath:nil
     dataManagerDelegate:_myDataManager];
    
    self.tableView.dataSource = self.dataSource;
    self.dataSource.tableView = self.tableView;
    
    self.navigationBar.title = [NSString stringWithFormat:@"%@ %@", self.contact.firstName, self.contact.lastName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)send:(id)sender
{
    NSString* cipher = self.cipherTextField.text;
    NSString* message = self.messageTextField.text;
    
    NSString* ciphertext = [self getCiphertextWithCipher:cipher AndPlaintext:message];
    
    NSDictionary* dictionary = @{@"contact": self.contact,
                                 @"date": [NSDate date],
                                 @"ciphertext": ciphertext,
                                 @"cipher": cipher};
    
    [self.myDataManager addMessage:dictionary];
}

#pragma mark - Data Source Cell Configurer

-(void)configureCell:(UITableViewCell *)cell withObject:(id)object
{
    Message* message = object;
    
    NSString* cipher = message.cipher;
    NSString* ciphertext = message.ciphertext;
    
    NSString* plaintext = [self getPlaintextWithCipher:cipher AndCiphertext:ciphertext];
    
    cell.textLabel.text = plaintext;
}

-(NSString*)cellIdentifierForObject:(id)object
{
    return @"SingleMessageCell";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Text Field Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(NSString*)getCiphertextWithCipher:(NSString*)cipher AndPlaintext:(NSString*)plaintext
{
    return plaintext;
}

-(NSString*)getPlaintextWithCipher:(NSString*)cipher AndCiphertext:(NSString*)ciphertext
{
    return ciphertext;
}

@end
