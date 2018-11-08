//
//  LoanEnquiryFormViewPresenter.m
//  TheBank
//
//  Created by Oren Shtark on 08/11/2018.
//  Copyright © 2018 DeBunk. All rights reserved.
//

#import "LoanEnquiryFormViewPresenter.h"

@interface LoanEnquiryFormViewPresenter ()

@property (nonatomic, weak) id<LoanEnquiryFormViewProtocol> view;

@end

@implementation LoanEnquiryFormViewPresenter

- (instancetype)initWithView:(id<LoanEnquiryFormViewProtocol>)view {
    if (self = [super init]) {
        _view = view;
    }
    
    return self;
}

#pragma mark LoanEnquiryFormViewPresenterProtocol methods

@synthesize loanService;

- (void)sendLoanRequestToAddress:(NSString*)address
                          amount:(NSString*)amount
                        duration:(NSString*)duration
                     description:(NSString*)description
                           notes:(NSString*)notes {
    static NSString *regexString = @"RYA-[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]-[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]-[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]-[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]";
    NSRegularExpression *addressRegex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                                  options:0 error:nil];
    NSArray *matches = [addressRegex matchesInString:address options:0 range:NSMakeRange(0, address.length)];
    if (matches.count == 0) {
        [self.view showErrorWithTitle:@"Incorrect Address" andMessage:@"Address must be in the format of\nRYA-XXXX-XXXX-XXXX-XXXX"];
        return;
    }
    
    if (amount.integerValue == 0) {
        [self.view showErrorWithTitle:@"Incorrect Amount" andMessage:@"Loan amount must be higher than 0"];
        return;
    }
    
    if (duration.integerValue == 0) {
        [self.view showErrorWithTitle:@"Incorrect Duration" andMessage:@"Loan duration must be higher than 0"];
        return;
    }
    
    if (description.length == 0) {
        [self.view showErrorWithTitle:@"Incorrect Description" andMessage:@"Loan description must not be empty"];
        return;
    }
    
    if (notes.length == 0) {
        [self.view showErrorWithTitle:@"Incorrect Notes" andMessage:@"Loan explaining must not be empty"];
        return;
    }
    
    LoanEnquiry *enquiry = [[LoanEnquiry alloc] init];
    enquiry.loanToAddress = address;
    enquiry.blocksDuration = [NSString stringWithFormat:@"%@", @(duration.floatValue * 1440)];
    enquiry.loanAmount = amount;
    enquiry.notes = notes;
    enquiry.enqueryDescription = description;
    
    [self.loanService createLoanEnquiry:enquiry completion:^(BOOL success, NSError *error) {
        if (!success || error != nil) {
            [self.view showErrorWithTitle:@"Loan Enquiry Failed" andMessage:@"There was an error requesting a loan, try again later."];
            return;
        }
        
        [self.view dismiss];
    }];
}

@end
