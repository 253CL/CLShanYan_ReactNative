/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, Alert, Button} from 'react-native';

import { NativeModules } from 'react-native'
// //强制Debug模式
// if (__DEV__) {
//   NativeModules.DevSettings.setIsDebuggingRemotely(true)
// }
//
const shanYanManager = NativeModules.RNTShanYanManager;

shanYanManager.initWithAppId("eWWfA2KJ", "tDo3Ml2K", 5, (data) => {

    console.log(JSON.stringify(data));

},(error) => {

    console.log("闪验_初始化_失败_回调：" + JSON.stringify(error));

})

shanYanManager.preGetPhonenumberTimeOut(5,(data) => {

    console.log(JSON.stringify(data));

},(error) => {

    console.log("闪验_预取号_失败_回调：" + JSON.stringify(error));

});



export default class HelloWorldApp extends Component {
  render() {
    return (
        <View style={{ flex: 1, justifyContent: "center", alignItems: "center" ,backgroundColor: "green"}}>
          <Button
              onPress={() => {

                  console.log("asdas");
                shanYanManager.quickAuthLoginWithTimeOut( 5.0, (quickAuthLogindata) => {

                    console.log(JSON.stringify(quickAuthLogindata));

                    Alert.alert("闪验_获取一键登录获取token_成功_回调：" + JSON.stringify(quickAuthLogindata));


                },(error) => {

                    Alert.alert("闪验_一键登录_失败_回调：" + JSON.stringify(error));

                });
              }}
              title="点我！"
          />
        </View>
    );
  }
}
