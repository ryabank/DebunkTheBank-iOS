//
//  LoanEnquiry.m
//  TheBank
//
//  Created by Debunk on 07/11/2018.
//  Copyright © 2018 Debunk. All rights reserved.
//

#import "LoanEnquiry.h"

@implementation LoanEnquiry

- (NSString*)statusString {
    switch (self.status) {
        case EnquiryStatusPending:
            return @"Pending";
            break;
        case EnquiryStatusApproved:
            return @"Approved";
            break;
        case EnquiryStatusRejected:
            return @"Rejected";
            break;
        case EnquiryStatusCancelled:
            return @"Cancelled";
            break;
        default:
            return @"Unknown";
            break;
    }
}

@end
