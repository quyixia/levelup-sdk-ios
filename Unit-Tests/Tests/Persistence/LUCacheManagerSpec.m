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

#import "LUCacheManager.h"

SPEC_BEGIN(LUCacheManagerSpec)

describe(@"LUCacheManager", ^{
  __block LUKeychainAccess *keychainAccess;

  beforeAll(^{
    keychainAccess = [LUKeychainAccess nullMock];
    [LUKeychainAccess stub:@selector(standardKeychainAccess) andReturn:keychainAccess];
  });

  describe(@"caching loyalty", ^{
    LULoyalty *loyalty = [LULoyalty fixture];

    context(@"when loyalty gets cached", ^{
      it(@"saves the loyalty into the keychain", ^{
        [[[keychainAccess should] receive] setObject:loyalty forKey:LUCachedLoyaltyKey];

        [LUCacheManager cacheLoyalty:loyalty];
      });

      it(@"saves the loyalty in memory", ^{
        [LUCacheManager cacheLoyalty:loyalty];

        [[[keychainAccess shouldNot] receive] objectForKey:LUCachedLoyaltyKey];

        [[[LUCacheManager cachedLoyalty] should] equal:loyalty];
      });
    });

    context(@"when loyalty is cached in the keychain but not in memory", ^{
      beforeEach(^{
        [LUCacheManager cacheLoyalty:nil];
        [keychainAccess stub:@selector(objectForKey:) andReturn:loyalty withArguments:LUCachedLoyaltyKey, nil];
      });

      it(@"returns the cached loyalty", ^{
        [[[LUCacheManager cachedLoyalty] should] equal:loyalty];
      });

      it(@"retrieves the loyalty from the keychain once, then stores it in memory", ^{
        [[[keychainAccess should] receiveWithCount:1] objectForKey:LUCachedLoyaltyKey];

        [[[LUCacheManager cachedLoyalty] should] equal:loyalty];
        [[[LUCacheManager cachedLoyalty] should] equal:loyalty];
      });
    });
  });

  describe(@"caching a user", ^{
    LUUser *user = [LUUser fixture];

    context(@"when a user gets cached", ^{
      it(@"saves the user into the keychain", ^{
        [[[keychainAccess should] receive] setObject:user forKey:LUCachedUserKey];

        [LUCacheManager cacheUser:user];
      });

      it(@"saves the user in memory", ^{
        [LUCacheManager cacheUser:user];

        [[[keychainAccess shouldNot] receive] objectForKey:LUCachedUserKey];

        [[[LUCacheManager cachedUser] should] equal:user];
      });
    });

    context(@"when a user is cached in the keychain but not in memory", ^{
      beforeEach(^{
        [LUCacheManager cacheUser:nil];
        [keychainAccess stub:@selector(objectForKey:) andReturn:user withArguments:LUCachedUserKey, nil];
      });

      it(@"returns the cached user", ^{
        [[[LUCacheManager cachedUser] should] equal:user];
      });

      it(@"retrieves the user from the keychain once, then stores it in memory", ^{
        [[[keychainAccess should] receiveWithCount:1] objectForKey:LUCachedUserKey];

        [LUCacheManager cachedUser];
        [LUCacheManager cachedUser];
      });
    });
  });

  describe(@"error handling", ^{
    it(@"accepts an error handler for LUKeychainAccess", ^{
      id<LUKeychainErrorHandler> errorHandler = [KWMock mockForProtocol:@protocol(LUKeychainErrorHandler)];

      [[[keychainAccess should] receive] setErrorHandler:errorHandler];

      [LUCacheManager setKeychainErrorHandler:errorHandler];
    });
  });
});

SPEC_END
