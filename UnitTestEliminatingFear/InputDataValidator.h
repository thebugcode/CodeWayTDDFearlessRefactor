//
//  InputDataValidator.h
//  Jabba
//
//  Created by Nikolai Trandafil on 1/27/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InputDataValidator : NSObject

@property (strong, nonatomic) NSString *errorMessage;

- (BOOL)validateName:(NSString *)candidate;
- (BOOL)validateUserName:(NSString *)userName;
- (BOOL)validatePassword:(NSString *)password;
- (BOOL)validateEmail:(NSString *)mail;
- (BOOL)validateEmail:(NSString *)mail password:(NSString *)pass;
- (BOOL)validateMail:(NSString *)mail passwaord:(NSString *)pass firstName:(NSString *)firstName lastName:(NSString *)lastName userName:(NSString *)username;
- (BOOL)validateURL:(NSString *)url;
- (NSString *)addPrefixToURL:(NSString *)url;

@end
