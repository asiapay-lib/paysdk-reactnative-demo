import * as React from 'react';
import {EnvType} from './enum/Enums';

import Asiapay from 'asiapay';
import CardDetailModel from './interface/CardDetailModel';
import ExtraDataModel from './interface/ExtraDataModel';
import HomePage from './view/HomePage';
import { merchantId } from './config/config';

export default function App() {
  React.useEffect(() => {
    Asiapay.setup(EnvType.SANDBOX, merchantId);
  }, []);

  const cardDetailModel = new CardDetailModel(
    '4111111111110071',
    '7',
    '2023',
    'tester',
    '123'
  );

  const extraDataModel = new ExtraDataModel(
    true, 
    'T', 
    'm2', 
    'm2'
  );

  return (<HomePage merchantId={merchantId} cardDetailModel={cardDetailModel} extraDataModel={extraDataModel}/>);
}
