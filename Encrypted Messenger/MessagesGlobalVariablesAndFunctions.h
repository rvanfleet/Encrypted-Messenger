//
//  MessagesGlobalVariablesAndFunctions.h
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 4/22/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyDataManager.h"

@interface MessagesGlobalVariablesAndFunctions : NSObject

@property (nonatomic, strong) MyDataManager *myDataManager;
@property (nonatomic, strong) NSArray* cipherPickerData;

-(void)createAllGlobalVariables;

-(void)sendMessage:(NSString*)message withCipher:(NSString*)cipher toContact:(Contact*)contact;
-(NSString*)getCiphertextWithCipher:(NSString*)cipher AndPlaintext:(NSString*)plaintext;
-(NSString*)getPlaintextWithCipher:(NSString*)cipher AndCiphertext:(NSString*)ciphertext;

@end
