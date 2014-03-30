//
//  MyDataManager.h
//  PSUDirectorySearch
//
//  Created by Eileen Van Fleet on 10/21/13.
//  Copyright (c) 2013 Ryan Van Fleet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManagerDelegate.h"

@interface MyDataManager : NSObject <DataManagerDelegate>

-(void)addContact:(NSDictionary*)dictionary;
-(void)addMessage:(NSDictionary*)dictionary;

@end
