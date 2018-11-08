//
//  LoanEnquiry.h
//  TheBank
//
//  Created by Debunk on 07/11/2018.
//  Copyright © 2018 Debunk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum EnquiryStatus {
    EnquiryStatusPending = 1,
    EnquiryStatusApproved,
    EnquiryStatusRejected
} EnquiryStatus;

@interface LoanEnquiry : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *loanAmount;
@property (nonatomic, strong) NSString *blocksDuration;
@property (readwrite) EnquiryStatus status;

- (NSString*)statusString;

@end
