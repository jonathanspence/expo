//  Copyright © 2018-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>

@interface EXPendingNotificationParams : NSObject

@property (nonatomic, strong) NSString *experienceId;
@property (nonatomic, strong) NSDictionary *body;
@property (nonatomic, assign) BOOL isRemote;
@property (nonatomic, assign) BOOL isFromBackground;
@property (nonatomic, strong) NSString *actionId;
@property (nonatomic, strong) NSString *userText;

- (instancetype)initWithExperienceId:(NSString *)experienceId
                    notificationBody:(NSDictionary *)body
                            isRemote:(BOOL)isRemote
                    isFromBackground:(BOOL)isFromBackground
                            actionId:(NSString *)actionId
                            userText:(NSString *)userText;

@end
