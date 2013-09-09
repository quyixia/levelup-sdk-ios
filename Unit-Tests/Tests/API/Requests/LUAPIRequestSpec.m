// Copyright 2013 SCVNGR, Inc., D.B.A. LevelUp. All rights reserved.

#import "LUAbstractJSONModelFactory.h"
#import "LUAPIClient.h"
#import "LUAPIRequest.h"

SPEC_BEGIN(LUAPIRequestSpec)

describe(@"LUAPIRequest", ^{
  NSString *method = @"GET";
  NSString *path = @"example";
  NSString *apiVersion = LUAPIVersion13;
  NSDictionary *parameters = @{@"test" : @1};
  LUAbstractJSONModelFactory *modelFactory = [LUAbstractJSONModelFactory mock];

  __block LUAPIRequest *apiRequest;

  beforeEach(^{
    [LUAPIClient setupWithAppID:@"1" APIKey:@"anApiKey" developmentMode:YES];
  });

  // Object Lifecycle Methods

  describe(@"apiRequestWithMethod:path:apiVersion:parameters:modelFactory:", ^{
    it(@"returns a new LUAPIRequest with the given arguments", ^{
      LUAPIRequest *result = [LUAPIRequest apiRequestWithMethod:method path:path apiVersion:apiVersion parameters:parameters modelFactory:modelFactory];

      [[result should] beKindOfClass:[LUAPIRequest class]];
      [[result.method should] equal:method];
      [[result.path should] equal:path];
      [[result.apiVersion should] equal:apiVersion];
      [[result.parameters should] equal:parameters];
      [[result.modelFactory should] equal:modelFactory];
    });
  });

  // Public Methods

  describe(@"URLRequest", ^{
    beforeEach(^{
      apiRequest = [LUAPIRequest apiRequestWithMethod:method path:path apiVersion:apiVersion parameters:parameters modelFactory:modelFactory];
    });

    context(@"when includeAccessToken is NO", ^{
      it(@"returns the NSURLRequest generated by the LUAPIClient, with matching parameters", ^{
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", apiVersion, path];
        NSURLRequest *expected = [[LUAPIClient sharedClient] requestWithMethod:method path:fullPath parameters:parameters];

        [[[apiRequest URLRequest] should] equal:expected];
      });
    });
  });

  // NSObject Methods

  describe(@"equality", ^{
    __block LUAPIRequest *request1, *request2;

    beforeEach(^{
      request1 = [LUAPIRequest apiRequestWithMethod:method path:path apiVersion:apiVersion parameters:parameters modelFactory:modelFactory];
      request2 = [LUAPIRequest apiRequestWithMethod:method path:path apiVersion:apiVersion parameters:parameters modelFactory:modelFactory];
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

      it(@"generates different hashes if the apiVersion is different", ^{
        request2.apiVersion = @"newVersion";

        [[theValue([request1 hash]) shouldNot] equal:theValue([request2 hash])];
      });

      it(@"generates different hashes if the parameters are different", ^{
        request2.parameters = @{@"test2" : @2};

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

      it(@"is false if the API versions are different", ^{
        request2.apiVersion = @"newVersion";

        [[request1 shouldNot] equal:request2];
      });

      it(@"is false if the parameters are different", ^{
        request2.parameters = @{@"test2" : @2};

        [[request1 shouldNot] equal:request2];
      });
    });
  });
});

SPEC_END
