//
//  LoanEnquiriesViewProtocol.h
//  TheBank
//
//  Created by Debunk on 08/11/2018.
//  Copyright © 2018 Debunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoanEnquiry.h"

@protocol LoanEnquiriesViewProtocol <NSObject>

- (void)displayLoanEnquiryDialog;
- (void)displayLoanEnquiries:(NSArray<LoanEnquiry*>*)enquiries;

- (void)showEmptyState;
- (void)showLoggedInState;

- (void)showLoginDialog;
- (void)showSignupDialog;

- (void)showErrorWithTitle:(NSString*)title andMessage:(NSString*)message;

@end
