import Asiapay from 'asiapay';

export const btnAlipayOnPress = (merchantId) => {
    Asiapay.alipayHK(merchantId, '1', 'HKD', Date.now().toString(), 'Test');
}

export const btnAlipayGlobalOnPress = (merchantId) => {
    Asiapay.alipayGlobal(merchantId, '1', 'HKD', Date.now().toString(), 'Test');
}

export const btnOctopusOnPress = (merchantId) => {
    Asiapay.octopus(merchantId, '1', Date.now().toString(), 'Test');
}

export const btnApplePayOnPress = (merchantId) => {
    Asiapay.applepay(merchantId, '1', 'HKD', Date.now().toString(), 'Test');
}

export const btnWechatOnPress = (merchantId) => {
    Asiapay.wechat(merchantId, '1', Date.now().toString(), 'Test');
}

export const btnCreditCardOnPress = (merchantId, cardDetailModel, extraDataModel) => {
    Asiapay.creditCard(merchantId, '1', 'HKD', 'VISA', Date.now().toString(), 'Test',
        {
          cardNo: cardDetailModel.cardNo,
          month: cardDetailModel.month,
          year: cardDetailModel.year,
          cardHolder: cardDetailModel.cardHolder,
          cvc: cardDetailModel.cvc,
        },
        {
          addNewMember: extraDataModel.addNewMember,
          memberPay_service: extraDataModel.memberPayService,
          memberPay_memberId: extraDataModel.memberPayMemberId,
          memberId: extraDataModel.memberId,
        },
        'N'
      )
        .then((s) => {
          console.log(s);
        })
        .catch(({ code, message }) => {
          console.log(code, message);
        });
}

export const btnUnionPayOnPress = (merchantId) => {
    Asiapay.unionpay(merchantId, '1',  Date.now().toString(), 'Test');
}

export const btnSamsungPayOnPress = (merchantId) => {
    Asiapay.samsungpay(merchantId, '1', Date.now().toString(), 'Test');
}

export const btnPaymeOnPress = (merchantId) => {
    Asiapay.payme(merchantId, '1.81', Date.now().toString(), 'Test');
}

export const btnFpsOnPress = (merchantId) => {
    Asiapay.fps(merchantId, '1', "8163601", 'Test');
}

export const btnHostedCallOnPress = (merchantId) => {
    Asiapay.hostedcall(merchantId, '1', 'HKD', Date.now().toString(), 'Test');
}

export const btnGooglePayOnPress = (merchantId) => {
    Asiapay.googlepay(merchantId, '1', 'HKD', Date.now().toString(), 'Test');
}
