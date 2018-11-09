// Copyright 2018-present 650 Industries. All rights reserved.

#import "EXPendingNotificationParams.h"

@implementation EXPendingNotificationParams

- (instancetype)initWithExperienceId:(NSString *)experienceId
                    notificationBody:(NSDictionary *)body
                            isRemote:(BOOL)isRemote
                    isFromBackground:(BOOL)isFromBackground
                            actionId:(NSString *)actionId
                            userText:(NSString *)userText {
  if (self = [super init]) {
    _isRemote = isRemote;
    _isFromBackground = isFromBackground;
    _experienceId = experienceId;
    _body = body;
    _actionId = actionId;
    _userText = userText;
  }
  return self;
}

@end
