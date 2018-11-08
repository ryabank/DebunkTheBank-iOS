//
//  AuthServiceFirebase.h
//  TheBank
//
//  Created by Debunk on 08/11/2018.
//  Copyright © 2018 DeBunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthServiceProtocol.h"

@interface AuthServiceFirebase : NSObject <AuthServiceProtocol>

+ (instancetype)sharedService;

@end
