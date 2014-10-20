//
//  ReserveController.m
//  iReserve
//
//  Created by apple on 14-9-23.
//  Copyright (c) 2014年 MichaelDu. All rights reserved.
//

#import "ReserveController.h"
#import "UIViewController+XHLoadingNavigationItemTitle.h"
#import "NALLabelsMatrix.h"
#import <AudioToolbox/AudioToolbox.h>  
#import "AppDelegate.h"

#define R409 @"Causeway\nBay"
#define R428 @"ifc\nmall"
#define R485 @"Festival\nWalk"

#define kDEFAULT_BACKGROUND_HAVE        @"gradient4"
#define kDEFAULT_BACKGROUND_NOT_HAVE    @"gradient8"

#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IOS_7 (IOS_VERSION >= 7 ? YES : NO)

@interface ReserveController ()<UIAlertViewDelegate>
{
    NSTimer *timer;
    NSInteger timeSec;
    NSTimer *timer_title;
    BOOL isUpdateBackgroud;
    NSInteger timeSettingSec;
}
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
- (void)infoButtonAction:(id)sender;
@end

@implementation ReserveController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"iReserve";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [btn  addTarget:self action:@selector(infoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kDEFAULT_BACKGROUND_NOT_HAVE]];
    timeSettingSec = 5;
    [self notification];
    [self loadReserveData];
    timer_title = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTitle) userInfo:nil repeats:YES];
}

- (void)timeTitle
{
    if (timeSec == 0)
    {
        self.title = @"iReserve";
    }
    else
    {
        timeSec--;
        self.title = [NSString stringWithFormat:@"iReserve(%i)",timeSec];
    }
}

- (void)loadReserveData
{
    NSLog(@"loadReserveData start");
    [self startAnimationTitle];
    [RequestUtil reserveSuccess:^(NSDictionary *dic) {
        NSLog(@"loadReserveData succceed");
//        NSLog(@"dic :%@",dic);
        [self stopAnimationTitle];
        isUpdateBackgroud = NO;
        timer = nil;
        timeSec = timeSettingSec;
        timer = [NSTimer scheduledTimerWithTimeInterval:timeSec target:self selector:@selector(loadReserveData) userInfo:nil repeats:NO];
        self.title = @"iReserve 😄";

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm aa"];
        long long t = [[dic objectForKey:@"updated"] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:t*0.001];
        if ([dic count] == 0)
        {
            self.timeLable.text = [NSString stringWithFormat:@"於 %@ 可供預訂。",[dateFormatter stringFromDate:[NSDate date]]];
        }
        else
        {
            self.timeLable.text = [NSString stringWithFormat:@"於 %@ 可供預訂。",[dateFormatter stringFromDate:date]];
        }

        for (UIView *view in self.view.subviews)
        {
            if (view.tag == 1000)
            {
                [UIView animateWithDuration:.3 animations:^{
                    [view removeFromSuperview];
                } completion:^(BOOL finished) {
                }];
            }
        }
        NSArray *mallKeys = @[@"R409",@"R428",@"R485"];
        NSInteger y = 0;
        BOOL iPhone5later = (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES);
        CGRect f = self.timeLable.frame;
        if (iPhone5later)
        {
            if (IOS_7)
            {
                y = 105;
            }
            else
            {
                y = 105 -64;
                f.origin.y = 10;
            }
            [self.timeLable setFrame:f];
        }
        else
        {
            if (IOS_7)
            {
                y = 80;
                f.origin.y = 61;
            }
            else
            {
                y = 12;
                f.origin.y = -3;
            }
            [self.timeLable setFrame:f];

        }
        for (int i = 0 ; i < [mallKeys count] ; i ++)
        {
            NSString *mallKey = [mallKeys objectAtIndex:i];
            NSDictionary *models = [dic objectForKey:mallKey];
            NALLabelsMatrix *matrix = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake(2, y, 320, 100) andColumnsWidths:[[NSArray alloc] initWithObjects:@50,@45,@45,@46,@45,@45,@46,nil]];
            matrix.tag = 1000;
            [matrix addRecord:[[NSArray alloc] initWithObjects:[self mall:mallKey], @"4.7\n16G", @"4.7\n64G", @"4.7\n128", @"5.5\n16G", @"5.5\n64G", @"5.5\n128", nil]];
            [matrix addRecord:[[NSArray alloc] initWithObjects:@"  银",[self text:models :@"MG482ZP/A"],[self text:models :@"MG4H2ZP/A"],[self text:models :@"MG4C2ZP/A"],
                                                                      [self text:models :@"MGA92ZP/A"],[self text:models :@"MGAJ2ZP/A"],[self text:models :@"MGAE2ZP/A"], nil]];
            
            [matrix addRecord:[[NSArray alloc] initWithObjects:@"  金",[self text:models :@"MG492ZP/A"],[self text:models :@"MG4J2ZP/A"],[self text:models :@"MG4E2ZP/A"],
                                                                      [self text:models :@"MGAA2ZP/A"],[self text:models :@"MGAK2ZP/A"],[self text:models :@"MGAF2ZP/A"], nil]];
            
            [matrix addRecord:[[NSArray alloc] initWithObjects:@"  灰",[self text:models :@"MG472ZP/A"],[self text:models :@"MG4F2ZP/A"],[self text:models :@"MG4A2ZP/A"],
                                                                      [self text:models :@"MGA82ZP/A"],[self text:models :@"MGAH2ZP/A"],[self text:models :@"MGAC2ZP/A"], nil]];
            y = y + (matrix.frame.size.height + (iPhone5later ? 15 : 2));
            [UIView animateWithDuration:.3 animations:^{
                matrix.alpha = .5;
                [self.view addSubview:matrix];
            } completion:^(BOOL finished) {
                matrix.alpha = 1;
            }];
            
            
            //iPhone 6 16GB 銀色        MG482ZP/A
            //iPhone 6 16GB 金色        MG492ZP/A
            //iPhone 6 16GB 太空灰        MG472ZP/A
            //iPhone 6 64GB 銀色        MG4H2ZP/A
            //iPhone 6 64GB 金色        MG4J2ZP/A
            //iPhone 6 64GB 太空灰        MG4F2ZP/A
            //iPhone 6 128GB 銀色        MG4C2ZP/A
            //iPhone 6 128GB 金色         MG4E2ZP/A
            //iPhone 6 128GB 太空灰        MG4A2ZP/A
            //
            //iPhone 6 Plus  16GB 銀色        MGA92ZP/A
            //iPhone 6 Plus  16GB 金色        MGAA2ZP/A
            //iPhone 6 Plus  16GB 太空灰        MGA82ZP/A
            //iPhone 6 Plus  64GB 銀色        MGAJ2ZP/A
            //iPhone 6 Plus  64GB 金色        MGAK2ZP/A
            //iPhone 6 Plus  64GB 太空灰        MGAH2ZP/A
            //iPhone 6 Plus  128GB 銀色        MGAE2ZP/A
            //iPhone 6 Plus  128GB 金色         MGAF2ZP/A
            //iPhone 6 Plus  128GB 太空灰        MGAC2ZP/A
        }
        if (!isUpdateBackgroud)
        {
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kDEFAULT_BACKGROUND_NOT_HAVE]];
        }
    } failure:^(id errorInfo) {
        self.title = @"iReserve 😨";
        NSLog(@"loadReserveData faid");
        self.timeLable.text = @"网络错误或苹果获取接口关闭。";

        [self stopAnimationTitle];
        [self loadReserveData];
        [self performSelector:@selector(loadReserveData) withObject:nil afterDelay:1.0];
    }];
}

- (NSString *)text:(NSDictionary *)dic :(NSString*)modle
{
    if ([[dic objectForKey:modle] boolValue])
    {
        if (!isUpdateBackgroud)
        {
            [self playSound];
            isUpdateBackgroud = YES;
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kDEFAULT_BACKGROUND_HAVE]];
            if (((AppDelegate *)[[UIApplication sharedApplication] delegate]).isBackgroud)
            {
                [self notification];
            }
        }
        return TextHave;
    }
    else
    {
        return TextNotHave;
    }
}

- (NSString *)mall:(NSString *)key
{
    if ([key isEqualToString:@"R409"])
    {
        return R409;
    }
    else if ([key isEqualToString:@"R428"])
    {
        return R428;
    }
    else
    {
        return R485;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)infoButtonAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"关于"
                                                    message:@"数据来自苹果官方接口\n默认5秒更新一次数据，有货将震动声音提示\nAPP仅供好友与坛友学习交流使用\n如有问题请微博联系:iMichaelDu"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"测试提醒",@"APP更新",@"访问作者微博",@"自定义更新时间",nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%i",buttonIndex);
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
        {
            [self playSound];
        }
        else if (buttonIndex == 2)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pgyer.com/iReserve"]];
        }
        else if (buttonIndex == 3)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/1967066991"]];
        }
        else if (buttonIndex == 4)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设定刷新时间间隔"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            alert.tag = 2;
            alert.delegate = self;
            [alert show];
        }
    }
    else if (alertView.tag == 2)
    {
        NSString *n = [[alertView textFieldAtIndex:0]text];
        NSLog(@"%@",n);
        if ([self isPureInt:n])
        {
            timeSettingSec = [n integerValue];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入数字"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定",nil];
            alert.tag = 3;
            [alert show];
        }
    }
}


- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

-(void)playSound
{
    static SystemSoundID shake_sound_male_id = 0;
    
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@",@"alarm.caf"];
    if (path)
    {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
        //        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

- (void)notification
{
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    if (noti)
    {
       // /System/Library/Audio/UISounds/alarm.caf
        //推送声音
        noti.soundName = @"alarm.caf";
        noti.alertBody = @"iPhone6预定放货,请抓紧时间预定";
        //显示在icon上的红色圈中的数子
        //            noti.applicationIconBadgeNu'mber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        //添加推送到uiapplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:noti];
    }
}

@end
