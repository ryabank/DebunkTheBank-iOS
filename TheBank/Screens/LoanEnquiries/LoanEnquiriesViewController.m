//
//  LoanEnquiriesViewController.m
//  TheBank
//
//  Created by Debunk on 07/11/2018.
//  Copyright © 2018 Debunk. All rights reserved.
//

#import "LoanEnquiriesViewController.h"
#import "LoanEnquiriesViewProtocol.h"
#import "LoanEnquiriesViewPresenter.h"
#import "LoanServiceFirebase.h"

#import "LoanEnquiryTableViewCell.h"

@interface LoanEnquiriesViewController () <LoanEnquiriesViewProtocol>

@property (nonatomic, strong) id<LoanEnquiriesViewPresenterProtocol> presenter;

@property (nonatomic, strong) NSArray<LoanEnquiry*> *enquiries;
@property (weak, nonatomic) IBOutlet UITableView *loansTableView;

@end

@interface LoanEnquiriesViewController (TableView) <UITableViewDelegate, UITableViewDataSource>

@end

@implementation LoanEnquiriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loansTableView.dataSource = self;
    self.loansTableView.delegate = self;
    
    self.presenter = [[LoanEnquiriesViewPresenter alloc] initWithView:self];
    LoanServiceFirebase *service = [LoanServiceFirebase sharedService];
    [service setUserIdentifier:@"fakeId"];
    self.presenter.loanService = service;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.presenter viewWillAppear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)newEnquiryButtonClicked:(id)sender {
    [self.presenter newEnquiry];
}

#pragma mark LoanEnquiriesViewProtocol methods

- (void)displayLoanEnquiryDialog {
    UIAlertController *newEnquiryAlert = [UIAlertController alertControllerWithTitle:@"New Enquiry"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sendAction = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [newEnquiryAlert addAction:cancelAction];
    [newEnquiryAlert addAction:sendAction];
    
    [self presentViewController:newEnquiryAlert animated:YES completion:nil];
}

- (void)displayLoanEnquiries:(NSArray<LoanEnquiry *> *)enquiries {
    self.enquiries = enquiries;
    [self.loansTableView reloadData];
}

@end

const CGFloat kCellHeight = 44.0;

@implementation LoanEnquiriesViewController (TableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.enquiries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoanEnquiryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLoanEnquiryCellIdentifier];
    
    LoanEnquiry *enquiry = self.enquiries[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Loan amount: %@", enquiry.loanAmount];
    cell.detailTextLabel.text = enquiry.statusString;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

@end
