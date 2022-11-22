import { NativeModules } from 'react-native';

const { Asiapay } = NativeModules;

type AsiapayType = {
  setup(envType: string, mId: string): void;
  // alipay(amount: string, currency: string, orderRef: string, remark: string): Promise<Map<string, string>>;
  alipayHK(merchantId: string, amount: string, currency: string, orderRef: string, remark: string): Promise<Map<string, string>>;
  alipayGlobal(merchantId: string, amount: string, currency: string, orderRef: string, remark: string): Promise<Map<string, string>>;
  octopus(merchantId: string, amount: string, orderRef: string, remark: string): Promise<Map<string, string>>;
  wechat(merchantId: string, amount: string, orderRef: string, remark: string): Promise<Map<string, string>>;  
  creditCard(merchantId: string, 
    amount: string,
    currency: string,
    method: string,
    orderRef: string,
    remark: string,
    cardDetails: { [key: string]: string },
    extraData: { [key: string]: string | boolean | number },
    payType: string
  ): Promise<Map<string, string>>;
  unionpay(merchantId: string, amount: string, orderRef: string, remark: string): Promise<Map<string, string>>;
  fps(merchantId: string, amount: string, orderRef: string, remark: string): Promise<Map<string, string>>;
  samsungpay(merchantId: string, amount: string, orderRef: string, remark: string): Promise<Map<string, string>>;
  applepay(merchantId: string, amount: string, currency: string, orderRef: string, remark: string): Promise<Map<string, string>>;
  payme(merchantId: string, amount: string, orderRef: string, remark: string): Promise<Map<string, string>>;
  hostedcall(merchantId: string, amount: string, currency: string, orderRef: string, remark: string): Promise<Map<string, string>>;
  googlepay(merchantId: string, amount: string, currency: string, orderRef: string, remark: string): Promise<Map<string, string>>;
};

export default Asiapay as AsiapayType;
