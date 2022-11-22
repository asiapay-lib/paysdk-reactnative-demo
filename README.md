# **Prototype of React Native Bridge for AsiaPay PaySDK**

## **Environment Setup**

- **Environment Requirement**

    - **For General**

    ```
    react-native version: 0.60.0+
    ```

    - **iOS**

    ```
    Xcode version: 12+
    iOS simulator/device version: 11+
    ```

    - **Android**

    ```
    Android SDK version: 21+
    ```

- **General Setup**

    1. [React Native](https://reactnative.dev/docs/environment-setup)

    2. For IDE tool, you can install [Visual Studio Code](https://code.visualstudio.com/download)

## **PaySDK Version**

Below information show the version of AsiaPay PaySDK.

```
iOS: 2.6.16
Android: 2.7.60
```

## **Installation**

- **React Native Setup**

    > Below installation steps are for the 1st time installation or any situation happen only.

    1. Run below command to mount to path of example app

        ```
        cd {project_root_path}
        ```

    2. Run below command to install all packages in `package.json` in root level 

        ```
        npm install
        ```

    3. Run below command to mount to path of example app

        ```
        cd {project_root_path}/example
        ```

    4. Run below command to install all packages in `package.json` in example app level 

        ```
        npm install
        ```
    
    5. Run below command to install rest of packages from yarn platform

        ```
        yarn add ../
        ```

    6. The info of React Native related softwares can be  shown running by the below command (Can add "--verbose" at the end of the command for details):

        ```
        react-native doctor
        ```

        Or

        ```
        react-native info
        ```
        
- **Update Merchant ID**

    Open `App.js` to update merchant id on the below code, :

    ```js
    React.useEffect(() => {
        simpleJsiModule.setup('SANDBOX', '{your_merchant_id}');
    }, []);
    ```

- **Update Public Key for PaySDK**

    - Android

        For further description kindly follow [PaySDK Guide on Android](https://github.com/asiapay-lib/paysdk-android-lib)

    - iOS

        For further description kindly follow [PaySDK Guide on iOS](https://github.com/asiapay-lib/paysdk-ios-lib)

### **Run Example App**

Before running example app, please make sure example path is mounted.

1. **Turn on React Native Metro Server**

    Run below command on command line console on Windows or terminal on MacOS.

    ```
    react-native start
    ```

    > If you want to clear cache from metro server, please run below command to turn on react native metro server:

    ```
    react-native start --reset-cache
    ```

    > If the current path is mounted on the example app level, you can run below command which is set script on `package.json` instead of the previous command

    ```
    npm run start
    ```

- **Android**

    Run below command on command line console on Windows or terminal on MacOS.

    ```
    react-native run-android
    ```

    > If the current path is mounted on the example app level, you can run below command which is set script on `package.json` instead of the previous command

    ```
    npm run android
    ```

- **iOS**


Remove below code for fbRecatNativeSpec

> Path - node_modules/react-native/scripts/find-node.sh

    if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    # shellcheck source=/dev/null
    . "$HOME/.nvm/nvm.sh" --no-use
    nvm use 2> /dev/null || nvm use default
    elif [[ -x "$(command -v brew)" && -s "$(brew --prefix nvm)/nvm.sh" ]]; then
    # shellcheck source=/dev/null
    . "$(brew --prefix nvm)/nvm.sh" --no-use
    nvm use 2> /dev/null || nvm use default
    fi

> Run below command on command line console on Windows or terminal on MacOS.

    ```
    react-native run-ios
    ```

> If the current path is mounted on the example app level, you can run below command which is set script on `package.json` instead of the previous command

    ```
    npm run ios
    ```

For detailed description kindly follow [AsiaPay](https://github.com/asiapay-lib)