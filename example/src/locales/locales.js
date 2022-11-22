import i18n from 'i18next';
import Backend from "i18next-http-backend";
import LanguageDetector from "i18next-browser-languagedetector";
import { initReactI18next } from "react-i18next";
import EN from './i18n/en.json';
import zh_HK from './i18n/zh-hk.json';
import zh_CN from './i18n/zh-cn.json';
import { Locale } from '../enum/Enums';

const resources = { 
  en: {
    translation: EN
  },
  zhHK: {
    translation: zh_HK
  },
  zhCN: {
    translation: zh_CN
  }
}

i18n
.use(Backend)
.use(LanguageDetector)
.use(initReactI18next)
.init({
  lng: Locale.EN,
  fallbackLng: Locale.EN,
  debug: false,
  resources: resources,
  interpolation: {
    escapeValue: false // not needed for react as it escapes by default
  }
});

export default i18n;