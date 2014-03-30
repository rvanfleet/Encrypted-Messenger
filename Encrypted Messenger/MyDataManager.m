//
//  MyDataManager.m
//  PSUDirectorySearch
//
//  Created by Eileen Van Fleet on 10/21/13.
//  Copyright (c) 2013 Ryan Van Fleet. All rights reserved.
//

#import "MyDataManager.h"
#import "DataManager.h"
#import "Contact.h"
#import "Message.h"
#import "DataSource.h"

@implementation MyDataManager

-(NSString*)xcDataModelName
{
    return @"Messages";
}

-(void)createDatabaseFor:(DataManager *)dataManager                 //Create the database for the initial set of messages
{
}

-(void)addContact:(NSDictionary *)dictionary                        //Add a new contact to the database
{
    DataManager *dataManager = [DataManager sharedInstance];
    NSManagedObjectContext *managedObjectContext = dataManager.managedObjectContext;
    
    Contact* contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:managedObjectContext];
    
    contact.firstName = [dictionary objectForKey:@"firstName"];
    contact.lastName = [dictionary objectForKey:@"lastName"];
    contact.phoneNumber = [dictionary objectForKey:@"phoneNumber"];
    contact.emailAddress = [dictionary objectForKey:@"emailAddress"];
    
    [dataManager saveContext];
}

-(void)addMessage:(NSDictionary *)dictionary                        //Add a new message to the database
{
    DataManager *dataManager = [DataManager sharedInstance];
    NSManagedObjectContext *managedObjectContext = dataManager.managedObjectContext;
    
    Message* message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:managedObjectContext];
    
    message.contact = [dictionary objectForKey:@"contact"];
    message.date = [dictionary objectForKey:@"date"];
    message.ciphertext = [dictionary objectForKey:@"ciphertext"];
    message.cipher = [dictionary objectForKey:@"cipher"];
    
    [dataManager saveContext];
}

@end
