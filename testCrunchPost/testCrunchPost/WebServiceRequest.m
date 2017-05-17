//
//  WebServiceRequest.m
//  NextGenApp
//
//  Created by Juliana Cipa on 17/05/2017.
//  Copyright © 2017 Apptivation. All rights reserved.
//

#import "WebServiceRequest.h"

static NSString *const kEndPointForCrunchTransactions = @"https://sandbox.api.crunch.co.uk/rest/v2/expenses";

@implementation WebServiceRequest

#pragma mark - Private methods

+ (void)populateHandler:(WebServiceRequestHandler)handler
               withData:(NSData *)data
               andError:(NSError *)error {
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil, error);
        });
    } else {
        NSError *deserializationError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&deserializationError];

        if (deserializationError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil, deserializationError);
            });
        } else {
            NSDictionary *responseDict = (NSDictionary *)jsonObject;

            if (responseDict) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(responseDict, nil);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(nil, nil);
                });
            }
        }
    }
}

+ (NSMutableURLRequest *)requestForURL:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request addValue:@"TBD" forHTTPHeaderField:@"ConsumerKey"];
    [request addValue:@"b6c1f84a-571d-4f5c-86b6-447802be7070" forHTTPHeaderField:@"ConsumerSecret"];
    [request addValue:@"9e2b813a-40d8-435a-82d8-91e9f0a3c984" forHTTPHeaderField:@"Token"];
    [request addValue:@"b6c1f84a-571d-4f5c-86b6-447802be7070" forHTTPHeaderField:@"TokenSecret"];

    [request setHTTPMethod:@"POST"];

    return request;
}

+ (void)startRequest:(NSURLRequest *)request withHandler:(WebServiceRequestHandler)handler {
    DataTaskHandler dataTaskHandler = ^(NSData *data, NSURLResponse * __unused response, NSError *error) {
        [WebServiceRequest populateHandler:handler withData:data andError:error];
    };

    NSURLSession *sharedSession = [NSURLSession sharedSession];
    [[sharedSession dataTaskWithRequest:request completionHandler:dataTaskHandler] resume];
}

+ (NSData *)bodyDataForParameters:(NSDictionary *)paramParameters {

    NSError *jsonWritingError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramParameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jsonWritingError];
    if (jsonWritingError) {

        return nil;
    }
    else {

        return jsonData;
    }

}

#pragma mark - Public method

+ (void)startPostRequestWithTransactions:(NSDictionary *)transactions
                                 handler:(WebServiceRequestHandler)handler {
    if (handler) {
        NSMutableURLRequest *request = [WebServiceRequest requestForURL:kEndPointForCrunchTransactions];

        request.HTTPBody = [WebServiceRequest bodyDataForParameters:transactions];

        NSLog(@"***********************************************************");
        NSLog(@"%@", request);

        NSLog(@"%@", [request allHTTPHeaderFields]);

        [WebServiceRequest startRequest:request withHandler:handler];
    }
}

@end
