import * as React from "react";

import { StyleSheet, View, Text, ScrollView, Platform } from 'react-native';
import * as PayMethodOnPressListener from '../listener/PayMethodOnPressHandler';
import PayMethodButton from './PayMethodButton';
import { PlatformOS } from "../enum/Enums";
import { useTranslation } from "react-i18next";
import RNActionSheetModal from "../components/RNActionSheetModal";

export default function HomePage ( {merchantId, cardDetailModel, extraDataModel}) {
  const { t } = useTranslation();
  
  if (Platform.OS == PlatformOS.ANDROID) {
      return (
      <View style={[styles.container, {marginTop: 10}]}>
          <ScrollView style={styles.scrollview}>
            <Text>{t('home.lblResult')}:</Text>
            <PayMethodButton txtButton={t('home.lblAlipayHK')} onPress={() => PayMethodOnPressListener.btnAlipayOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblAlipayGlobal')} onPress={() => PayMethodOnPressListener.btnAlipayGlobalOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblOctopus')} onPress={() => PayMethodOnPressListener.btnOctopusOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblWechat')} onPress={() => PayMethodOnPressListener.btnWechatOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblCreditCard')} onPress={() => PayMethodOnPressListener.btnCreditCardOnPress(merchantId, cardDetailModel, extraDataModel)}/>
            <PayMethodButton txtButton={t('home.lblUnionpay')} onPress={() => PayMethodOnPressListener.btnUnionPayOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblSamsungpay')} onPress={() => PayMethodOnPressListener.btnSamsungPayOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblPayme')} onPress={() => PayMethodOnPressListener.btnPaymeOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblFPS')} onPress={() => PayMethodOnPressListener.btnFpsOnPress(merchantId)}/>           
            <PayMethodButton txtButton={t('home.lblGooglePay')} onPress={() => PayMethodOnPressListener.btnGooglePayOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblHostedCall')} onPress={() => PayMethodOnPressListener.btnHostedCallOnPress(merchantId)}/>
            <RNActionSheetModal></RNActionSheetModal>
          </ScrollView>
      </View>    
      );
      } else if(Platform.OS == PlatformOS.IOS) {
      return (
          <View style={styles.container}>
          <ScrollView style={styles.scrollview}>
            <Text>{t('home.lblResult')}:</Text>
            <PayMethodButton txtButton={t('home.lblAlipayHK')} onPress={() => PayMethodOnPressListener.btnAlipayOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblAlipayGlobal')} onPress={() => PayMethodOnPressListener.btnAlipayGlobalOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblOctopus')} onPress={() => PayMethodOnPressListener.btnOctopusOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblWechat')} onPress={() => PayMethodOnPressListener.btnWechatOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblCreditCard')} onPress={() => PayMethodOnPressListener.btnCreditCardOnPress(merchantId, cardDetailModel, extraDataModel)}/>
            <PayMethodButton txtButton={t('home.lblUnionpay')} onPress={() => PayMethodOnPressListener.btnUnionPayOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblApplePay')} onPress={() => PayMethodOnPressListener.btnApplePayOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblPayme')} onPress={() => PayMethodOnPressListener.btnPaymeOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblFPS')} onPress={() => PayMethodOnPressListener.btnFpsOnPress(merchantId)}/>
            <PayMethodButton txtButton={t('home.lblHostedCall')} onPress={() => PayMethodOnPressListener.btnHostedCallOnPress(merchantId)}/>
            <RNActionSheetModal></RNActionSheetModal>
          </ScrollView>
          </View>
      );
  }
  return <></>;
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    // alignItems: 'center',
    justifyContent: 'center',
    marginTop: 60,
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
  scrollview: {
    marginHorizontal: 20,
  },
  button: {
    width: '50%',
    alignSelf: 'center',
    height: 40,
    backgroundColor: 'green',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 5,
    marginVertical: 10,
  },
  buttonTxt: {
    color: 'white',
  },
});
