//
//  ServiceCoordinator.m
//  TheBank
//
//  Created by Debunk on 08/11/2018.
//  Copyright © 2018 DeBunk. All rights reserved.
//

#import "ServiceCoordinator.h"
#import "AuthServiceFirebase.h"
#import "LoanServiceFirebase.h"

@implementation ServiceCoordinator

+ (ServiceCoordinator*)sharedServiceCoordinator {
    static ServiceCoordinator* sharedServiceCoordinator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedServiceCoordinator = [[ServiceCoordinator alloc] init];
    });
    return sharedServiceCoordinator;
}

+ (void)update {
    [[ServiceCoordinator sharedServiceCoordinator] updateDataServiceFromUserService];
}

- (void)updateDataServiceFromUserService {
//    [LoanServiceFirebase.sharedService setUserIdentifier:AuthServiceFirebase.sharedService.currentUser.identifier];
}

@end
