/*
 * Copyright (C) 2014 SCVNGR, Inc. d/b/a LevelUp
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "LUAPIRequest.h"
#import "LUCampaignRepresentationBasicV1JSONFactory.h"
#import "LUCampaignRepresentationSpendBasedLoyaltyV1JSONFactory.h"
#import "LUCampaignRepresentationVisitBasedLoyaltyV1JSONFactory.h"
#import "LUCampaignRequestFactory.h"

SPEC_BEGIN(LUCampaignRequestFactorySpec)

describe(@"LUCampaignRequestFactory", ^{
  // Public Methods

  describe(@"requestForCampaignMetadataForLocationWithID:", ^{
    __block LUAPIRequest *request;

    beforeEach(^{
      request = [LUCampaignRequestFactory requestForCampaignMetadataForLocationWithID:@1];
    });

    it(@"returns a GET request", ^{
      [[request.method should] equal:@"GET"];
    });

    it(@"returns a request to the path 'locations/<id>/campaigns'", ^{
      [[request.path should] equal:@"locations/1/campaigns"];
    });

    it(@"returns a request to version 15 of the API", ^{
      [[request.apiVersion should] equal:LUAPIVersion15];
    });

    it(@"returns a request with no parameters", ^{
      [request.parameters shouldBeNil];
    });
  });

  describe(@"requestForCampaignMetadataForMerchantWithID:", ^{
    __block LUAPIRequest *request;

    beforeEach(^{
      request = [LUCampaignRequestFactory requestForCampaignMetadataForMerchantWithID:@1];
    });

    it(@"returns a GET request", ^{
      [[request.method should] equal:@"GET"];
    });

    it(@"returns a request to the path 'merchants/<id>/campaigns'", ^{
      [[request.path should] equal:@"merchants/1/campaigns"];
    });

    it(@"returns a request to version 15 of the API", ^{
      [[request.apiVersion should] equal:LUAPIVersion15];
    });

    it(@"returns a request with no parameters", ^{
      [request.parameters shouldBeNil];
    });
  });

  describe(@"requestForCampaignWithCode:", ^{
    __block LUAPIRequest *request;
    NSString *code = @"code";

    beforeEach(^{
      request = [LUCampaignRequestFactory requestForCampaignWithCode:code];
    });

    it(@"returns a GET request", ^{
      [[request.method should] equal:@"GET"];
    });

    it(@"returns a request to the path 'codes/<code>/campaign'", ^{
      NSString *expectedPath = [NSString stringWithFormat:@"codes/%@/campaign", code];

      [[request.path should] equal:expectedPath];
    });

    it(@"returns a request to version 14 of the API", ^{
      [[request.apiVersion should] equal:LUAPIVersion14];
    });

    it(@"returns a request with no parameters", ^{
      [request.parameters shouldBeNil];
    });
  });

  describe(@"requestForCampaignWithID:", ^{
    __block LUAPIRequest *request;

    beforeEach(^{
      request = [LUCampaignRequestFactory requestForCampaignWithID:@1];
    });

    it(@"returns a GET request", ^{
      [[request.method should] equal:@"GET"];
    });

    it(@"returns a request to the path 'campaigns/<id>'", ^{
      [[request.path should] equal:@"campaigns/1"];
    });

    it(@"returns a request to version 14 of the API", ^{
      [[request.apiVersion should] equal:LUAPIVersion14];
    });

    it(@"returns a request with no parameters", ^{
      [request.parameters shouldBeNil];
    });
  });

  describe(@"requestForCampaignWithMetadata:representationType:", ^{
    context(@"when the campaign metadata contains the representation type", ^{
      __block LUAPIRequest *request;

      beforeEach(^{
        request = [LUCampaignRequestFactory requestForCampaignWithMetadata:[LUCampaignMetadata fixtureWithBasicRepresentation]
                                                        representationType:LUCampaignRepresentationTypeBasicV1];
      });

      it(@"returns a GET request", ^{
        [[request.method should] equal:@"GET"];
      });

      it(@"returns a request to the path 'campaigns/<id>/<representation type string>'", ^{
        [[request.path should] equal:@"campaigns/1/basic_v1"];
      });

      it(@"returns a request to version 15 of the API", ^{
        [[request.apiVersion should] equal:LUAPIVersion15];
      });

      it(@"returns a request with no parameters", ^{
        [request.parameters shouldBeNil];
      });

      context(@"when the representation type is LUCampaignRepresentationTypeBasicV1", ^{
        it(@"returns a request with a LUCampaignRepresentationBasicV1JSONFactory modelFactory", ^{
          [[request.modelFactory should] beKindOfClass:[LUCampaignRepresentationBasicV1JSONFactory class]];
        });
      });

      context(@"when the representation type is LUCampaignRepresentationTypeSpendBasedLoyaltyV1", ^{
        beforeEach(^{
          request = [LUCampaignRequestFactory requestForCampaignWithMetadata:[LUCampaignMetadata fixtureWithSpendBasedLoyaltyRepresentation]
                                                          representationType:LUCampaignRepresentationTypeSpendBasedLoyaltyV1];
        });

        it(@"returns a request with a LUCampaignRepresentationSpendBasedLoyaltyV1JSONFactory modelFactory", ^{
          [[request.modelFactory should] beKindOfClass:[LUCampaignRepresentationSpendBasedLoyaltyV1JSONFactory class]];
        });
      });

      context(@"when the representation type is LUCampaignRepresentationTypeVisitBasedLoyaltyV1", ^{
        beforeEach(^{
          request = [LUCampaignRequestFactory requestForCampaignWithMetadata:[LUCampaignMetadata fixtureWithVisitBasedLoyaltyRepresentation]
                                                          representationType:LUCampaignRepresentationTypeVisitBasedLoyaltyV1];
        });

        it(@"returns a request with a LUCampaignRepresentationVisitBasedLoyaltyV1JSONFactory modelFactory", ^{
          [[request.modelFactory should] beKindOfClass:[LUCampaignRepresentationVisitBasedLoyaltyV1JSONFactory class]];
        });
      });
    });

    context(@"when the campaign metadata does not contain the representation type", ^{
      it(@"raises an exception", ^{
        [[theBlock(^{
          [LUCampaignRequestFactory requestForCampaignWithMetadata:[LUCampaignMetadata fixtureWithBasicRepresentation]
                                                representationType:LUCampaignRepresentationTypeSpendBasedLoyaltyV1];
        }) should] raise];
      });
    });
  });

  describe(@"requestForMerchantsForCampaignWithID:", ^{
    __block LUAPIRequest *request;

    beforeEach(^{
      request = [LUCampaignRequestFactory requestForMerchantsForCampaignWithID:@1];
    });

    it(@"returns a GET request", ^{
      [[request.method should] equal:@"GET"];
    });

    it(@"returns a request to the path 'campaigns/<id>/merchants'", ^{
      [[request.path should] equal:@"campaigns/1/merchants"];
    });

    it(@"returns a request to version 14 of the API", ^{
      [[request.apiVersion should] equal:LUAPIVersion14];
    });

    it(@"returns a request with no parameters", ^{
      [request.parameters shouldBeNil];
    });
  });
});

SPEC_END
