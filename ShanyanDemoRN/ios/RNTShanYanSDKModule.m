//
//  RNTShanYanSDKModule.m
//  ShanyanDemoRN
//
//  Created by KevinChien on 2020/3/26.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "RNTShanYanSDKModule.h"
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>
#import <React/RCTUtils.h>

#import "Masonry.h"


@interface RNTShanYanSDKModule ()

@end

@implementation RNTShanYanSDKModule




RCT_EXPORT_MODULE();


RCT_EXPORT_METHOD(init:(NSString *)appId complete:(RCTResponseSenderBlock)complete)
{

  [CLShanYanSDKManager initWithAppId:appId complete:^(CLCompleteResult * _Nonnull completeResult) {

        if (complete) {

          NSMutableDictionary * result = [NSMutableDictionary new];

          result[@"code"] = @(completeResult.code);
          result[@"message"] = completeResult.message;
          result[@"data"] = completeResult.data;
          if (completeResult.error) {
            result[@"errorCode"] = @(completeResult.error.code);
            result[@"errorDomain"] = completeResult.error.domain;
            result[@"errorUserInfo"] = completeResult.error.userInfo;
          }

          if (completeResult.error){
              complete(@[completeResult.error,result]);
          } else {
            complete(@[[NSNull null],result]);
          }
        }
   }];
}


RCT_EXPORT_METHOD(preGetPhonenumber:(RCTResponseSenderBlock)complete){
  [CLShanYanSDKManager preGetPhonenumber:^(CLCompleteResult * _Nonnull completeResult) {

    NSLog(@"%@",completeResult.message);

    if (complete) {

      NSMutableDictionary * result = [NSMutableDictionary new];

      result[@"code"] = @(completeResult.code);
      result[@"message"] = completeResult.message;
      result[@"data"] = completeResult.data;
      if (completeResult.error) {
        result[@"errorCode"] = @(completeResult.error.code);
        result[@"errorDomain"] = completeResult.error.domain;
        result[@"errorUserInfo"] = completeResult.error.userInfo;
      }
      if (completeResult.error){
          complete(@[completeResult.error,result]);
      } else {
        complete(@[[NSNull null],result]);
      }
    }
  }];
}

- (NSArray<NSString *> *)supportedEvents{
  return @[@"onReceiveAuthPageEvent"];
}

RCT_EXPORT_METHOD(quickAuthLoginOpenLoginAuthListener:(RCTResponseSenderBlock)oneKeyLoginListener){
  dispatch_async(dispatch_get_main_queue(), ^{
     UIViewController * currentVC = RCTPresentedViewController();

     CLUIConfigure * baseUIConfigure;
     baseUIConfigure = [self configureStyle4:[CLUIConfigure new]];

     baseUIConfigure.viewController = currentVC;
     baseUIConfigure.manualDismiss = @(YES);

     [CLShanYanSDKManager quickAuthLoginWithConfigure:baseUIConfigure openLoginAuthListener:^(CLCompleteResult * _Nonnull completeResult) {

       NSLog(@"%@",completeResult.message);

      NSMutableDictionary * result = [NSMutableDictionary new];
        result[@"code"] = @(completeResult.code);
        result[@"message"] = completeResult.message;
        result[@"data"] = completeResult.data;
        if (completeResult.error) {
        result[@"errorCode"] = @(completeResult.error.code);
        result[@"errorDomain"] = completeResult.error.domain;
        result[@"errorUserInfo"] = completeResult.error.userInfo;
        }

        if (completeResult.error){
            [self sendEventWithName:@"onReceiveAuthPageEvent" body:@[completeResult.error,result]];
        } else {
            [self sendEventWithName:@"onReceiveAuthPageEvent" body:@[[NSNull null],result]];
        }
     } oneKeyLoginListener:^(CLCompleteResult * _Nonnull completeResult) {

       NSMutableDictionary * result = [NSMutableDictionary new];
       result[@"code"] = @(completeResult.code);
       result[@"message"] = completeResult.message;
       result[@"data"] = completeResult.data;
       if (completeResult.error) {
         result[@"errorCode"] = @(completeResult.error.code);
         result[@"errorDomain"] = completeResult.error.domain;
         result[@"errorUserInfo"] = completeResult.error.userInfo;

         if (completeResult.code == 1011) {
           //点自带返回
           NSLog(@"点击了取消免密登录");
           [self sendEventWithName:@"onReceiveAuthPageEvent" body:@[completeResult.error,result]];
           return ;
         }

         if (oneKeyLoginListener) {
           oneKeyLoginListener(@[completeResult.error,result]);
         }
       } else {
         if (oneKeyLoginListener) {
          oneKeyLoginListener(@[[NSNull null],result]);
         }
       }
     }];
   });
}

RCT_EXPORT_METHOD(
startAuthentication:(RCTResponseSenderBlock)authenticationListener){
  [CLShanYanSDKManager mobileCheckWithLocalPhoneNumberComplete:^(CLCompleteResult * _Nonnull completeResult) {
    if (authenticationListener) {
      NSMutableDictionary * result = [NSMutableDictionary new];
      result[@"code"] = @(completeResult.code);
      result[@"message"] = completeResult.message;
      result[@"data"] = completeResult.data;
      if (completeResult.error) {
        result[@"errorCode"] = @(completeResult.error.code);
        result[@"errorDomain"] = completeResult.error.domain;
        result[@"errorUserInfo"] = completeResult.error.userInfo;
      }
        if (completeResult.error){
            authenticationListener(@[completeResult.error,result]);
        } else {
            authenticationListener(@[[NSNull null],result]);
        }
    }
  }];
}

RCT_EXPORT_METHOD(
closeAuthPage:(RCTResponseErrorBlock)authPageClosedBlock){
  dispatch_async(dispatch_get_main_queue(), ^{
    [CLShanYanSDKManager finishAuthControllerAnimated:YES Completion:^{
      if (authPageClosedBlock) {
        authPageClosedBlock(nil);
      }
    }];
  });
}

#pragma mark - 样式4：横竖屏两套布局样式
- (CLUIConfigure *)configureStyle4:(CLUIConfigure *)inputConfigure{
    CGFloat screenWidth_Portrait;
    CGFloat screenHeight_Portrait;
    CGFloat screenWidth_Landscape;
    CGFloat screenHeight_Landscape;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        screenWidth_Portrait = UIScreen.mainScreen.bounds.size.width;
        screenHeight_Portrait = UIScreen.mainScreen.bounds.size.height;
        screenWidth_Landscape = UIScreen.mainScreen.bounds.size.height;
        screenHeight_Landscape = UIScreen.mainScreen.bounds.size.width;
    }else{
        screenWidth_Portrait = UIScreen.mainScreen.bounds.size.height;
        screenHeight_Portrait = UIScreen.mainScreen.bounds.size.width;
        screenWidth_Landscape = UIScreen.mainScreen.bounds.size.width;
        screenHeight_Landscape = UIScreen.mainScreen.bounds.size.height;
    }

    CGFloat screenScale = [UIScreen mainScreen].bounds.size.width/375.0;
    if (screenScale > 1) {
        screenScale = 1;
    }

    UIColor * style2Color = [UIColor colorWithRed:33/255.0 green:113/255.0 blue:242/255.0 alpha:1];;

    CLUIConfigure * baseUIConfigure = inputConfigure;

  //shanYanSloga
  baseUIConfigure.clShanYanSloganTextColor = UIColor.lightGrayColor;
  baseUIConfigure.clShanYanSloganTextFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:11.0*screenScale];
  baseUIConfigure.clShanYanSloganTextAlignment = @(NSTextAlignmentCenter);

    //横竖屏设置
    baseUIConfigure.shouldAutorotate = @(NO);
    baseUIConfigure.supportedInterfaceOrientations = @(UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskAll);
//    baseUIConfigure.supportedInterfaceOrientations = @(UIInterfaceOrientationMaskLandscapeLeft);
//    baseUIConfigure.preferredInterfaceOrientationForPresentation = @(UIInterfaceOrientationLandscapeLeft);

//    baseUIConfigure.clNavigationBackgroundClear = @(YES);
//    baseUIConfigure.clNavigationBottomLineHidden = @(YES);
//    baseUIConfigure.clNavigationBarHidden = @(YES);
    baseUIConfigure.clPreferredStatusBarStyle = @(UIStatusBarStyleLightContent);
    baseUIConfigure.clNavigationBarStyle = @(UIBarStyleBlack);
//    baseUIConfigure.clNavigationBarTintColor = UIColor.blueColor;
    //    baseUIConfigure.clNavigationBackBtnImage = [UIImage imageNamed:@"矩形 124 拷贝"];

    //LOGO
    baseUIConfigure.clLogoImage = [UIImage imageNamed:@"闪验logo2"];

    //PhoneNumber
    baseUIConfigure.clPhoneNumberColor = style2Color;
    baseUIConfigure.clPhoneNumberFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:18.0*screenScale];

    //LoginBtn
    baseUIConfigure.clLoginBtnText = @"一键登录";
    baseUIConfigure.clLoginBtnTextFont = [UIFont systemFontOfSize:15*screenScale];
    baseUIConfigure.clLoginBtnBgColor = UIColor.blueColor;
    baseUIConfigure.clLoginBtnCornerRadius = @(10*screenScale);
    baseUIConfigure.clLoginBtnTextColor = UIColor.cyanColor;

    //Privacy
    baseUIConfigure.clAppPrivacyFirst = @[@"测试连接A",@"https://www.baidu.com"];
    baseUIConfigure.clAppPrivacySecond = @[@"测试连接B",@"https://www.sina.com"];

    baseUIConfigure.clAppPrivacyColor = @[[UIColor lightGrayColor],style2Color];
    baseUIConfigure.clAppPrivacyTextAlignment = @(NSTextAlignmentCenter);
    baseUIConfigure.clAppPrivacyTextFont = [UIFont systemFontOfSize:11];
    //        baseUIConfigure.clAppPrivacyLineSpacing = @(2);
    //        baseUIConfigure.clAppPrivacyNeedSizeToFit = @(YES);

    //CheckBox
    baseUIConfigure.clCheckBoxHidden = @(YES);
    baseUIConfigure.clCheckBoxValue = @(YES);

    //Slogan
    baseUIConfigure.clSloganTextColor = UIColor.lightGrayColor;
    baseUIConfigure.clSloganTextFont = [UIFont systemFontOfSize:11.0];
    baseUIConfigure.clSlogaTextAlignment = @(NSTextAlignmentCenter);

    __weak typeof(self) weakSelf = self;



    baseUIConfigure.customAreaView = ^(UIView * _Nonnull customAreaView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        UIImageView * bg0 = [UIImageView new];
        [customAreaView addSubview:bg0];
        UIImageView * bg = [[UIImageView alloc]init];
        [customAreaView addSubview:bg];

        UIButton * weChat = [[UIButton alloc]init];
        [weChat setBackgroundImage:[UIImage imageNamed:@"微信"] forState:(UIControlStateNormal)];
        [customAreaView addSubview:weChat];

        [weChat addTarget:strongSelf action:@selector(showAlertSheetWindow) forControlEvents:(UIControlEventTouchUpInside)];

        UIButton * qq = [[UIButton alloc]init];
        [qq setBackgroundImage:[UIImage imageNamed:@"qq"] forState:(UIControlStateNormal)];
        [customAreaView addSubview:qq];

        UIButton * weibo = [[UIButton alloc]init];
        [weibo setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:(UIControlStateNormal)];
        [customAreaView addSubview:weibo];


      [bg0 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.insets(UIEdgeInsetsZero);
      }];
      //竖屏
      bg0.image = [UIImage imageNamed:@"720*1280竖屏背景"];
      bg.image = [UIImage imageNamed:@"竖屏上滑弹窗2"];

      [bg mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.left.top.right.mas_equalTo(0);
          make.bottom.mas_equalTo(-40);
      }];

      [qq mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.centerX.mas_equalTo(0);
          make.bottom.mas_equalTo(-160*screenScale - 45*screenScale - 15 - 30*screenScale);//
          make.width.height.mas_equalTo(35);
      }];
      [weChat mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.centerY.width.height.mas_equalTo(qq);
          make.right.mas_equalTo(qq.mas_left).mas_offset(-40);
      }];
      [weibo mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.centerY.width.height.mas_equalTo(qq);
          make.left.mas_equalTo(qq.mas_right).mas_offset(40);
      }];
    };

    //layout 布局
    //布局-竖屏
    CLOrientationLayOut * clOrientationLayOutPortrait = [CLOrientationLayOut new];

    clOrientationLayOutPortrait.clLayoutLogoWidth = @(108*screenScale);
    clOrientationLayOutPortrait.clLayoutLogoHeight = @(44*screenScale);
    clOrientationLayOutPortrait.clLayoutLogoCenterX = @(0);
    clOrientationLayOutPortrait.clLayoutLogoTop = @(screenHeight_Portrait*0.2);

    clOrientationLayOutPortrait.clLayoutPhoneTop = @(clOrientationLayOutPortrait.clLayoutLogoTop.floatValue + clOrientationLayOutPortrait.clLayoutLogoHeight.floatValue);
    clOrientationLayOutPortrait.clLayoutPhoneCenterX = @(0);
    clOrientationLayOutPortrait.clLayoutPhoneHeight = @(25*screenScale);
    clOrientationLayOutPortrait.clLayoutPhoneWidth = @(screenWidth_Landscape*0.5);

    clOrientationLayOutPortrait.clLayoutLoginBtnTop= @(screenHeight_Portrait*0.4 + 15*screenScale);
    clOrientationLayOutPortrait.clLayoutLoginBtnHeight = @(40*screenScale);
    clOrientationLayOutPortrait.clLayoutLoginBtnLeft = @(20*screenScale);
    clOrientationLayOutPortrait.clLayoutLoginBtnRight = @(-20*screenScale);

    clOrientationLayOutPortrait.clLayoutAppPrivacyLeft = @(40*screenScale);
    clOrientationLayOutPortrait.clLayoutAppPrivacyRight = @(-40*screenScale);
    clOrientationLayOutPortrait.clLayoutAppPrivacyBottom = @(-160*screenScale);
    clOrientationLayOutPortrait.clLayoutAppPrivacyHeight = @(45*screenScale);

    clOrientationLayOutPortrait.clLayoutSloganLeft = @(0);
    clOrientationLayOutPortrait.clLayoutSloganRight = @(0);
    clOrientationLayOutPortrait.clLayoutSloganHeight = @(15);
    clOrientationLayOutPortrait.clLayoutSloganBottom = @(clOrientationLayOutPortrait.clLayoutAppPrivacyBottom.floatValue - clOrientationLayOutPortrait.clLayoutAppPrivacyHeight.floatValue);


  // 闪验slogan
  clOrientationLayOutPortrait.clLayoutShanYanSloganLeft = @(0);
  clOrientationLayOutPortrait.clLayoutShanYanSloganRight = @(0);
  clOrientationLayOutPortrait.clLayoutShanYanSloganHeight = @(15*screenScale);
  clOrientationLayOutPortrait.clLayoutShanYanSloganBottom = @(clOrientationLayOutPortrait.clLayoutAppPrivacyBottom.floatValue - clOrientationLayOutPortrait.clLayoutAppPrivacyHeight.floatValue-20);

    baseUIConfigure.clOrientationLayOutPortrait = clOrientationLayOutPortrait;

    return baseUIConfigure;
}


#pragma mark - 样式5：窗口样式
- (CLUIConfigure *)configureStyle5:(CLUIConfigure *)inputConfigure{
  CGFloat screenWidth_Portrait;
  CGFloat screenHeight_Portrait;
  CGFloat screenWidth_Landscape;
  CGFloat screenHeight_Landscape;
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
    screenWidth_Portrait = UIScreen.mainScreen.bounds.size.width;
    screenHeight_Portrait = UIScreen.mainScreen.bounds.size.height;
    screenWidth_Landscape = UIScreen.mainScreen.bounds.size.height;
    screenHeight_Landscape = UIScreen.mainScreen.bounds.size.width;
  }else{
    screenWidth_Portrait = UIScreen.mainScreen.bounds.size.height;
    screenHeight_Portrait = UIScreen.mainScreen.bounds.size.width;
    screenWidth_Landscape = UIScreen.mainScreen.bounds.size.width;
    screenHeight_Landscape = UIScreen.mainScreen.bounds.size.height;
  }

  CGFloat screenScale = [UIScreen mainScreen].bounds.size.width/375.0;
  if (screenScale > 1) {
    screenScale = 1;
  }

  UIColor * style2Color = [UIColor colorWithRed:33/255.0 green:113/255.0 blue:242/255.0 alpha:1];;

  CLUIConfigure * baseUIConfigure = inputConfigure;

  //shanYanSloga
  baseUIConfigure.clShanYanSloganTextColor = UIColor.lightGrayColor;
  baseUIConfigure.clShanYanSloganTextFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:11.0*screenScale];
  baseUIConfigure.clShanYanSloganTextAlignment = @(NSTextAlignmentCenter);


  //横竖屏设置
  baseUIConfigure.shouldAutorotate = @(NO);
//  baseUIConfigure.supportedInterfaceOrientations = @(UIInterfaceOrientationMaskAll);
  //    baseUIConfigure.preferredInterfaceOrientationForPresentation = @(UIInterfaceOrientationLandscapeLeft);

  baseUIConfigure.clAuthTypeUseWindow = @(YES);
  baseUIConfigure.clAuthWindowCornerRadius = @(10);
  //    baseUIConfigure.clAuthWindowModalTransitionStyle = @(UIModalTransitionStyleCoverVertical);

  baseUIConfigure.clNavigationBackgroundClear = @(NO);
  //    baseUIConfigure.clNavigationBackBtnHidden = @(YES);
  baseUIConfigure.clNavigationBottomLineHidden = @(YES);
  baseUIConfigure.clNavBackBtnAlimentRight = @(YES);
  //LOGO
  baseUIConfigure.clLogoImage = [UIImage imageNamed:@"闪验logo2"];

  //PhoneNumber
  baseUIConfigure.clPhoneNumberColor = style2Color;
  baseUIConfigure.clPhoneNumberFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:18.0*screenScale];

  //LoginBtn
  //    baseUIConfigure.clLoginBtnText = [NSString stringWithFormat:@"一键登录%f",CFAbsoluteTimeGetCurrent()];
  baseUIConfigure.clLoginBtnText = @"一键登录";

  baseUIConfigure.clLoginBtnTextFont = [UIFont systemFontOfSize:15*screenScale];
  baseUIConfigure.clLoginBtnBgColor = style2Color;
  baseUIConfigure.clLoginBtnCornerRadius = @(10*screenScale);
  baseUIConfigure.clLoginBtnTextColor = UIColor.whiteColor;

  //Privacy
  baseUIConfigure.clAppPrivacyFirst = @[@"测试连接A",@"https://www.baidu.com"];
  baseUIConfigure.clAppPrivacySecond = @[@"18055352658",@"https://www.sina.com"];

  baseUIConfigure.clAppPrivacyColor = @[[UIColor lightGrayColor],style2Color];
  baseUIConfigure.clAppPrivacyTextAlignment = @(NSTextAlignmentCenter);
  baseUIConfigure.clAppPrivacyTextFont = [UIFont systemFontOfSize:11];
  //        baseUIConfigure.clAppPrivacyLineSpacing = @(2);
  //        baseUIConfigure.clAppPrivacyNeedSizeToFit = @(YES);

  //CheckBox
  //    baseUIConfigure.clCheckBoxHidden = @(YES);
  baseUIConfigure.clCheckBoxValue = @(NO);
  baseUIConfigure.clCheckBoxCheckedImage = [UIImage imageNamed:@"checkbox-multiple-ma"];
  baseUIConfigure.clCheckBoxUncheckedImage = [UIImage imageNamed:@"checkbox-multiple-bl"];
  baseUIConfigure.clCheckBoxImageEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(8, 8, 0, 0)];

  //Slogan
  baseUIConfigure.clSloganTextColor = UIColor.lightGrayColor;
  baseUIConfigure.clSloganTextFont = [UIFont systemFontOfSize:11.0];
  baseUIConfigure.clSlogaTextAlignment = @(NSTextAlignmentCenter);

  UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
  [rightButton setImage:[UIImage imageNamed:@"close-black"] forState:(UIControlStateNormal)];
  UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
  [rightButton addTarget:self action:@selector(dismissCurrentVC) forControlEvents:UIControlEventTouchUpInside];

  // 自定义优先级更高
  //    baseUIConfigure.clNavigationRightControl = right;


  __weak typeof(self) weakSelf = self;
  baseUIConfigure.customAreaView = ^(UIView * _Nonnull customAreaView) {
    __strong typeof(weakSelf) strongSelf = weakSelf;

    UIButton * weChat = [[UIButton alloc]init];
    [weChat setBackgroundImage:[UIImage imageNamed:@"微信"] forState:(UIControlStateNormal)];
    [customAreaView addSubview:weChat];
    UIButton * qq = [[UIButton alloc]init];
    [qq setBackgroundImage:[UIImage imageNamed:@"qq"] forState:(UIControlStateNormal)];
    [customAreaView addSubview:qq];

    UIButton * weibo = [[UIButton alloc]init];
    [weibo setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:(UIControlStateNormal)];
    [customAreaView addSubview:weibo];

    //布局
    [strongSelf setSeylt3Contrains:weChat qq:qq webo:weibo customView:customAreaView];

//    //屏幕旋转通知
//    strongSelf-> _notifObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarFrameNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
//      __strong typeof(weakSelf) strongSelf = weakSelf;
//      [strongSelf setSeylt3Contrains:weChat qq:qq webo:weibo customView:customAreaView];
//    }];
  };


  //layout 布局
  //布局-竖屏
  CLOrientationLayOut * clOrientationLayOutPortrait = [CLOrientationLayOut new];

  //窗口
  clOrientationLayOutPortrait.clAuthWindowOrientationWidth = @(screenWidth_Portrait * 0.8);
  clOrientationLayOutPortrait.clAuthWindowOrientationHeight = @(screenHeight_Portrait * 0.5);
  clOrientationLayOutPortrait.clAuthWindowOrientationCenter = [NSValue valueWithCGPoint:CGPointMake(screenWidth_Portrait*0.5, screenHeight_Portrait*0.5)];
  //    clOrientationLayOutPortrait.clAuthWindowOrientationOrigin = [NSValue valueWithCGPoint:CGPointMake(0, screenHeight_Portrait*0.5)];

  //控件
  clOrientationLayOutPortrait.clLayoutLogoWidth = @(108*screenScale);
  clOrientationLayOutPortrait.clLayoutLogoHeight = @(44*screenScale);
  clOrientationLayOutPortrait.clLayoutLogoCenterX = @(0);
  clOrientationLayOutPortrait.clLayoutLogoTop = @(clOrientationLayOutPortrait.clAuthWindowOrientationHeight.floatValue*0.15);

  clOrientationLayOutPortrait.clLayoutPhoneTop = @(clOrientationLayOutPortrait.clLayoutLogoTop.floatValue + clOrientationLayOutPortrait.clLayoutLogoHeight.floatValue);
  clOrientationLayOutPortrait.clLayoutPhoneCenterX = @(0);
  clOrientationLayOutPortrait.clLayoutPhoneHeight = @(25*screenScale);
  clOrientationLayOutPortrait.clLayoutPhoneWidth = @(screenWidth_Portrait*0.8);

  clOrientationLayOutPortrait.clLayoutLoginBtnTop= @(clOrientationLayOutPortrait.clAuthWindowOrientationHeight.floatValue*0.4 + 15*screenScale);
  clOrientationLayOutPortrait.clLayoutLoginBtnHeight = @(40*screenScale);
  clOrientationLayOutPortrait.clLayoutLoginBtnLeft = @(20*screenScale);
  clOrientationLayOutPortrait.clLayoutLoginBtnRight = @(-20*screenScale);

  clOrientationLayOutPortrait.clLayoutAppPrivacyLeft = @(40*screenScale);
  clOrientationLayOutPortrait.clLayoutAppPrivacyRight = @(-40*screenScale);
  clOrientationLayOutPortrait.clLayoutAppPrivacyBottom = @(0);
  clOrientationLayOutPortrait.clLayoutAppPrivacyHeight = @(65*screenScale);

  clOrientationLayOutPortrait.clLayoutSloganLeft = @(0);
  clOrientationLayOutPortrait.clLayoutSloganRight = @(0);
  clOrientationLayOutPortrait.clLayoutSloganHeight = @(15);
  clOrientationLayOutPortrait.clLayoutSloganBottom = @(clOrientationLayOutPortrait.clLayoutAppPrivacyBottom.floatValue - clOrientationLayOutPortrait.clLayoutAppPrivacyHeight.floatValue);




  //布局-横屏
  CLOrientationLayOut * clOrientationLayOutLandscape = [CLOrientationLayOut new];

  clOrientationLayOutLandscape.clAuthWindowOrientationWidth = @(screenWidth_Landscape * 0.6);
  clOrientationLayOutLandscape.clAuthWindowOrientationHeight = @(screenHeight_Landscape * 0.8);
  clOrientationLayOutLandscape.clAuthWindowOrientationCenter = [NSValue valueWithCGPoint:CGPointMake(screenWidth_Landscape*0.5, screenHeight_Landscape*0.5)];

  //控件
  clOrientationLayOutLandscape.clLayoutLogoWidth = @(108*screenScale);
  clOrientationLayOutLandscape.clLayoutLogoHeight = @(44*screenScale);
  clOrientationLayOutLandscape.clLayoutLogoCenterX = @(0);
  clOrientationLayOutLandscape.clLayoutLogoTop = @(clOrientationLayOutLandscape.clAuthWindowOrientationHeight.floatValue*0.15);

  clOrientationLayOutLandscape.clLayoutPhoneTop = @(clOrientationLayOutLandscape.clLayoutLogoTop.floatValue + clOrientationLayOutLandscape.clLayoutLogoHeight.floatValue);
  clOrientationLayOutLandscape.clLayoutPhoneCenterX = @(0);
  clOrientationLayOutLandscape.clLayoutPhoneHeight = @(25*screenScale);
  clOrientationLayOutLandscape.clLayoutPhoneWidth = @(screenWidth_Landscape*0.8);

  clOrientationLayOutLandscape.clLayoutLoginBtnTop= @(clOrientationLayOutLandscape.clAuthWindowOrientationHeight.floatValue*0.4 + 15*screenScale);
  clOrientationLayOutLandscape.clLayoutLoginBtnHeight = @(40*screenScale);
  clOrientationLayOutLandscape.clLayoutLoginBtnLeft = @(60*screenScale);
  clOrientationLayOutLandscape.clLayoutLoginBtnRight = @(-60*screenScale);

  clOrientationLayOutLandscape.clLayoutAppPrivacyLeft = @(60*screenScale);
  clOrientationLayOutLandscape.clLayoutAppPrivacyRight = @(-60*screenScale);
  clOrientationLayOutLandscape.clLayoutAppPrivacyBottom = @(0);
  clOrientationLayOutLandscape.clLayoutAppPrivacyHeight = @(55*screenScale);

  clOrientationLayOutLandscape.clLayoutSloganLeft = @(0);
  clOrientationLayOutLandscape.clLayoutSloganRight = @(0);
  clOrientationLayOutLandscape.clLayoutSloganHeight = @(15);
  clOrientationLayOutLandscape.clLayoutSloganBottom = @(clOrientationLayOutLandscape.clLayoutAppPrivacyBottom.floatValue - clOrientationLayOutLandscape.clLayoutAppPrivacyHeight.floatValue);

  baseUIConfigure.clOrientationLayOutPortrait = clOrientationLayOutPortrait;
  baseUIConfigure.clOrientationLayOutLandscape = clOrientationLayOutLandscape;

  return baseUIConfigure;
}
-(void)setSeylt3Contrains:(UIView *)wx qq:(UIView*)qq webo:(UIView *)wb customView:(UIView *)customView{
  CGFloat screenScale = [UIScreen mainScreen].bounds.size.width/375.0;
  if (screenScale > 1) {
    screenScale = 1;
  }
  CGFloat screenWidth_Portrait;
  CGFloat screenHeight_Portrait;
  CGFloat screenWidth_Landscape;
  CGFloat screenHeight_Landscape;
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
    screenWidth_Portrait = UIScreen.mainScreen.bounds.size.width;
    screenHeight_Portrait = UIScreen.mainScreen.bounds.size.height;
    screenWidth_Landscape = UIScreen.mainScreen.bounds.size.height;
    screenHeight_Landscape = UIScreen.mainScreen.bounds.size.width;
  }else{
    screenWidth_Portrait = UIScreen.mainScreen.bounds.size.height;
    screenHeight_Portrait = UIScreen.mainScreen.bounds.size.width;
    screenWidth_Landscape = UIScreen.mainScreen.bounds.size.width;
    screenHeight_Landscape = UIScreen.mainScreen.bounds.size.height;
  }



//  if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
//    //竖屏
//    [qq mas_remakeConstraints:^(MASConstraintMaker *make) {
//      make.centerX.mas_equalTo(0);
//      make.bottom.mas_equalTo( - 45*screenScale - 15 - 30*screenScale);//
//      make.width.height.mas_equalTo(35);
//    }];
//    [wx mas_remakeConstraints:^(MASConstraintMaker *make) {
//      make.centerY.width.height.mas_equalTo(qq);
//      make.right.mas_equalTo(qq.mas_left).mas_offset(-40);
//    }];
//    [wb mas_remakeConstraints:^(MASConstraintMaker *make) {
//      make.centerY.width.height.mas_equalTo(qq);
//      make.left.mas_equalTo(qq.mas_right).mas_offset(40);
//    }];
//  }else{
//    [qq mas_remakeConstraints:^(MASConstraintMaker *make) {
//      make.centerX.mas_equalTo(0);
//      make.bottom.mas_equalTo(-45*screenScale - 15 - 10*screenScale);//
//      make.width.height.mas_equalTo(35);
//    }];
//    [wx mas_remakeConstraints:^(MASConstraintMaker *make) {
//      make.centerY.width.height.mas_equalTo(qq);
//      make.right.mas_equalTo(qq.mas_left).mas_offset(-40);
//    }];
//    [wb mas_remakeConstraints:^(MASConstraintMaker *make) {
//      make.centerY.width.height.mas_equalTo(qq);
//      make.left.mas_equalTo(qq.mas_right).mas_offset(40);
//    }];
//  }
}


- (void)dismissCurrentVC{
  dispatch_async(dispatch_get_main_queue(), ^{
    [CLShanYanSDKManager finishAuthControllerAnimated:YES Completion:nil];
  });
}

@end
