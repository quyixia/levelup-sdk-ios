// Copyright 2013 SCVNGR, Inc., D.B.A. LevelUp. All rights reserved.

#import "LUAPIRequest.h"
#import "LULocationCreditRequestFactory.h"

SPEC_BEGIN(LULocationCreditRequestFactorySpec)

describe(@"LULocationCreditRequestFactory", ^{
  // Public Methods

  __block LUAPIRequest *request;

  describe(@"requestForCreditAtLocationID:", ^{
    beforeEach(^{
      request = [LULocationCreditRequestFactory requestForCreditAtLocationID:@1];
    });

    it(@"returns a GET request", ^{
      [[request.method should] equal:@"GET"];
    });

    it(@"returns a request to the path 'locations/:id/credit'", ^{
      [[request.path should] equal:@"locations/1/credit"];
    });

    it(@"returns a request to version 14 of the API", ^{
      [[request.apiVersion should] equal:LUAPIVersion14];
    });
  });
});

SPEC_END