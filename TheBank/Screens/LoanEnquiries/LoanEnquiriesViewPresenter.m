//
//  LoanEnquiriesViewPresenter.m
//  TheBank
//
//  Created by Debunk on 07/11/2018.
//  Copyright © 2018 Debunk. All rights reserved.
//

#import "LoanEnquiriesViewPresenter.h"

@interface LoanEnquiriesViewPresenter()

@property (nonatomic, weak) id<LoanEnquiriesViewProtocol> view;

@end

@implementation LoanEnquiriesViewPresenter

- (id)initWithView:(id<LoanEnquiriesViewProtocol>)view {
    if (self = [super init]) {
        _view = view;
    }
    return self;
}

#pragma mark LoanEnquiriesViewPresenterProtocol methods

@synthesize loanService;
@synthesize authService;

- (void)viewWillAppear {
    if (self.authService.isLoggedIn) {
        [self.view showLoggedInState];
        [self.loanService requestLoanEnquiries:^(NSArray<LoanEnquiry *> *enquiries) {
            [self.view displayLoanEnquiries:enquiries];
        }];
    }
    else {
        [self.view showEmptyState];
    }
}

- (void)viewWillDisappear {
    
}

- (void)newEnquiry {
    [self.view displayLoanEnquiryDialog];
}

- (void)createEnquiryForAddress:(NSString*)address amount:(NSString*)amount andDuration:(NSString*)duration {
    LoanEnquiry *enquiry = [[LoanEnquiry alloc] init];
    [self.loanService createLoanEnquiry:enquiry completion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)loginButton {
    [self.view showLoginDialog];
}

- (void)signupButton {
    [self.view showSignupDialog];
}

- (void)logoutButton {
    [self.authService logout];
    [self.view showEmptyState];
}

- (void)loginEmail:(NSString*)email password:(NSString*)password {
    [self.authService authenticateUserEmail:email password:password completion:^(User *user, NSError *error) {
        if (error || user == nil) {
            [self.view showErrorWithTitle:@"Error" andMessage:@"Incorrect email or password"];
            return;
        }
        
        [self.view showLoggedInState];
        [self.loanService requestLoanEnquiries:^(NSArray<LoanEnquiry *> *enquiries) {
            [self.view displayLoanEnquiries:enquiries];
        }];
    }];
}

- (void)signupEmail:(NSString *)email password:(NSString *)password {
    [self.authService createUserEmail:email password:password completion:^(User *user, NSError *error) {
        if (error || user == nil) {
            [self.view showErrorWithTitle:@"Error" andMessage:@"An error has occured, try again later"];
            return;
        }
        
        [self.view showLoggedInState];
    }];
}

@end
