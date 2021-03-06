//
//  MyDataManager.h
//  PSUDirectorySearch
//
//  Created by Ryan Van Fleet on 10/21/13.
//  Copyright (c) 2013 Ryan Van Fleet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManagerDelegate.h"
#import "Contact.h"

@interface MyDataManager : NSObject <DataManagerDelegate>

-(void)addContact:(NSDictionary*)dictionary;
-(void)addMessage:(NSDictionary*)dictionary;

-(void)saveContact:(Contact*)contact;

@end
