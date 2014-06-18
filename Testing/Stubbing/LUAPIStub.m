// Copyright 2013 SCVNGR, Inc., D.B.A. LevelUp. All rights reserved.

#import "LUAPIClient.h"
#import "LUAPIStub.h"

@implementation LUAPIStub

#pragma mark - Object Creation

- (id)init {
  self = [super init];
  if (!self) return nil;

  _responseCode = 200;

  return self;
}

+ (LUAPIStub *)apiStubForVersion:(NSString *)apiVersion
                            path:(NSString *)path
                      HTTPMethod:(NSString *)HTTPMethod
                   authenticated:(BOOL)authenticated
                    responseData:(NSData *)responseData {
  LUAPIStub *stub = [[LUAPIStub alloc] init];
  stub.authenticated = authenticated;
  stub.HTTPMethod = HTTPMethod;
  stub.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@", [LUAPIClient sharedClient].baseURL, apiVersion, path]];
  stub.responseData = responseData;
  stub.responseType = @"application/json";

  return stub;
}

+ (LUAPIStub *)stubForWebURL:(NSURL *)URL withBody:(NSString *)body {
  LUAPIStub *stub = [[LUAPIStub alloc] init];
  stub.URL = URL;
  stub.HTTPMethod = @"GET";
  stub.responseData = [[NSString stringWithFormat:@"<html><body>%@</body></html>", body] dataUsingEncoding:NSUTF8StringEncoding];
  stub.responseType = @"text/html";
  return stub;
}

#pragma mark - Public Methods

- (BOOL)matchesRequest:(NSURLRequest *)request {
  if (![request.URL isEqual:[self URL]]) {
    return NO;
  }

  if (self.authenticated && ![request allHTTPHeaderFields][@"Authorization"]) {
    return NO;
  }

  if (self.HTTPMethod && ![request.HTTPMethod isEqualToString:self.HTTPMethod]) {
    return NO;
  }

  if (self.requestBodyJSON) {
    NSError *error;
    id requestJSON = [NSJSONSerialization JSONObjectWithData:[request HTTPBody] options:0 error:&error];
    if (!error && ![requestJSON isEqual:self.requestBodyJSON]) {
      return NO;
    }
  }

  return YES;
}

- (OHHTTPStubsResponse *)response {
  NSMutableDictionary *headers = [NSMutableDictionary dictionary];
  headers[@"Server"] = @"LevelUp";

  if (self.responseType) {
    headers[@"Content-Type"] = self.responseType;
  }

  [headers addEntriesFromDictionary:self.responseHeaders];

  return [OHHTTPStubsResponse responseWithData:self.responseData
                                    statusCode:(int)self.responseCode
                                  responseTime:0
                                       headers:headers];
}

- (NSDictionary *)responseJSON {
  return [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
}

#pragma mark - NSObject Methods

- (NSString *)description {
  return [NSString stringWithFormat:@"LUAPIStub [URL=%@, HTTPMethod=%@]", self.URL, self.HTTPMethod];
}

@end
