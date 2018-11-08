//
//  BasePresenter.h
//  TheBank
//
//  Created by Debunk on 07/11/2018.
//  Copyright © 2018 Debunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BasePresenterProcotol <NSObject>

- (void)viewDidLoad;
- (void)viewWillAppear;
- (void)viewWillDisappear;

@end

@interface BasePresenter : NSObject <BasePresenterProcotol>

- (void)viewDidLoad;
- (void)viewWillAppear;
- (void)viewWillDisappear;

@end
