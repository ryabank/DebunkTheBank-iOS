//
//  User+Firebase.m
//  TheBank
//
//  Created by Debunk on 08/11/2018.
//  Copyright © 2018 DeBunk. All rights reserved.
//

#import "User+Firebase.h"

@implementation User (Firebase)

+ (User*)userWithFIRUser:(FIRUser*)fUser {
    User *user = [[User alloc] init];
    user.email = fUser.email;
    user.identifier = fUser.uid;
    return user;
}

@end
