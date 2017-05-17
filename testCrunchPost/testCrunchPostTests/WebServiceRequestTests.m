//
//  WebServiceRequestTests.m
//  NextGenApp
//
//  Created by Juliana Cipa on 17/05/2017.
//  Copyright © 2017 Apptivation. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebServiceRequest.h"

@interface WebServiceRequestTests : XCTestCase

@end

@implementation WebServiceRequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPostExpenses {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Test post transactions"];

    NSDictionary *transactions = @{
        @"expenseDetails": @{
            @"supplier": @{
                @"name": @"Halifax"
            },
            @"supplierReference" : @"My new expense",
            @"postingDate": @"2017-05-17"
        },
        @"paymentDetails": @{
            @"payment": @[
                        @{
                            @"paymentDate": @"2017-05-17",
                            @"paymentMethod": @"DEBIT_CARD",
                            @"bankAccount": @{
                                @"account": @"lloyds"
                            },
                            @"amount": @2020
                        }
                        ],
            @"count": @1
        },
        @"expenseLineItems": @{
            @"count": @1,
            @"lineItemGrossTotal": @2020,
            @"expenseLineItems": @[
                                 @{
                                     @"expenseType": @"MILEAGE_ALLOWANCE",
                                     @"lineItemDescription": @"petrol",
                                     @"lineItemAmount": @{
                                         @"grossAmount": @2020
                                     }
                                 }
                                 ]
        }
        };

    [WebServiceRequest startPostRequestWithTransactions:transactions
                                                handler:^(NSDictionary *response, NSError *error) {
        XCTAssertNil(error, @"there should not be an error");
        XCTAssertNil(response, @"response should be nil");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:60 handler:nil];
}

@end
