// Copyright 2013 SCVNGR, Inc., D.B.A. LevelUp. All rights reserved.

#import "LUAPIModel.h"

/**
 `LUMonetaryValue` is used to represent an amount of money in a specific currency. Currently, only USD are supported.
 */
@interface LUMonetaryValue : LUAPIModel

/**
 The amount, in cents. So $1.00 would return 100.
 */
@property (nonatomic, copy, readonly) NSNumber *amount;

/**
 The currency code. Currently only "USD" is supported.
 */
@property (nonatomic, copy, readonly) NSString *currencyCode;

/**
 The symbol used to represent the currency. Currently on '$' (American Dollars) are supported.
 */
@property (nonatomic, copy, readonly) NSString *currencySymbol;

/**
 Returns the amount formatted with a string (but no symbol). For example "1.23" represents 1 dollar and 23 cents.
 */
@property (nonatomic, copy) NSString *formattedAmount;

- (id)initWithAmount:(NSNumber *)amount currencyCode:(NSString *)currencyCode
      currencySymbol:(NSString *)currencySymbol formattedAmount:(NSString *)formattedAmount;

/**
 Returns an `LUMonetaryValue` instance for the given amount, in cents.

 @param amount An amount of money, in cents.
 */
+ (LUMonetaryValue *)monetaryValueWithUSCents:(NSNumber *)amount;

/**
 Returns an `LUMonetaryValue` instance for the given amount, in dollars.

 @param amount An amount of money, in dollars.
 */
+ (LUMonetaryValue *)monetaryValueWithUSD:(NSNumber *)amount;

/**
 Returns the the formatted amount preprended with the currency symbol. For example, "$1.23".
 */
- (NSString *)formattedAmountWithSymbol;

/**
 Same as `formattedAmountWithSymbol`, with the exception that if the amount has only dollars and no cents, the cents
 are dropped. For example, "$1" or "$1.23".
 */
- (NSString *)shortFormatWithSymbol;

@end
