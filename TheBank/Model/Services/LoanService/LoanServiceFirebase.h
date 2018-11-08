//
//  LoanServiceFirebase.h
//  TheBank
//
//  Created by Debunk on 07/11/2018.
//  Copyright © 2018 Debunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoanServiceProtocol.h"

@interface LoanServiceFirebase : NSObject <LoanServiceProtocol>

+ (instancetype)sharedService;

- (void)setUserIdentifier:(NSString*)userId;

@end
