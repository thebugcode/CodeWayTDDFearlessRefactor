//
//  InputDataValidator.m
//  Jabba
//
//  Created by Nikolai Trandafil on 1/27/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import "InputDataValidator.h"
static const NSInteger passwordMinimalLength = 8;
static const NSInteger UserNameMinimalLength = 5;
static const NSInteger UserNameMaximalLength = 16;

@implementation InputDataValidator

- (BOOL)validateEmail:(NSString *)mail password:(NSString *)pass {
    BOOL isNotShortPass = [pass length] >= 6;
    if (!isNotShortPass) {
        self.errorMessage = @"Password length should be longer than 8 characters!";
    }
    BOOL isValidUserName = [self validateUserName:mail];
    BOOL isValidEmail = [self validateEmail:mail];
    BOOL isValidFirstField = isValidUserName || isValidEmail;
    
    return isValidFirstField && isNotShortPass;
}


- (BOOL)validateMail:(NSString *)mail passwaord:(NSString *)pass firstName:(NSString *)firstName lastName:(NSString *)lastName userName:(NSString *)username {
    BOOL firstNameContainsWrongCharacter = [self validateName:firstName];
    BOOL lastNameContainsWrongCharacters = [self validateName:lastName];
    BOOL isNotShortPass = [self validatePassword:pass];
    BOOL isValidEmail = [self validateEmail:mail];
    BOOL isValidUserName = [self validateUserName:username];
    if (!isNotShortPass) {
        self.errorMessage = @"Password length should be longer than 8 characters!";
    }
    if (!isValidEmail) {
        self.errorMessage = @"Email is invalid";
    }
    if (!isValidUserName) {
        self.errorMessage = @"User name contains invalid characters";
    }
    
    return isNotShortPass && isValidEmail && firstNameContainsWrongCharacter && lastNameContainsWrongCharacters && isValidUserName;
}


- (BOOL)validatePassword:(NSString *)password {
    return [password length] >= passwordMinimalLength;
}


- (BOOL)validateName:(NSString *)candidate {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet letterCharacterSet];
    [characterSet addCharactersInString:@" '-"];
    BOOL nameIsValid = [self validateStringInCharacterSet:candidate characterSet:characterSet];
    if (!nameIsValid) {
        self.errorMessage = @"Name can contain only letters (a-z), hyphens (-) and apostrophe (').";
        
        return nameIsValid;
    }
    
    nameIsValid = candidate.length >= 2 && candidate.length <= 16;
    if (!nameIsValid) {
        self.errorMessage = @"Name length should be between 2 and 16 characters long";
        
        return nameIsValid;
    }
    
    return nameIsValid;
}


- (BOOL)validateStringInCharacterSet:(NSString *)string characterSet:(NSMutableCharacterSet *)characterSet {
    // Since we invert the character set if it is == NSNotFound then it is in the character set.
    return ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) ? NO : YES;
}


- (BOOL)validateEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL validate = [emailTest evaluateWithObject:candidate];
    if (!validate) {
        self.errorMessage = @"Email contains invalid characters";
    }
    
    return validate;
}


- (BOOL)validateUserName:(NSString *)userName {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@"._%+-]"];
    BOOL validate = [self validateStringInCharacterSet:userName characterSet:characterSet];
    if (validate) {
        validate = [self text:userName
                 minimaLength:UserNameMinimalLength
                maximalLength:UserNameMaximalLength];
    }
    if (!validate) {
        self.errorMessage = @"Username must be between 5 and 16 characters.\nUsername can contain only letters (a-z), numbers (0-9), hyphens (-) and underscores (_).";
    }
    
    return validate;
}


- (BOOL)text:(NSString *)text minimaLength:(NSInteger)minLength maximalLength:(NSInteger)maxLength {
    return text.length >= minLength && text.length <= maxLength;
}


- (BOOL)validateURL:(NSString *)url {
    if ([url isEqualToString:@""]) return YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    return [NSURLConnection canHandleRequest:request] && [self hasDomein:url];
}


- (BOOL)hasDomein:(NSString *)url {
    return [url componentsSeparatedByString:@"."].count >= 3;
}


- (NSString *)addPrefixToURL:(NSString *)url {
    if ([url isEqualToString:@""]) return url;
    NSString *http = @"http";
    NSString *https = @"https";
    
    BOOL containHttps = [url rangeOfString:https].location != NSNotFound;
    url = [url stringByReplacingOccurrencesOfString:https withString:@""];
    url = [url stringByReplacingOccurrencesOfString:http withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@":" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"//" withString:@""];
    
    NSString *fullURL = @"";
    NSString *www = @"";
    if (![self hasDomein:url]) {
        www = @"www.";
    }
    if (containHttps) {
        fullURL = [NSString stringWithFormat:@"%@://%@%@", https, www, url];
    } else {
        fullURL = [NSString stringWithFormat:@"%@://%@%@", http, www, url];
    }
    
    return fullURL;
}

@end
