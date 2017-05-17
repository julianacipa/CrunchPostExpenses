//
//  WebServiceRequest.h
//  NextGenApp
//
//  Created by Juliana Cipa on 17/05/2017.
//  Copyright © 2017 Apptivation. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WebServiceRequestHandler)(NSDictionary *responseData, NSError *error);
typedef void (^DataTaskHandler)(NSData *data, NSURLResponse *response, NSError *error);

@interface WebServiceRequest : NSObject

+ (void)startPostRequestWithTransactions:(NSDictionary *)transactions
                                 handler:(WebServiceRequestHandler)handler;

@end
