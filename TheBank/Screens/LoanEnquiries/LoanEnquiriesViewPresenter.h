//
//  LoanEnquiriesViewPresenter.h
//  TheBank
//
//  Created by Debunk on 07/11/2018.
//  Copyright © 2018 Debunk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePresenter.h"
#import "LoanEnquiriesViewProtocol.h"
#import "AuthServiceProtocol.h"
#import "LoanServiceProtocol.h"

@protocol LoanEnquiriesViewPresenterProtocol <BasePresenterProcotol>

@property (nonatomic, strong) id<LoanServiceProtocol> loanService;
@property (nonatomic, strong) id<AuthServiceProtocol> authService;

- (void)loginButton;
- (void)signupButton;
- (void)logoutButton;

- (void)loginEmail:(NSString*)email password:(NSString*)password;
- (void)signupEmail:(NSString*)email password:(NSString*)password;

- (void)newEnquiry;
- (void)createEnquiryForAddress:(NSString*)address amount:(NSString*)amount andDuration:(NSString*)duration;

- (void)selectEnquiryWithIdentifier:(NSString*)identifier;

@end

@interface LoanEnquiriesViewPresenter : BasePresenter <LoanEnquiriesViewPresenterProtocol>

- (id)initWithView:(id<LoanEnquiriesViewProtocol>)view;

@end
