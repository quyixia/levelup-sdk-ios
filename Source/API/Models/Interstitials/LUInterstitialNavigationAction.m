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

#import "LUInterstitialNavigationAction.h"

@implementation LUInterstitialNavigationAction

#pragma mark - Creation

- (id)initWithButtonText:(NSString *)buttonText URL:(NSURL *)URL {
  self = [super init];
  if (!self) return nil;

  _buttonText = buttonText;
  _URL = URL;

  return self;
}

#pragma mark - NSObject Methods

- (NSString *)description {
  return [NSString stringWithFormat:@"LUInterstitialNavigationAction [address=%p, buttonText=%@, URL=%@]",
          self, self.buttonText, self.URL];
}

@end
