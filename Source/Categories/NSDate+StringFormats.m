// Copyright 2013 SCVNGR, Inc., D.B.A. LevelUp. All rights reserved.

#import "NSDate+StringFormats.h"

@implementation NSDate (StringFormats)

#pragma mark - Public Methods

+ (NSDate *)lu_dateFromIso8601DateTimeString:(NSString *)dateString {
  // This tweaking is required because NSDateFormatter doesn't fully support
  // ISO 8601. Specifically, it doesn't want time zones with colons, so we strip
  // out the third-to-last character (the colon).
  NSUInteger colonIndex = [dateString length] - 3;
  NSString *finalDateString = dateString;

  if (':' == [finalDateString characterAtIndex:colonIndex]) {
    finalDateString = [finalDateString stringByReplacingCharactersInRange:NSMakeRange(colonIndex, 1) withString:@""];
  }

  return [[NSDate lu_iso8601DateTimeFormatter] dateFromString:finalDateString];
}

- (NSString *)lu_iso8601DateTimeString {
  return [[NSDate lu_iso8601DateTimeFormatter] stringFromDate:self];
}

#pragma mark - Private Methods

+ (NSDateFormatter *)lu_iso8601DateTimeFormatter {
  NSDateFormatter *iso8601DateTimeFormatter = [[NSDateFormatter alloc] init];
  [iso8601DateTimeFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
  [iso8601DateTimeFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

  return iso8601DateTimeFormatter;
}

@end
