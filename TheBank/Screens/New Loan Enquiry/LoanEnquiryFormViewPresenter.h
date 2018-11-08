//
//  LoanEnquiryFormViewPresenter.h
//  TheBank
//
//  Created by Oren Shtark on 08/11/2018.
//  Copyright © 2018 DeBunk. All rights reserved.
//

#import "BasePresenter.h"
#import "LoanEnquiryFormViewProtocol.h"
#import "LoanServiceProtocol.h"

@protocol LoanEnquiryFormViewPresenterProtocol <NSObject>

@property (nonatomic, strong) id<LoanServiceProtocol> loanService;

- (void)sendLoanRequestToAddress:(NSString*)address
                          amount:(NSString*)amount
                        duration:(NSString*)duration
                     description:(NSString*)description
                           notes:(NSString*)notes;

@end

@interface LoanEnquiryFormViewPresenter : BasePresenter <LoanEnquiryFormViewPresenterProtocol>

- (instancetype)initWithView:(id<LoanEnquiryFormViewProtocol>)view;

@end
