// Copyright 2013 SCVNGR, Inc., D.B.A. LevelUp. All rights reserved.

#import "LULocationJSONFactory.h"

SPEC_BEGIN(LULocationJSONFactorySpec)

describe(@"LULocationJSONFactory", ^{
  __block LULocationJSONFactory *factory;

  beforeEach(^{
    factory = [LULocationJSONFactory factory];
  });

  describe(@"createFromAttributes:", ^{
    it(@"parses a JSON dictionary into an LULocation", ^{
      LULocation *location = [factory createFromAttributes:[LULocation fullJSONObject]];

      [[location.categoryIDs should] equal:@[@1, @2, @3]];
      [[location.descriptionHTML should] equal:@"pizza, pizza, pizza!"];
      [[location.extendedAddress should] equal:@"Apt E"];
      [[location.hours should] equal:@"M-F 9am-5pm"];
      [[location.latitude should] equal:@70];
      [[location.locality should] equal:@"Boston"];
      [[location.locationID should] equal:@1];
      [[location.longitude should] equal:@-45];
      [[location.merchantID should] equal:@1];
      [[location.merchantName should] equal:@"Dewey, Cheatem and Howe"];
      [[location.name should] equal:@"Test Location"];
      [[location.phone should] equal:@"617-123-1234"];
      [[location.postalCode should] equal:@"01234"];
      [[location.region should] equal:@"MA"];
      [[theValue(location.shown) should] beYes];
      [[location.streetAddress should] equal:@"1 Main St"];
      [[theValue(location.summary) should] beNo];
      [[[location.webLocations facebookURL] should] equal:[NSURL URLWithString:@"http://facebook.com/pizza"]];
      [[[location.webLocations menuURL] should] equal:[NSURL URLWithString:@"http://pizza.com/menu"]];
      [[[location.webLocations newsletterURL] should] equal:[NSURL URLWithString:@"http://pizza.com/newsletter"]];
      [[[location.webLocations opentableURL] should] equal:[NSURL URLWithString:@"http://opentable.com/pizza"]];
      [[[location.webLocations twitterURL] should] equal:[NSURL URLWithString:@"http://twitter.com/pizza"]];
      [[[location.webLocations yelpURL] should] equal:[NSURL URLWithString:@"http://yelp.com/pizza"]];
      [[location.updatedAtDate should] equal:[NSDate fixture]];
    });
  });

  describe(@"rootKey", ^{
    it(@"is 'location'", ^{
      [[[factory rootKey] should] equal:@"location"];
    });
  });
});

SPEC_END
