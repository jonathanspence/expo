// Copyright 2015-present 650 Industries. All rights reserved.

#import "EXUserNotificationManager.h"
#import "EXKernel.h"
#import "EXRemoteNotificationManager.h"
#import "EXEnvironment.h"

static NSString * const kEXSelectedActionIdentifier = @"Expo.notificationSelected";

@implementation EXUserNotificationManager

+ (instancetype)sharedInstance
{
  static EXUserNotificationManager *theManager;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    if (!theManager) {
      theManager = [EXUserNotificationManager new];
    }
  });
  return theManager;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
  BOOL isFromBackground = [UIApplication sharedApplication].applicationState != UIApplicationStateActive;
  NSDictionary *payload = response.notification.request.content.userInfo;
  if (payload) {
    NSDictionary *body = payload[@"body"];
    NSString *experienceId = payload[@"experienceId"];
    NSString *userText = nil;
    NSString *actionId = nil;

    if (![response.actionIdentifier isEqualToString:UNNotificationDefaultActionIdentifier]) {
      actionId = response.actionIdentifier;
    }

    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
      userText = ((UNTextInputNotificationResponse *) response).userText;
    }

    BOOL isRemote = [response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]];
    if (experienceId) {
      [[EXKernel sharedInstance] sendNotification:body
                               toExperienceWithId:experienceId
                                   fromBackground:isFromBackground
                                         isRemote:isRemote
                                         actionId:actionId
                                         userText:userText];
    }
  }
  completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
  // With UIUserNotifications framework, notifications were only shown while the app wasn't active.
  // Let's stick to this behavior.
  if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
    completionHandler(UNNotificationPresentationOptionAlert + UNNotificationPresentationOptionSound);
    return;
  }

  // If the app is active we do not show the alert, but we deliver the notification to the experience.
  NSDictionary *payload = notification.request.content.userInfo;
  if (payload) {
    NSDictionary *body = payload[@"body"];
    NSString *experienceId = payload[@"experienceId"];
    NSString *userText = nil;

    BOOL isRemote = [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]];
    if (experienceId) {
      [[EXKernel sharedInstance] sendNotification:body
                               toExperienceWithId:experienceId
                                   fromBackground:NO
                                         isRemote:isRemote
                                         actionId:nil
                                         userText:userText];
    }
  }

  completionHandler(UNNotificationPresentationOptionNone);
}

@end
