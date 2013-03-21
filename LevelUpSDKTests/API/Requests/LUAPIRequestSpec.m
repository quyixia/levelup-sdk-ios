#import "LUAPIClient.h"
#import "LUAPIRequest.h"

SPEC_BEGIN(LUAPIRequestSpec)

describe(@"LUAPIRequest", ^{
  NSString *method = @"GET";
  NSString *path = @"/example";
  NSDictionary *parameters = @{@"test" : @1};

  beforeEach(^{
    [LUAPIClient setupWithAPIKey:@"anApiKey" developmentMode:YES];
  });

  // Object Lifecycle Methods

  describe(@"apiRequestWithMethod:path:parameters:", ^{
    it(@"returns a new LUAPIRequest with the given attributes, and includes the access token", ^{
      LUAPIRequest *result = [LUAPIRequest apiRequestWithMethod:method path:path parameters:parameters];

      [[result should] beKindOfClass:[LUAPIRequest class]];
      [[result.method should] equal:method];
      [[result.path should] equal:path];
      [[result.parameters should] equal:parameters];
      [[theValue(result.includeAccessToken) should] beYes];
    });
  });

  describe(@"apiRequestWithMethod:path:parameters:includeAccessToken:", ^{
    it(@"returns a new LUAPIRequest with the given attributes", ^{
      BOOL includeAccessToken = NO;
      LUAPIRequest *result = [LUAPIRequest apiRequestWithMethod:method path:path parameters:parameters includeAccessToken:includeAccessToken];

      [[result should] beKindOfClass:[LUAPIRequest class]];
      [[result.method should] equal:method];
      [[result.path should] equal:path];
      [[result.parameters should] equal:parameters];
      [[theValue(result.includeAccessToken) should] equal:theValue(includeAccessToken)];
    });
  });

  // Public Methods

  describe(@"urlRequest", ^{
    __block LUAPIRequest *apiRequest;

    beforeEach(^{
      apiRequest = [LUAPIRequest apiRequestWithMethod:method path:path parameters:parameters includeAccessToken:NO];
    });

    context(@"when includeAccessToken is NO", ^{
      it(@"returns the NSURLRequest generated by the LUAPIClient, with matching parameters", ^{
        NSURLRequest *expected = [[LUAPIClient sharedClient] requestWithMethod:method path:path parameters:parameters];

        [[[apiRequest urlRequest] should] equal:expected];
      });
    });

    context(@"when includeAccessToken is YES", ^{
      beforeEach(^{
        apiRequest.includeAccessToken = YES;
      });

      context(@"when an access token hasn't been set", ^{
        it(@"returns a request with matching parameters", ^{
          NSURLRequest *expected = [[LUAPIClient sharedClient] requestWithMethod:method path:path parameters:parameters];

          [[[apiRequest urlRequest] should] equal:expected];
        });
      });

      context(@"when an access token has been set", ^{
        beforeEach(^{
          [LUAPIClient sharedClient].accessToken = @"abc123";
        });

        it(@"adds the access token to the parameters", ^{
          NSMutableDictionary *expectedParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
          expectedParameters[@"access_token"] = [LUAPIClient sharedClient].accessToken;
          NSURLRequest *expected = [[LUAPIClient sharedClient] requestWithMethod:method path:path parameters:expectedParameters];

          [[[apiRequest urlRequest] should] equal:expected];
        });
      });
    });
  });

  // NSObject Methods

  describe(@"equality", ^{
    __block LUAPIRequest *request1, *request2;

    beforeEach(^{
      request1 = [LUAPIRequest apiRequestWithMethod:method path:path parameters:parameters includeAccessToken:NO];
      request2 = [LUAPIRequest apiRequestWithMethod:method path:path parameters:parameters includeAccessToken:NO];
    });

    describe(@"hash", ^{
      it(@"generates the same hash for an equivalent object", ^{
        [[theValue([request1 hash]) should] equal:theValue([request2 hash])];
      });

      it(@"generates different hashes if the method is different", ^{
        request2.method = @"POST";

        [[theValue([request1 hash]) shouldNot] equal:theValue([request2 hash])];
      });

      it(@"generates different hashes if the path is different", ^{
        request2.path = @"/newpath";

        [[theValue([request1 hash]) shouldNot] equal:theValue([request2 hash])];
      });

      it(@"generates different hashes if the parameters are different", ^{
        request2.parameters = @{@"test2" : @2};

        [[theValue([request1 hash]) shouldNot] equal:theValue([request2 hash])];
      });

      it(@"generates different hashes if the includeAccessToken setting is different", ^{
        request2.includeAccessToken = YES;

        [[theValue([request1 hash]) shouldNot] equal:theValue([request2 hash])];
      });
    });

    describe(@"isEqual:", ^{
      it(@"is true for an equivalent object", ^{
        [[request1 should] equal:request2];
      });

      it(@"is true for an equivalent object - reflexively", ^{
        [[request2 should] equal:request1];
      });

      it(@"is false if the methods are different", ^{
        request2.method = @"POST";

        [[request1 shouldNot] equal:request2];
      });

      it(@"is false if the paths are different", ^{
        request2.path = @"/newpath";

        [[request1 shouldNot] equal:request2];
      });

      it(@"is false if the parameters are different", ^{
        request2.parameters = @{@"test2" : @2};

        [[request1 shouldNot] equal:request2];
      });

      it(@"is false if the includeAccessToken setting is different", ^{
        request2.includeAccessToken = YES;

        [[request1 shouldNot] equal:request2];
      });
    });
  });
});

SPEC_END