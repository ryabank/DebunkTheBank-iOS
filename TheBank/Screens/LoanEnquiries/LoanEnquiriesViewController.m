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
#import "AuthServiceFirebase.h"

#import "LoanEnquiryTableViewCell.h"

@interface LoanEnquiriesViewController () <LoanEnquiriesViewProtocol>

@property (nonatomic, strong) id<LoanEnquiriesViewPresenterProtocol> presenter;

@property (nonatomic, strong) NSArray<LoanEnquiry*> *enquiries;
@property (weak, nonatomic) IBOutlet UITableView *loansTableView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addEnquiryButton;

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
    self.presenter.loanService = service;
    self.presenter.authService = [AuthServiceFirebase sharedService];
    
    self.loginButton.layer.cornerRadius = 5.0;
    self.loginButton.layer.borderColor = UIColor.grayColor.CGColor;
    self.loginButton.layer.borderWidth = 1.0;
    self.signupButton.layer.cornerRadius = 5.0;
    self.signupButton.layer.borderColor = UIColor.grayColor.CGColor;
    self.signupButton.layer.borderWidth = 1.0;
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

- (IBAction)addEnquiryButtonClicked:(id)sender {
    [self.presenter newEnquiry];
}

- (IBAction)loginButtonClicked:(id)sender {
    [self.presenter loginButton];
}

- (IBAction)signupButtonClicked:(id)sender {
    [self.presenter signupButton];
}

- (IBAction)logoutButtonClicked:(id)sender {
    [self.presenter logoutButton];
}

#pragma mark LoanEnquiriesViewProtocol methods

- (void)displayLoanEnquiryForm {
    
}

- (void)displayLoanEnquiries:(NSArray<LoanEnquiry *> *)enquiries {
    self.enquiries = enquiries;
    [self.loansTableView reloadData];
}

- (void)showEmptyState {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.loansTableView.hidden = YES;
    self.loginButton.hidden = NO;
    self.signupButton.hidden = NO;
}

- (void)showLoggedInState {
    self.navigationItem.leftBarButtonItem = self.logoutButtonItem;
    self.navigationItem.rightBarButtonItem = self.addEnquiryButton;
    self.loansTableView.hidden = NO;
    self.loginButton.hidden = YES;
    self.signupButton.hidden = YES;
}

- (void)showErrorWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [errorAlert addAction:okAction];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)showLoginDialog {
    UIAlertController *loginAlert = [UIAlertController alertControllerWithTitle:@"Login" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sendAction = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.presenter loginEmail:loginAlert.textFields[0].text
                          password:loginAlert.textFields[1].text];
    }];
    
    [loginAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"email";
    }];
    [loginAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"password";
    }];
    
    [loginAlert addAction:cancelAction];
    [loginAlert addAction:sendAction];
    
    [self presentViewController:loginAlert animated:YES completion:nil];
}

- (void)showSignupDialog {
    UIAlertController *loginAlert = [UIAlertController alertControllerWithTitle:@"Sign Up" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sendAction = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.presenter signupEmail:loginAlert.textFields[0].text
                           password:loginAlert.textFields[1].text];
    }];
    
    [loginAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"email";
    }];
    [loginAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"password";
    }];
    
    [loginAlert addAction:cancelAction];
    [loginAlert addAction:sendAction];
    
    [self presentViewController:loginAlert animated:YES completion:nil];
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
    cell.detailTextLabel.textColor = [self statusColor:enquiry.status];
    
    if (enquiry.status == EnquiryStatusEnded) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LoanEnquiry *enquiry = self.enquiries[indexPath.row];
    
    if (enquiry.status == EnquiryStatusEnded) {
        // we can't return a returned loan
        return;
    }
    
    UIAlertController *returnAlert = [UIAlertController alertControllerWithTitle:@"Return Loan"
                                                                         message:@"Would you like to return this loan now?"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *returnAction = [UIAlertAction actionWithTitle:@"Return Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.presenter selectEnquiryWithIdentifier:enquiry.identifier];
    }];
    
    [returnAlert addAction:cancelAction];
    [returnAlert addAction:returnAction];
    
    [self presentViewController:returnAlert animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIColor*)statusColor:(EnquiryStatus)status {
    switch (status) {
        case EnquiryStatusPending:
            return [UIColor colorWithRed:244.0/255.0 green:190.0/255.0 blue:66.0/255.0 alpha:1];
            break;
        case EnquiryStatusApproved:
            return [UIColor colorWithRed:66.0/255.0 green:190.0/255.0 blue:90.0/255.0 alpha:1];
            break;
        case EnquiryStatusRejected:
            return [UIColor redColor];
            break;
        case EnquiryStatusEnded:
            return [UIColor lightGrayColor];
            break;
        case EnquiryStatusCancelled:
            return [UIColor lightGrayColor];
            break;
        default:
            return [UIColor lightGrayColor];
            break;
    }
}

@end
