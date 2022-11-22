import React, { Component } from 'react';
import { StyleSheet, Text, TouchableOpacity } from 'react-native';
import PropTypes from 'prop-types';

class PayMethodButton extends Component {
    static propTypes = {
        txtButton: PropTypes.string,
        onPress: PropTypes.func
    }

    constructor(props) {
        super(props);
    }

    render() {
        return (
            <TouchableOpacity
                onPress={() => this.props.onPress()}
                style={styles.button}>
                <Text style={styles.buttonTxt}>{this.props.txtButton}</Text>  
            </TouchableOpacity>
        );
    }
}

PayMethodButton.propTypes = {
    txtButton: PropTypes.string,
    onPress: PropTypes.func
}

export default PayMethodButton;

const styles = StyleSheet.create({
    container: {
      flex: 1,
      alignItems: 'center',
      justifyContent: 'center',
    },
    box: {
      width: 60,
      height: 60,
      marginVertical: 20,
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
    buttonTxt: {
      color: 'white',
    },
  });