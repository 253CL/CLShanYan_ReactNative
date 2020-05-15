/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React from 'react';
import ShanYanSDKModule from './ShanYanSDK.js';

import {
  SafeAreaView,
  StyleSheet,
  DeviceEventEmitter,
  TouchableHighlight,
  Text,
  ScrollView,
  View,
  StatusBar,
  Platform,
  default as Alert,
} from 'react-native';

import {NativeEventEmitter, NativeModules} from 'react-native';

const shanYanSDKModule = NativeModules.RNTShanYanSDKModule;

//监听原生代码发送过来的消息
const nativeEventEmitter = new NativeEventEmitter(shanYanSDKModule);
const onReceiveAuthPageEventSubscription = nativeEventEmitter.addListener(
  'onReceiveAuthPageEvent',
  result => {
    // if (result[0]) {
    //   alert(JSON.stringify(result[0]));
    // } else {
    //   alert(JSON.stringify(result[1]));
    // }
    alert(JSON.stringify(result));
  },
);
const oneKeyLoginListenerEventSubscription = nativeEventEmitter.addListener(
    'oneKeyLoginListener',
    result => {
      alert(JSON.stringify(result));
    },
);

//取消订阅
function componentWillUnmount() {
  onReceiveAuthPageEventSubscription.remove();
  oneKeyLoginListenerEventSubscription.remove();
}

//初始化
function init() {
  if (Platform.OS === 'android') {
    ShanYanSDKModule.init(
      {
        appid: 'loXN4jDs',
      },
      complete => {
        alert(JSON.stringify(complete));
      },
    );
  } else {
    shanYanSDKModule.init('eWWfA2KJ', (error, result) => {
      if (error) {
        alert('失败：' + JSON.stringify(error));
      } else {
        alert('成功：' + JSON.stringify(result));
      }
    });
  }
}
//预取号
function preInit() {
  if (Platform.OS === 'android') {
    ShanYanSDKModule.getPhoneInfo(complete => {
      alert(JSON.stringify(complete));
    });
  } else {
    shanYanSDKModule.preGetPhonenumber((error, result) => {
      if (error) {
        alert('预取号失败：' + JSON.stringify(error));
      } else {
        alert('预取号成功：' + JSON.stringify(result));
      }
    });
  }
}

//设置授权页样式
function setAuthThemeConfig() {
  if (Platform.OS === 'android') {
    ShanYanSDKModule.setAuthThemeConfig(complete => {
      console.log(JSON.stringify(complete));
    });
  } else {
    alert('iOS用户请直接拉起授权页面查看或在模块中页面配置查看源码');
  }
}

//拉起授权页方法
function login() {
  if (Platform.OS === 'android') {
    ShanYanSDKModule.openLoginAuth(false);
  } else {
    shanYanSDKModule.quickAuthLoginOpenLoginAuthListener((error, result) => {
      if (error) {
        alert('一键登录失败：' + JSON.stringify(error));
      } else {
        //一键登录成功后关闭授权页面
        shanYanSDKModule.closeAuthPage((error) => {
          alert('一键登录成功：' + JSON.stringify(result));
        });
      }
    });
  }
}

function actionListener() {
  shanYanSDKModule.setAuthPageActionListener((err, result) => {
    // let type = result['type'];
    // let code = result['code'];
    // let message = result['message'];
    alert(JSON.stringify(result));
    // console.log('type=' + type + '|code=' + code + '|message=' + message);
  });
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  setBtnStyle: {
    width: 320,
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 10,
    borderWidth: 1,
    borderColor: '#3e83d7',
    borderRadius: 8,
    backgroundColor: '#3e83d7',
    padding: 10,
  },
  textStyle: {
    textAlign: 'center',
    fontSize: 25,
    color: '#ffffff',
  },
  result_group: {
    display: 'flex',
    backgroundColor: '#B9F6CA',
    borderRadius: 10,
  },

  text_attr: {
    width: '95%',
    marginLeft: 3,
    marginTop: 3,
    marginBottom: 3,
    marginRight: 3,
    fontSize: 3,
  },
});

class Button extends React.Component {
  render() {
    // eslint-disable-next-line react/jsx-no-undef
    return (
      // eslint-disable-next-line react/jsx-no-undef
      <TouchableHighlight
        onPress={this.props.onPress}
        underlayColor="#00000000"
        activeOpacity={0.5}>
        <View style={styles.setBtnStyle}>
          {/* eslint-disable-next-line react/jsx-no-undef */}
          <Text style={styles.textStyle}>{this.props.title}</Text>
        </View>
      </TouchableHighlight>
    );
  }
}

export default class App extends React.Component {
  componentDidMount() {
    // eslint-disable-next-line no-undef
    DeviceEventEmitter.addListener(
      'getOpenLoginAuthStatus',
      this.onScanningResult,
    );
  }

  onScanningResult = e => {
    this.setState({
      scanningResult: e.result,
    });
    if (e.type == 1) {
      ShanYanSDKModule.finishAuthActivity();
    }
    alert('LoginListener:' + JSON.stringify(e.result));

    // DeviceEventEmitter.removeListener('onScanningResult',this.onScanningResult);//移除扫描监听
  };

  render() {
    return (
      <View style={styles.container}>
        <Button title="初始化" onPress={() => init()} />

        <Button title="预取号" onPress={() => preInit()} />

        <Button title="设置授权页样式" onPress={() => setAuthThemeConfig()} />

        <Button title="拉起授权页" onPress={() => login()} />
        <Button title="控件点击回调" onPress={() => actionListener()} />
      </View>
    );
  }
}
