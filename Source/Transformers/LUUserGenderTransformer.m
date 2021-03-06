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

#import "LUUser.h"
#import "LUUserGenderTransformer.h"

NSString * const LUUserGenderTransformerName = @"LUUserGenderTransformerName";

@implementation LUUserGenderTransformer

#pragma mark - Object Creation

- (id)init {
  return [super initWithMapping:@{
    @(LUGenderFemale): @"female",
    @(LUGenderMale): @"male"
  }];
}

#pragma mark - NSValueTransformer Methods

- (id)transformedValue:(id)value {
  return [[super transformedValue:value] capitalizedString];
}

- (id)reverseTransformedValue:(id)value {
  return [super reverseTransformedValue:[value lowercaseString]];
}

@end
