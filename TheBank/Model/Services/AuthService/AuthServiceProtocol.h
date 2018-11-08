//
//  AuthServiceProtocol.h
//  TheBank
//
//  Created by Debunk on 08/11/2018.
//  Copyright © 2018 DeBunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol AuthServiceProtocol <NSObject>

- (BOOL)isLoggedIn;
- (User*)currentUser;

- (void)createUserEmail:(NSString*)email password:(NSString*)password completion:(void(^)(User *user, NSError *error))completion;
- (void)authenticateUserEmail:(NSString*)email password:(NSString*)password completion:(void(^)(User *user, NSError *error))completion;
- (void)logout;

@end
