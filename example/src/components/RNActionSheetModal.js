import PropTypes from 'prop-types';
import React from 'react';
import { StyleSheet, Text, TouchableHighlight, View, TouchableOpacity } from 'react-native';
import Modal from 'react-native-modal';
import { useTranslation } from "react-i18next";
import { Locale } from '../enum/Enums';

const PRIMARY_COLOR = 'rgb(0,98,255)';
const WHITE = '#ffffff';
const BORDER_COLOR = '#DBDBDB';

export default function RNActionSheetModal() {
  const { t, i18n } = useTranslation();

  const changeLanguage = lng => {
    i18n.changeLanguage(lng);
  }

  const actionItems = [
    {
      id: 1,
      label: t('home.lblEnglish'),
      onPress: () => {
        changeLanguage(Locale.EN);
        setActionSheet(false);
      }
    },
    {
      id: 2,
      label: t('home.lblTradChinese'),
      onPress: () => {
        changeLanguage(Locale.zhHK);
        setActionSheet(false);
      }
    },
    {
      id: 3,
      label: t('home.lblSimpChinese'),
      onPress: () => {
        changeLanguage(Locale.zhCN);
        setActionSheet(false);
      }
    },
  ];

  const [actionSheet, setActionSheet] = React.useState(false);
  const closeActionSheet = () => setActionSheet(false);

  return (
    <View>
      <TouchableOpacity activeOpacity={0.7} onPress={() => setActionSheet(true)}>
        <View style={styles.btnLang}><Text style={styles.buttonTxt}>{t('home.lblLanguage')}</Text></View>
      </TouchableOpacity>
      <Modal isVisible={actionSheet} style={{ margin: 0, justifyContent: 'flex-end' }} >
        <RNActionSheet actionItems={actionItems} onCancel={closeActionSheet} />
      </Modal>
    </View>
  );
}

const RNActionSheet = (props) => {
  const { actionItems } = props;
  const actionSheetItems = [
    ...actionItems,
    {
      id: '#cancel',
      label: 'Cancel',
      onPress: props?.onCancel
    }
  ]
  return (
    <View style={styles.modalContent}>
      {
        actionSheetItems.map((actionItem, index) => {
          return (
            <TouchableHighlight
              style={[
                styles.actionSheetView,
                index === 0 && {
                  borderTopLeftRadius: 12,
                  borderTopRightRadius: 12,
                },
                index === actionSheetItems.length - 2 && {
                  borderBottomLeftRadius: 12,
                  borderBottomRightRadius: 12,
                },
                index === actionSheetItems.length - 1 && {
                  borderBottomWidth: 0,
                  backgroundColor: WHITE,
                  marginTop: 8,
                  borderTopLeftRadius: 12,
                  borderTopRightRadius: 12,
                  borderBottomLeftRadius: 12,
                  borderBottomRightRadius: 12,
                }]}
              underlayColor={'#f7f7f7'}
              key={index} onPress={actionItem.onPress}
            >
              <Text allowFontScaling={false}
                style={[
                  styles.actionSheetText,
                  props?.actionTextColor && {
                    color: props?.actionTextColor
                  },
                  index === actionSheetItems.length - 1 && {
                    color: '#fa1616',
                  }
                ]}>
                {actionItem.label}
              </Text>
            </TouchableHighlight>
          )
        })
      }
    </View>
  )
}

const styles = StyleSheet.create({
  modalContent: {
    borderTopLeftRadius: 12,
    borderTopRightRadius: 12,
    borderBottomLeftRadius: 12,
    borderBottomRightRadius: 12,
    marginLeft: 8,
    marginRight: 8,
    marginBottom: 20,
  },
  actionSheetText: {
    fontSize: 18,
    color: PRIMARY_COLOR
  },
  actionSheetView: {
    backgroundColor: WHITE,
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    paddingTop: 16,
    paddingBottom: 16,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderColor: BORDER_COLOR
  },
  buttonTxt: {
    color: 'white',
  },
  button: {
    width: '50%',
    alignSelf: 'center',
    height: 40,
    backgroundColor: 'skyblue',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 5,
    marginVertical: 10,
  },
  btnLang: {
    width: '50%',
    alignSelf: 'center',
    height: 40,
    backgroundColor: 'grey',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 5,
    marginVertical: 10,
  },
});

RNActionSheet.propTypes = {
  actionItems: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
      label: PropTypes.string,
      onPress: PropTypes.func
    })
  ).isRequired,
  onCancel: PropTypes.func,
  actionTextColor: PropTypes.string
}


RNActionSheet.defaultProps = {
  actionItems: [],
  onCancel: () => { },
  actionTextColor: null
}

