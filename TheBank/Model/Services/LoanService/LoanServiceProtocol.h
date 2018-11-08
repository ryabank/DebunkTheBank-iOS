//
//  LoanServiceProtocol.h
//  TheBank
//
//  Created by Debunk on 07/11/2018.
//  Copyright © 2018 Debunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoanEnquiry.h"

@protocol LoanServiceProtocol <NSObject>

// Loan Enquiries
- (void)requestLoanEnquiries:(void(^)(NSArray<LoanEnquiry*>* enquiries))completion;

- (void)createLoanEnquiry:(LoanEnquiry*)enquiry completion:(void(^)(BOOL success, NSError *error))completion;

@end
