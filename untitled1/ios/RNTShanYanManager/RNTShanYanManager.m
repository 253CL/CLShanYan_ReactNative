//
//  RNTShanYanManager.m
//  untitled
//
//  Created by wanglijun on 2019/3/21.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RNTShanYanManager.h"
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>

#define cl_SDK_APPID    @"eWWfA2KJ"
#define cl_SDK_APPKEY   @"tDo3Ml2K"

@implementation RNTShanYanManager

// To export a module named CalendarManager
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(
                  initWithAppId:(NSString *)appId
                  AppKey:(NSString *)appKey
                  timeOut:(float)timeOut
                  success:(RCTResponseSenderBlock)success
                  failure:(RCTResponseErrorBlock)failure){
  
    if(timeOut == 0) timeOut = 5;
  
    [CLShanYanSDKManager initWithAppId:appId AppKey:appKey complete:^(CLCompleteResult * _Nonnull completeResult) {
      
        if (completeResult.error) {
          NSLog(@"RNTShanYanManager_初始化_失败:->%@",completeResult.data);
          if (failure) {
            failure(completeResult.error);
          }
        }else{
          NSLog(@"RNTShanYanManager_初始化_成功:->%@",completeResult.data);
          if (success) {
            NSDictionary * data = completeResult.data;
            if(data == nil){
              data = [NSDictionary dictionary];
            }
            success(@[data]);
          }
        }
    }];
}

RCT_EXPORT_METHOD(preGetPhonenumberTimeOut:(float)timeOut
                  success:(RCTResponseSenderBlock)success
                  failure:(RCTResponseErrorBlock)failure){
  [CLShanYanSDKManager preGetPhonenumber:^(CLCompleteResult * _Nonnull completeResult) {
    if (completeResult.error) {
      if (failure) {
        failure(completeResult.error);
      }
    }else{
      if (success) {
        NSDictionary * data = completeResult.data;
        if(data == nil){
          data = [NSDictionary dictionary];
        }
        success(@[data]);
      }
    }
  }];
  
}

RCT_EXPORT_METHOD(
                  quickAuthLoginWithTimeOut:(float)timeOut
                  success:(RCTResponseSenderBlock)success
                  failure:(RCTResponseErrorBlock)failure){
  
//  RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
  UIViewController * currentVC = RCTPresentedViewController();
  
  CLUIConfigure * baseUIConfigure;
  baseUIConfigure = [self configureStyle5:[CLUIConfigure new]];

  baseUIConfigure.viewController = currentVC;
  baseUIConfigure.manualDismiss = @(YES);
  
  __weak typeof(self) weakSelf = self;
  
  [CLShanYanSDKManager quickAuthLoginWithConfigure:baseUIConfigure openLoginAuthListener:^(CLCompleteResult * _Nonnull completeResult) {
//    dispatch_async(dispatch_get_main_queue(), ^{
//      [CLHUD hideLoading:weakSelf.view];
//    });
    if (completeResult.error) {
      if (failure) {
        failure(completeResult.error);
      }
    }else{
      NSLog(@"openLoginAuthListener:%@",completeResult.message);
    }
  } oneKeyLoginListener:^(CLCompleteResult * _Nonnull completeResult) {
    __strong typeof(self) strongSelf = weakSelf;
//    dispatch_async(dispatch_get_main_queue(), ^{
//      [CLHUD hideLoading:strongSelf.view];
//    });
    
    if (completeResult.error) {
      
      NSLog(@"oneKeyLoginListener:%@",completeResult.error.description);
      
      //提示：错误无需提示给用户，可以在用户无感知的状态下直接切换登录方式
      if (completeResult.code == 1011){
        //用户取消登录（点返回）
        //处理建议：如无特殊需求可不做处理，仅作为交互状态回调，此时已经回到当前用户自己的页面
        //点击sdk自带的返回，无论是否设置手动销毁，授权页面都会强制关闭
      }  else{
        

        //处理建议：其他错误代码表示闪验通道无法继续，可以统一走开发者自己的其他登录方式，也可以对不同的错误单独处理
        //1003    一键登录获取token失败
        //其他     其他错误//
        
        //关闭授权页
        [CLShanYanSDKManager finishAuthControllerAnimated:YES Completion:^{
          if (failure) {
            failure(completeResult.error);
          }
        }];
      }
    }else{
      
      NSLog(@"oneKeyLoginListener:%@",completeResult.message);

      //关闭授权页
      [CLShanYanSDKManager finishAuthControllerAnimated:YES Completion:^{
        if (success) {
          NSDictionary * data = completeResult.data;
          if(data == nil){
            data = [NSDictionary dictionary];
          }
          success(@[data]);
        }
      }];
    }
  }];
}
#pragma mark - 样式5：窗口横竖屏两套布局样式
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
  
  //横竖屏设置
  baseUIConfigure.shouldAutorotate = @(YES);
  baseUIConfigure.supportedInterfaceOrientations = @(UIInterfaceOrientationMaskAll);
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

//RCT_EXPORT_METHOD(POST_url:(NSString *)urlString withParameter:(NSDictionary *)parameter TimeOut:(float)timeOut
//                  success:(RCTResponseSenderBlock)success
//                  failure:(RCTResponseErrorBlock)failure){
//    [RNTShanYanManager POST_url:urlString withParameter:parameter TimeOut:timeOut success:success failure:failure];
//}

//+(void)POST_url:(NSString *)urlString withParameter:(NSDictionary *)parameter TimeOut:(float)timeOut
//        success:(nullable RCTResponseSenderBlock)success
//        failure:(nullable RCTResponseErrorBlock)failure{
//
//  //原生NSURLSession:
//  NSURL *nsurl = [NSURL URLWithString:urlString];
//  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
//  request.HTTPMethod = @"POST";
//  //URLEncode
//  NSString *charactersToEscape = @"#[]@!$'()*+,;\"<>%{}|^~`";
//  NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
//  NSMutableString *formDataString = [NSMutableString new];
//  [parameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//    NSString * objString = [NSString stringWithFormat:@"%@",obj];
//    [formDataString appendString:[NSString stringWithFormat:@"%@=%@&", key, [objString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters]]];
//  }];
//  request.HTTPBody = [formDataString dataUsingEncoding:NSUTF8StringEncoding];
//
//  NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
//  if(timeOut == 0) timeOut = 5;
//  config.timeoutIntervalForRequest = timeOut;
//
//  NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//    if (error) {
//      if (failure) {
//        failure(error);
//      }
//    } else {
//      if (success) {
//
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        if (dic == nil) {
//          dic = [NSDictionary dictionary];
//        }
//        success(@[dic]);
//      }
//    }
//  }];
//  [dataTask resume];
//}

@end
