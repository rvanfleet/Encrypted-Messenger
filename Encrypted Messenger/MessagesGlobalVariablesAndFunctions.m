//
//  MessagesGlobalVariablesAndFunctions.m
//  Encrypted Messenger
//
//  Created by Ryan Van Fleet on 4/22/14.
//  Copyright (c) 2014 Ryan Van Fleet. All rights reserved.
//

#import "MessagesGlobalVariablesAndFunctions.h"
#import "Contact.h"
#import "MyDataManager.h"

#define kCaesarCipherKey 3

@implementation MessagesGlobalVariablesAndFunctions

-(void)createAllGlobalVariables
{
    self.cipherPickerData = @[@"Caesar's Cipher",
                              @"Permutation",
                              @"Double Transposition"];
    
    self.myDataManager = [[MyDataManager alloc] init];
}

-(void)sendMessage:(NSString*)message withCipher:(NSString*)cipher toContact:(Contact*)contact
{
    NSString* ciphertext = [self getCiphertextWithCipher:cipher AndPlaintext:message];
    
    NSDictionary* dictionarySent = @{@"contact": contact,
                                     @"date": [NSDate date],
                                     @"ciphertext": message,
                                     @"cipher": @"",
                                     @"sentFromThisDevice": @"yes"};
    
    [self.myDataManager addMessage:dictionarySent];
    
    NSDictionary* dictionaryReceive = @{@"contact": contact,
                                        @"date": [NSDate date],
                                        @"ciphertext": ciphertext,
                                        @"cipher": cipher,
                                        @"sentFromThisDevice": @"no"};
    
    [self.myDataManager addMessage:dictionaryReceive];
}


-(NSString*)getCiphertextWithCipher:(NSString*)cipher AndPlaintext:(NSString*)plaintext
{
    NSString* ciphertext;
    
    //First cipher was selected - Caesar's Cipher
    if ([cipher isEqualToString:[self.cipherPickerData objectAtIndex:0]])
    {
        NSMutableString* ciphertextMutable = [[NSMutableString alloc] init];
        
        for (NSInteger index = 0; index < [plaintext length]; index++)
        {
            char currentPlaintextChar = [plaintext characterAtIndex:index];
            
            char currentCiphertextChar = currentPlaintextChar + kCaesarCipherKey;
            
            [ciphertextMutable appendString:[NSString stringWithFormat:@"%c", currentCiphertextChar]];
        }
        
        ciphertext = ciphertextMutable;
    }
    //Second cipher selected - Permutation
    else if ([cipher isEqualToString:[self.cipherPickerData objectAtIndex:1]])
    {
        NSMutableString* ciphertextMutable = [plaintext mutableCopy];
        
        //Exchange every character with its following character starting from the beginning
        //   and continuing to the second to last character in the plaintext
        for (NSInteger index = 0; index < [plaintext length] - 1; index++)
        {
            char currentPlaintextChar = [ciphertextMutable characterAtIndex:index];
            char nextPlaintextChar = [ciphertextMutable characterAtIndex:index + 1];
            
            NSRange currentRange;
            currentRange.location = index;
            currentRange.length = 1;
            
            [ciphertextMutable replaceCharactersInRange:currentRange
                                             withString:[NSString stringWithFormat:@"%c",
                                                         nextPlaintextChar]];
            
            NSRange nextRange;
            nextRange.location = index + 1;
            nextRange.length = 1;
            
            [ciphertextMutable replaceCharactersInRange:nextRange
                                             withString:[NSString stringWithFormat:@"%c",
                                                         currentPlaintextChar]];
        }
        
        ciphertext = ciphertextMutable;
    }
    //Third cipher selected - Double Transposition
    else if ([cipher isEqualToString:[self.cipherPickerData objectAtIndex:2]])
    {
        //Implement double transposition encryption
        ciphertext = plaintext;
    }
    //No cipher was selected
    else
    {
        ciphertext = plaintext;
    }
    
    return ciphertext;
}

-(NSString*)getPlaintextWithCipher:(NSString*)cipher AndCiphertext:(NSString*)ciphertext
{
    NSString* plaintext;
    
    //First cipher was selected - Caesar's Cipher
    if ([cipher isEqualToString:[self.cipherPickerData objectAtIndex:0]])
    {
        NSMutableString* plaintextMutable = [[NSMutableString alloc] init];
        
        for (NSInteger index = 0; index < [ciphertext length]; index++)
        {
            char currentCiphertextChar = [ciphertext characterAtIndex:index];
            
            char currentPlaintextChar = currentCiphertextChar - kCaesarCipherKey;
            
            [plaintextMutable appendString:[NSString stringWithFormat:@"%c", currentPlaintextChar]];
        }
        
        plaintext = plaintextMutable;
    }
    //Second cipher selected - Permutation
    else if ([cipher isEqualToString:[self.cipherPickerData objectAtIndex:1]])
    {
        NSMutableString* plaintextMutable = [ciphertext mutableCopy];
        
        //Exchange every character with its previous character starting from the second to
        //   last character and continuing to the first character in the plaintext
        for (NSInteger index = [ciphertext length] - 1; index > 0; index--)
        {
            char currentCiphertextChar = [plaintextMutable characterAtIndex:index];
            char previousCiphertextChar = [plaintextMutable characterAtIndex:index - 1];
            
            NSRange currentRange;
            currentRange.location = index;
            currentRange.length = 1;
            
            [plaintextMutable replaceCharactersInRange:currentRange
                                            withString:[NSString stringWithFormat:@"%c",
                                                        previousCiphertextChar]];
            
            NSRange previousRange;
            previousRange.location = index - 1;
            previousRange.length = 1;
            
            [plaintextMutable replaceCharactersInRange:previousRange
                                            withString:[NSString stringWithFormat:@"%c",
                                                        currentCiphertextChar]];
        }
        
        plaintext = plaintextMutable;
    }
    //Third cipher selected - Double Transposition
    else if ([cipher isEqualToString:[self.cipherPickerData objectAtIndex:2]])
    {
       //Implement double transposition decryption
        plaintext = ciphertext;
    }
    //No cipher was selected
    else
    {
        plaintext = ciphertext;
    }
    
    return plaintext;
}

@end
