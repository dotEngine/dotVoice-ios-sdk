//
//  dotVoice.h
//  dotVoice
//
//  Created by xiang on 26/03/2017.
//  Copyright © 2017 dotEngine. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AVFoundation;


typedef NS_ENUM(NSInteger, DotVoiceErrorCode) {
    DotVoice_Error_NoError = 0,
    DotVoice_Error_Failed = 1,
    DotVoice_Error_TokenError = 2,
    
    // todo
};



@interface DotBitrateStat : NSObject

@property(nonatomic,assign) int  audioBitrateSend;
@property(nonatomic,assign) int  audioBitrateReceive;

@end



typedef NS_ENUM(NSInteger, DotVoiceStatus) {
    DotVoiceStatusReady,
    DotVoiceStatusConnected,
    DotVoiceStatusDisConnected,
    DotVoiceStatusError,
};



typedef NS_ENUM(NSInteger, DotVoiceQuality) {
    DotVoiceQualityLow,
    DotVoiceQualityMiddle,
    DotVoiceQualityHigh,
    DotVoiceQualityVeryHigh
};


@protocol DotVoiceDelegate;


@interface DotVoice : NSObject

@property (nonatomic, weak) id<DotVoiceDelegate> delegate;
@property (nonatomic, readonly) DotVoiceStatus  status;
@property (nonatomic, strong, readonly) NSString* localUser;


+(instancetype _Nonnull)sharedInstanceWithDelegate:(id<DotVoiceDelegate> _Nonnull)delegate;




-(void)joinRoom:(NSString* _Nonnull)token;

-(void)leaveRoom;

-(void)enableAudio:(BOOL)enable;

-(void)muteLocalAudio:(BOOL)muted;

-(void)muteRemoteAudio:(BOOL)muted;

-(void)enableTalkingIndicate:(BOOL)enable;

-(void)enableBitrateIndicate:(BOOL)enable;


-(void)enableSpeakerphone:(BOOL)enable;


-(void)generateTestTokenWithAppKey:( NSString* _Nonnull )appkey
                         appsecret:(NSString* _Nonnull )appsecret
                              room:(NSString* _Nonnull )room
                            userId:(NSString* _Nonnull )userid
                         withBlock:(void (^_Nonnull)(NSString* _Nullable token,NSError* _Nullable error))tokenBlock;

@end






@protocol DotVoiceDelegate <NSObject>

-(void)dotVoice:(DotVoice* _Nonnull) engine didJoined:(NSString* _Nonnull)userId withUsers:(NSArray<NSString*>* _Nonnull)users;

-(void)dotVoice:(DotVoice* _Nonnull) engine didLeave:(NSString* _Nonnull)userId;

-(void)dotVoice:(DotVoice* _Nonnull) engine didOccurError:(DotVoiceErrorCode)errorCode;


-(void)dotVoice:(DotVoice* _Nonnull) engine talking:(NSString* _Nonnull)userId;

-(void)dotVoice:(DotVoice* _Nonnull) engine didGotBitrateStat:(DotBitrateStat* _Nonnull)stat;

@end
