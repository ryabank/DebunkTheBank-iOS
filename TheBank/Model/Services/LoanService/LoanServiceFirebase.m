//
//  LoanServiceFirebase.m
//  TheBank
//
//  Created by Debunk on 07/11/2018.
//  Copyright © 2018 Debunk. All rights reserved.
//

#import "LoanServiceFirebase.h"
#import "Firebase.h"

// db keys
// main keys
static NSString * const kClientsKey = @"clients";
static NSString * const kLoansKey = @"loans";
static NSString * const kUpdateTimestampKey = @"updateTimestamp";

// enquiry keys
static NSString * const kAmountKey = @"amount";
static NSString * const kIdentifierKey = @"identifier";
static NSString * const kStatusKey = @"status";
static NSString * const kDescriptionKey = @"description";
static NSString * const kNotesKey = @"notes";
static NSString * const kDurationKey = @"duration";
static NSString * const kLoanToAddressKey = @"loanToAddress";

@interface LoanServiceFirebase()

// loans
//@property (nonatomic, strong) NSMutableArray<LoanEnquiry*> *loanEnquiries;

// userId
@property (nonatomic, strong) NSString* userId;

// db ref
@property (nonatomic, strong) FIRDatabaseReference *ref;

@end

@interface LoanServiceFirebase (DBJoin)

- (void)getEntriesFromChild:(NSString*)joinChild appearingInChildQuery:(FIRDatabaseQuery*)childQuery completion:(void (^)(NSArray<FIRDataSnapshot*>* snapshots))completion;

@end

@implementation LoanServiceFirebase

+ (instancetype)sharedService {
    static LoanServiceFirebase *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[LoanServiceFirebase alloc] init];
        sharedService.ref = [[FIRDatabase database] reference];
        
//        sharedService.loanEnquiries = [sharedService mockLoanEnquiries];
    });
    
    return sharedService;
}

- (void)setUserIdentifier:(NSString *)userId {
    _userId = userId;
}

- (NSMutableArray<LoanEnquiry*>*)mockLoanEnquiries {
    LoanEnquiry *e1 = [[LoanEnquiry alloc] init];
    e1.loanAmount = @"1000";
    e1.blocksDuration = @"50";
    e1.status = EnquiryStatusApproved;
    
    LoanEnquiry *e2 = [[LoanEnquiry alloc] init];
    e1.loanAmount = @"10000";
    e1.blocksDuration = @"2000";
    e1.status = EnquiryStatusRejected;
    
    LoanEnquiry *e3 = [[LoanEnquiry alloc] init];
    e1.loanAmount = @"1000";
    e1.blocksDuration = @"10";
    e1.status = EnquiryStatusPending;
    
    return @[e1, e2, e3].mutableCopy;
}

#pragma mark LoanServiceProtocol methods

- (void)requestLoanEnquiries:(void(^)(NSArray<LoanEnquiry*>* enquiries))completion {
    if (self.userId == nil) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@", kClientsKey, self.userId, kLoansKey];
    FIRDatabaseQuery *query = [[self.ref child:path] queryOrderedByChild:kUpdateTimestampKey];
    
    [self getEntriesFromChild:kLoansKey appearingInChildQuery:query completion:^(NSArray<FIRDataSnapshot *> *snapshots) {
        NSMutableArray<LoanEnquiry*> *enquiries = [[NSMutableArray alloc] init];
        
        for (FIRDataSnapshot *snapshot in snapshots) {
            NSLog(@"%@", snapshot);
            LoanEnquiry *enquiry = [[LoanEnquiry alloc] init];
            enquiry.identifier = [NSString stringWithFormat:@"%@", snapshot.value[kIdentifierKey]];
            enquiry.loanAmount = [NSString stringWithFormat:@"%@", snapshot.value[kAmountKey]];
            enquiry.status = [snapshot.value[kStatusKey] intValue];
            
            [enquiries addObject:enquiry];
        }
        
        if (completion) {
            completion(enquiries);
        }
    }];
}

- (void)createLoanEnquiry:(LoanEnquiry*)enquiry completion:(void(^)(BOOL success, NSError *error))completion {
    if (self.userId == nil || enquiry == nil) {
        if (completion) {
            completion(NO, [NSError errorWithDomain:@"com.debunk.createLoan" code:-1 userInfo:nil]);
        }
        return;
    }
    
    // Create a new group dictionary data
    NSString *enquiryUUID = [NSUUID UUID].UUIDString;
    EnquiryStatus status = EnquiryStatusPending;
    NSDictionary *enquiryDict = @{ kIdentifierKey : enquiryUUID,
                                 kStatusKey : @(status),
                                 kUpdateTimestampKey : FIRServerValue.timestamp,
                                 kDescriptionKey : enquiry.enqueryDescription,
                                 kNotesKey : enquiry.notes,
                                 kAmountKey : enquiry.loanAmount,
                                 kDurationKey : enquiry.blocksDuration
//                                 kClientKey : @{self.userId : @(YES)},
                                 };
    
    // Add group to groups data
    [[[self.ref child:kLoansKey] child:enquiryUUID] setValue:enquiryDict];
    
    // Add group to user groups link data
    NSString *clientLoansPath = [NSString stringWithFormat:@"%@/%@/%@", kClientsKey, self.userId, kLoansKey];
    [[[self.ref child:clientLoansPath] child:enquiryUUID] setValue:@(YES)];
    
    if (completion) {
        completion(YES, nil);
    }
}

@end

@implementation LoanServiceFirebase (DBJoin)

- (void)getEntriesFromChild:(NSString*)joinChild appearingInChildQuery:(FIRDatabaseQuery*)childQuery completion:(void (^)(NSArray<FIRDataSnapshot*>*))completion {
    [childQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSEnumerator *enumerator = snapshot.children;
        __block NSMutableArray<FIRDataSnapshot*> *snapshots = [[NSMutableArray alloc] initWithCapacity:snapshot.childrenCount];
        
        dispatch_group_t dispathGroup = dispatch_group_create();
        
        NSUInteger index = 0;
        FIRDataSnapshot *snapshopObj = nil;
        while (snapshopObj = [enumerator nextObject]) {
            NSString *objId = snapshopObj.key;
            NSString *childPath = [NSString stringWithFormat:@"%@/%@", joinChild, objId];
            dispatch_group_enter(dispathGroup);
            [[self.ref child:childPath] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull objSnapshot) {
                
                [snapshots setObject:objSnapshot atIndexedSubscript:index];       // keep order correct
                dispatch_group_leave(dispathGroup);
            }];
            index++;
        }
        
        dispatch_group_notify(dispathGroup, dispatch_get_main_queue(), ^{
            if (completion) {
                completion(snapshots);
            }
        });
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", @"error");
    }];
}

@end
