// Copyright 2013 SCVNGR, Inc., D.B.A. LevelUp. All rights reserved.

#import "LUCreditCardJSONFactory.h"

SPEC_BEGIN(LUCreditCardJSONFactorySpec)

describe(@"LUCreditCardJSONFactory", ^{
  __block LUCreditCardJSONFactory *factory;

  beforeEach(^{
    factory = [LUCreditCardJSONFactory factory];
  });

  describe(@"createFromAttributes:", ^{
    it(@"parses a JSON dictionary into an LUCreditCard", ^{
      LUCreditCard *creditCard = [factory createFromAttributes:[LUCreditCard fullJSONObject]];

      [[creditCard.creditCardDescription should] equal:@"description"];
      [[creditCard.creditCardID should] equal:@1];
      [[creditCard.expirationMonth should] equal:@11];
      [[creditCard.expirationYear should] equal:@13];
      [[creditCard.last4Digits should] equal:@"1234"];
      [[theValue(creditCard.promoted) should] beYes];
      [[creditCard.type should] equal:@"visa"];
    });
  });

  describe(@"rootKey", ^{
    it(@"is 'credit_card'", ^{
      [[[factory rootKey] should] equal:@"credit_card"];
    });
  });
});

SPEC_END
