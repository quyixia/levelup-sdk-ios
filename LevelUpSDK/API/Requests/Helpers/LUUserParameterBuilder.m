#import "LUDeviceIdentifier.h"
#import "LUUser.h"
#import "LUUserAddress.h"
#import "LUUserParameterBuilder.h"

@implementation LUUserParameterBuilder

#pragma mark - Public Methods

+ (NSDictionary *)parametersForUser:(LUUser *)user {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];

  [self addKey:@"born_at" toDictionary:params ifValuePresent:[user valueForKey:@"bornAt"]];
  [self addKey:@"custom_attributes" toDictionary:params ifValuePresent:user.customAttributes];
  [self addKey:@"device_identifier" toDictionary:params ifValuePresent:[LUDeviceIdentifier deviceIdentifier]];
  [self addKey:@"email" toDictionary:params ifValuePresent:user.email];
  [self addKey:@"employer" toDictionary:params ifValuePresent:user.employer];
  [self addKey:@"first_name" toDictionary:params ifValuePresent:user.firstName];
  [self addKey:@"gender" toDictionary:params ifValuePresent:[user valueForKey:@"gender"]];
  [self addKey:@"last_name" toDictionary:params ifValuePresent:user.lastName];
  [self addKey:@"lat" toDictionary:params ifValuePresent:user.lat];
  [self addKey:@"lng" toDictionary:params ifValuePresent:user.lng];
  [self addKey:@"new_password" toDictionary:params ifValuePresent:user.newPassword];
  [self addKey:@"new_password_confirmation" toDictionary:params ifValuePresent:user.newPasswordConfirmation];
  [self addKey:@"percent_donation" toDictionary:params ifValuePresent:user.percentDonation];
  [self addKey:@"promotion_code" toDictionary:params ifValuePresent:user.promotionCode];
  [self addKey:@"subscribed" toDictionary:params ifValuePresent:@(user.subscribed)];
  [self addKey:@"terms_accepted_at" toDictionary:params ifValuePresent:[user valueForKey:@"termsAcceptedAt"]];

  if (user.userAddresses) {
    [user.userAddresses enumerateObjectsUsingBlock:^(LUUserAddress *address, NSUInteger idx, BOOL *stop) {
      NSMutableDictionary *addressParams = [NSMutableDictionary dictionary];

      [self addKey:@"address_type" toDictionary:addressParams ifValuePresent:address.addressType];
      [self addKey:@"extended_address" toDictionary:addressParams ifValuePresent:address.extendedAddress];
      [self addKey:@"id" toDictionary:addressParams ifValuePresent:address.modelId];
      [self addKey:@"locality" toDictionary:addressParams ifValuePresent:address.locality];
      [self addKey:@"postal_code" toDictionary:addressParams ifValuePresent:address.postalCode];
      [self addKey:@"region" toDictionary:addressParams ifValuePresent:address.region];
      [self addKey:@"street_address" toDictionary:addressParams ifValuePresent:address.streetAddress];

      params[[NSString stringWithFormat:@"user_addresses_attributes[%d]", idx]] = addressParams;
    }];
  }

  return params;
}

#pragma mark - Private Methods

+ (void)addKey:(NSString *)key toDictionary:(NSMutableDictionary *)dictionary ifValuePresent:(id)value {
  if (value && (![value respondsToSelector:@selector(length)] || [value length] > 0)) {
    dictionary[key] = value;
  }
}

+ (void)removeBlankValues:(NSMutableDictionary *)dictionary {
  for (NSString *key in [dictionary allKeys]) {
    if ([dictionary[key] isKindOfClass:[NSString class]] && [dictionary[key] length] == 0) {
      [dictionary removeObjectForKey:key];
    }
  }
}

@end