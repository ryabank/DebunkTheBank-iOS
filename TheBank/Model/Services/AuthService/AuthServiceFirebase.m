//
//  AuthServiceFirebase.m
//  TheBank
//
//  Created by Debunk on 08/11/2018.
//  Copyright © 2018 DeBunk. All rights reserved.
//

#import "AuthServiceFirebase.h"
#import "Firebase.h"
#import "User+Firebase.h"

#import "ServiceCoordinator.h"

@interface AuthServiceFirebase ()

@property (nonatomic, strong) FIRAuth *auth;

@end

@implementation AuthServiceFirebase

+ (instancetype)sharedService {
    static AuthServiceFirebase *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[AuthServiceFirebase alloc] init];
        
        sharedService.auth = [FIRAuth auth];
        [sharedService.auth addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
            [ServiceCoordinator update];
        }];
    });
    
    return sharedService;
}

- (BOOL)isLoggedIn {
    return self.auth.currentUser != nil;
}

- (User*)currentUser {
    return [User userWithFIRUser:self.auth.currentUser];
}

- (void)createUserEmail:(NSString*)email password:(NSString*)password completion:(void(^)(User *user, NSError *error))completion {
    [self.auth createUserWithEmail:email password:password
                        completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                            if (error || authResult.user == nil) {
                                if (completion) {
                                    error = error ?: [NSError errorWithDomain:@"com.debunk.auth" code:-1 userInfo:nil];
                                    completion(nil, error);
                                }
                                return;
                            }
                            
                            [ServiceCoordinator update];
                            
//                            FIRUser *fUser = authResult.user
                            if (completion) {
                                completion(self.currentUser, nil);
                            }
                        }];
}

- (void)authenticateUserEmail:(NSString *)email password:(NSString *)password completion:(void (^)(User *, NSError *))completion {
    [self.auth signInWithEmail:email password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (error || authResult.user == nil) {
            if (completion) {
                error = error ?: [NSError errorWithDomain:@"com.debunk.auth" code:-1 userInfo:nil];
                completion(nil, error);
            }
            return;
        }
        
        [ServiceCoordinator update];
        
//        FIRUser *fUser = authResult.user;
        if (completion) {
            completion(self.currentUser, nil);
        }
    }];
}

- (void)logout {
    [self.auth signOut:nil];
}

@end
