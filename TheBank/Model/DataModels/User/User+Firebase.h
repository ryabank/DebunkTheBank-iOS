//
//  User+Firebase.h
//  TheBank
//
//  Created by Debunk on 08/11/2018.
//  Copyright © 2018 DeBunk. All rights reserved.
//

#import "User.h"
#import "Firebase.h"

@interface User (Firebase)

+ (User*)userWithFIRUser:(FIRUser*)fUser;

@end
