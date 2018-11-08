//
//  LoanEnquiryFormViewProtocol.h
//  TheBank
//
//  Created by Oren Shtark on 08/11/2018.
//  Copyright © 2018 DeBunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoanEnquiryFormViewProtocol <NSObject>

- (void)showErrorWithTitle:(NSString*)title andMessage:(NSString*)message;
- (void)dismiss;

@end
