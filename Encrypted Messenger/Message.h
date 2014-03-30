//
//  Message.h
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 3/30/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Message : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * ciphertext;
@property (nonatomic, retain) NSString * cipher;
@property (nonatomic, retain) NSManagedObject *contact;

@end
