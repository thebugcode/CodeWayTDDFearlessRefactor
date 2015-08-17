//
//  InputDataValidatorTests.m
//  Jabba
//
//  Created by Eugen Spinu on 3/30/15.
//  Copyright (c) 2015 Yopeso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Expecta/Expecta.h>

#import "InputDataValidator.h"

@interface InputDataValidatorTests : XCTestCase
@property (strong, nonatomic) InputDataValidator *dataValidator;

@end

@implementation InputDataValidatorTests

- (void)setUp {
    [super setUp];
    self.dataValidator = [[InputDataValidator alloc] init];
}


- (void)tearDown {
    self.dataValidator = nil;
    [super tearDown];
}


- (void)testValidMail {
    for (NSString *mail in [self validMails]) {
        expect([self.dataValidator validateEmail:mail]).to.beTruthy();
    }
}


- (void)testInvalidMails {
    for (NSString *mail in [self inValidMails]) {
        expect([self.dataValidator validateEmail:mail]).to.beFalsy();
    }
}


- (void)testValidateURLs {
    for (NSString *url in [self validURLs]) {
        expect([self.dataValidator validateURL:url]).to.beTruthy();
    }
}


- (void)testInvalidateURLs {
    for (NSString *url in [self inValidURLs]) {
        expect([self.dataValidator validateURL:url]).to.beFalsy();
    }
    expect([self.dataValidator validateURL:nil]).to.beFalsy();
}


- (void)testValidUserNames {
    expect([self.dataValidator validateUserName:@"MyUserName"]).to.beTruthy();
    expect([self.dataValidator validateUserName:@"M5yU3ser3Nam3e"]).to.beTruthy();
    expect([self.dataValidator validateUserName:@"MyUser_Name"]).to.beTruthy();
    expect([self.dataValidator validateUserName:@"MyUser-Name"]).to.beTruthy();
    expect([self.dataValidator validateUserName:@"My-User_Name"]).to.beTruthy();
}


- (void)testInvalidNames {
    expect([self.dataValidator validateName:@"My2Name"]).to.beFalsy();
    expect([self.dataValidator validateName:@"My$Na^me"]).to.beFalsy();
    expect([self.dataValidator validateName:@"My2Na#$me"]).to.beFalsy();
}


- (void)testInValidUserNames {
    expect([self.dataValidator validateUserName:@"MyU%#serName"]).to.beFalsy();
    expect([self.dataValidator validateUserName:@"M5yU3s~er3Nam3e"]).to.beFalsy();
    expect([self.dataValidator validateUserName:@"MyUser_Na>me"]).to.beFalsy();
    expect([self.dataValidator validateUserName:@"MyUser Name"]).to.beFalsy();
    expect([self.dataValidator validateUserName:@"me"]).to.beFalsy();
    expect([self.dataValidator validateUserName:@"mesdasdasdasdadasdasdadasdasdassadasdaxzczcz"]).to.beFalsy();
}


- (void)testValidNames {
    expect([self.dataValidator validateName:@"My Name"]).to.beTruthy();
    expect([self.dataValidator validateName:@"MyName"]).to.beTruthy();
    expect([self.dataValidator validateName:@"MyName-Vasea"]).to.beTruthy();
    expect([self.dataValidator validateName:@"MyName'Vasea"]).to.beTruthy();
    expect([self.dataValidator validateName:@"M"]).to.beFalsy();
    expect([self.dataValidator validateName:@"MyNameIsMoreThanSixteenCharactersLong"]).to.beFalsy();
    expect([self.dataValidator validateName:@"My"]).to.beTruthy();
    expect([self.dataValidator validateName:@"SixteenCharacter"]).to.beTruthy();
}


- (void)testAddPrefixToURL {
    expect([self.dataValidator addPrefixToURL:@""]).equal(@"");
    expect([self.dataValidator addPrefixToURL:@"www.google.com"]).equal(@"http://www.google.com");
    expect([self.dataValidator addPrefixToURL:@"http://www.google.com"]).equal(@"http://www.google.com");
    expect([self.dataValidator addPrefixToURL:@"google.com"]).equal(@"http://www.google.com");
    expect([self.dataValidator addPrefixToURL:@"https://owncloud.yopeso.com"]).equal(@"https://owncloud.yopeso.com");
    expect([self.dataValidator addPrefixToURL:@"https://www.facebook.com/"]).equal(@"https://www.facebook.com/");
    expect([self.dataValidator addPrefixToURL:@"http://stackoverflow.com"]).equal(@"http://www.stackoverflow.com");
}


- (NSArray *)validURLs {
    NSArray *validURLs = @[@"http://www.stackoverflow.com", @"https://www.google.ru", @"http://www.rambler.ru/", @"https://www.facebook.com/", @""];
    
    return validURLs;
}


- (NSArray *)inValidURLs {
    NSArray *inValidURLs = @[@"google", @"google.com", @"noasd.asd.", @",sdf.sdf,$@%", @"bla://www.google.ru", @"www.rambler.ru", @"http:\\www.rambler.ru", @"https://www.google"];
    
    return inValidURLs;
}


- (NSArray *)validMails {
    NSArray *validMails = @[@"example@example.co.uk",
                            @"fabien_potencier@example.fr",
                            @"fabien@symfony.com", @"email@example-one.com",
                            @"_______@example.com", @"firstname-lastname@example.com"];
    
    return validMails;
}


- (NSArray *)inValidMails {
    NSArray *inValidMails = @[@"plainaddress", @"#@%^%#$@#$@#.com",
                              @"@example.com", @"Joe Smith <email@example.com>",
                              @"email.example.com", @"email@example@example.com",
                              @"email@example.com (Joe Smith)",
                              @"email@example", @"email@111.222.333.44444",
                              @"just”not”right@example.com", @"this is\"really\"not\allowed@example.com"];
    
    return inValidMails;
}

@end
