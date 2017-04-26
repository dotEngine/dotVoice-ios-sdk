//
//  ViewController.m
//  dotVoiceExample
//
//  Created by xiang on 26/04/2017.
//  Copyright © 2017 dotEngine. All rights reserved.
//

#import "ViewController.h"

#import "DotVoice.h"

#import <Toast/UIView+Toast.h>


static NSString*  DOTVOICE_APP_KEY = @"45";

static NSString*  DOTVOICE_APP_SECRET = @"dc5cabddba054ffe894ba79c2910866c";

static NSString*  DOTVOICE_ROOM = @"dotvoice";




@interface ViewController ()<DotVoiceDelegate>

{
    
    NSString* localUser;
}

@property(strong) DotVoice*  dotVoice;
@property(strong) UILabel*  userIdLabel;

@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    _dotVoice = [DotVoice sharedInstanceWithDelegate:self];
    
    [_joinButton addTarget:self action:@selector(join:) forControlEvents:UIControlEventTouchUpInside];
    
    _joinButton.tag = 0;
    
    
    [_speakerButton addTarget:self action:@selector(speakerToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    _speakerButton.tag = 0;
    
    
    uint32_t randomNum = arc4random_uniform(10000);
    localUser = [NSString stringWithFormat:@"%d",randomNum];
    
    _userIdLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 148,44)];
    _userIdLabel.textAlignment = NSTextAlignmentCenter;
    _userIdLabel.text = localUser;
    _userIdLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 100);
    
    
    [self.view addSubview:_userIdLabel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)speakerToggle:(UIButton*)sender
{
    
    if (sender.tag == 0) {
        [_dotVoice enableSpeakerphone:true];
        sender.tag = 1;
    } else {
        [_dotVoice enableSpeakerphone:false];
        sender.tag = 0;
    }
}


-(void)audioEnableToggle:(UIButton*)sender
{
    
    if (sender.tag == 0) {
        [_dotVoice enableAudio:false];
        sender.tag = 1;
    } else {
        [_dotVoice enableAudio:true];
        sender.tag = 0;
    }
    
}


-(void)join:(UIButton *)sender
{
    // tag 0  join   tag  1  leave
    
    if (sender.tag == 0) {// join
        
        [_dotVoice generateTestTokenWithAppKey:DOTVOICE_APP_KEY
                                     appsecret:DOTVOICE_APP_SECRET
                                          room:DOTVOICE_ROOM
                                        userId:localUser
                                     withBlock:^(NSString *token, NSError *error) {
                                         
                                         if (error != nil) {
                                             
                                             [self.view makeToast:@"can not got token"
                                                         duration:3.0
                                                         position:CSToastPositionTop];
                                             
                                             return;
                                         }
                                         
                                         [_dotVoice enableAudio:YES];
                                         [_dotVoice joinRoom:token];
                                         
                                         
                                         
                                     }];
        
        
    } else {
        
        [_dotVoice leaveRoom];
        [_dotVoice enableAudio:false];
        
    }
    
}


#pragma delegate



-(void)dotVoice:(DotVoice*) engine didJoined:(NSString*)userId withUsers:(NSArray<NSString*>*)users
{
    
    if ([userId isEqualToString:localUser]) {
        // self
        _joinButton.tag = 1;
        [_joinButton setTitle:@"Leave" forState:UIControlStateNormal];
    } else {
        // remote user
        
        [self.view makeToast:[NSString stringWithFormat:@"remote user:%@ coming", userId]
                    duration:3.0
                    position:CSToastPositionTop];
    }
}

-(void)dotVoice:(DotVoice*) engine didLeave:(NSString*)userId
{
    
    
    if ([userId isEqualToString:localUser]) {
        
        _joinButton.tag = 0;
        [_joinButton setTitle:@"Join" forState:UIControlStateNormal];
    } else {
        
        [self.view makeToast:[NSString stringWithFormat:@"remote user:%@ coming", userId] duration:3.0 position:CSToastPositionTop];
    }
    
    
    
}

-(void)dotVoice:(DotVoice*) engine didOccurError:(DotVoiceErrorCode)errorCode
{
    
    NSLog(@"didOccurError ");
}

-(void)dotVoice:(DotVoice*) engine didMuted:(BOOL)muted  userId:(NSString*)userId
{
    
    NSLog(@"didMuted %@ ", userId);
}


-(void)dotVoice:(DotVoice*) engine audioVolume:(int)volume  userId:(NSString*)userId
{
    
    NSLog(@"audioVolume %@", userId);
}


@end
