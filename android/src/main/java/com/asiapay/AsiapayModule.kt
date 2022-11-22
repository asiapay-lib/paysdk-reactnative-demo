package com.asiapay
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.widget.Toast
import androidx.annotation.RequiresApi
import com.asiapay.sdk.PaySDK
import com.asiapay.sdk.integration.*
import com.asiapay.sdk.integration.googlepay.GooglePay
import com.asiapay.sdk.integration.googlepay.PaymentsUtil
import com.asiapay.sdk.integration.xecure3ds.spec.Factory
import com.facebook.react.bridge.*
import com.google.android.gms.wallet.AutoResolveHelper
import com.google.android.gms.wallet.PaymentDataRequest
import com.google.android.gms.wallet.PaymentsClient
import com.google.gson.Gson
import com.tencent.mm.opensdk.utils.Log
import com.unionpay.UPPayAssistEx
import java.text.SimpleDateFormat
import java.util.*

class AsiapayModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  private var paySDK: PaySDK = PaySDK(reactContext)
//  private var merchantId: String? = null
  private var environment: EnvBase.EnvType = EnvBase.EnvType.SANDBOX
  private lateinit var mPaymentsClient: PaymentsClient

  private var payRef: String? = null
  private var orderRefOctopus: String? = null

  override fun getName(): String {
        return "Asiapay"
    }

  @ReactMethod
  fun setup(envType: String, mId: String) {
    val receivedEnvType: String = envType.toUpperCase()

//    merchantId = mId
    if (envType == "Production") {
      environment = EnvBase.EnvType.PRODUCTION
    }

//    //GooglePay
    mPaymentsClient = PaymentsUtil.createPaymentsClient(currentActivity, environment)

    Log.d("Package Name", reactApplicationContext.packageName)
    Log.d("Package Name", "")

//    PaymentsUtil.isGooglePayAvailable(this, mPaymentsClient, object : ICheckGooglePay {
//      override fun success() {
//
//        //Visible GooglePay Button here
//      }
//
//      override fun error() {}
//    })
  }

//  @ReactMethod
//  fun alipay(amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise) {
//    makePayment("ALIPAYHKAPP", amount, currency, orderRef, remark, promise, null)
//  }

  @ReactMethod
  fun alipayHK(merchantId: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise) {
    makePayment(merchantId,"ALIPAYHKAPP", amount, currency, orderRef, remark, promise, null)
  }

  @ReactMethod
  fun alipayGlobal(merchantId: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise) {
    makePayment(merchantId,"ALIPAYAPP", amount, currency, orderRef, remark, promise, null)
  }

  @ReactMethod
  fun octopus(merchantId: String?, amount: String?, orderRef: String?, remark: String?, promise: Promise) {
    octopusPayment(merchantId,"OCTOPUS", amount, "HKD", orderRef, remark, promise, null)
  }

  @ReactMethod
  fun wechat(merchantId: String?, amount: String?, orderRef: String?, remark: String?, promise: Promise) {
    makePayment(merchantId,"WECHATAPP", amount, "HKD", orderRef, "additional remark", promise, null)
  }

  @ReactMethod
  fun creditCard(merchantId: String?, amount: String, currency: String, method: String, orderRef: String, remark: String, cardDetails: ReadableMap, extraData: ReadableMap, payType: String, promise: Promise) {
    val cd = cardDetails.toHashMap()
    val card = CardDetails()
    card.cardNo = cd["cardNo"] as String
    card.epMonth = cd["month"] as String
    card.epYear = cd["year"] as String
    card.securityCode = cd["cvc"] as String
    card.cardHolder = cd["cardHolder"] as String

    makePayment(merchantId, method, amount, currency, orderRef, remark, promise, card, payType, toHashMapString(extraData))
  }

  @ReactMethod
  fun unionpay(merchantId: String?, amount: String?, orderRef: String?, remark: String?, promise: Promise) {
    unionPayment(merchantId,"UPOP", amount, "HKD", orderRef, remark, promise, null)
  }

  @ReactMethod
  fun samsungpay(merchantId: String?, amount: String?, orderRef: String?, remark: String?, promise: Promise) {
    paymentSamsung(merchantId,"SAMSUNG", amount, "HKD", orderRef, remark, promise, null)
  }

  @ReactMethod
  fun payme(merchantId: String?, amount: String?, orderRef: String?, remark: String?, promise: Promise) {
    paymePayment(merchantId,"PayMe", amount, "HKD", orderRef, remark, promise, null)
  }

  @ReactMethod
  fun fps(merchantId: String?, amount: String?, orderRef: String?, remark: String?, promise: Promise) {
    paymentFps(merchantId,"FPS", amount, "HKD", orderRef, remark, promise, null)
  }

  @ReactMethod
  fun hostedcall(merchantId: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise) {
    hostedcallPayment(merchantId,"ALL", amount, currency, orderRef, remark, promise, null)
  }

  @RequiresApi(Build.VERSION_CODES.N)
  @ReactMethod
  fun googlepay(merchantId: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise) {
    googlePayment(merchantId,"GOOGLE", amount, currency, orderRef, remark, promise, null)
  }

  private fun makePayment(merchantId: String?, method: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise, cardDetails: CardDetails?, payType: String = "N", extraData: HashMap<String, String> = hashMapOf()) {
    val payData = PayData()
    payData.envType = environment
    payData.channel = EnvBase.PayChannel.DIRECT
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.valueOf(currency))
    payData.setPayType(if (payType == "N") EnvBase.PayType.NORMAL_PAYMENT else EnvBase.PayType.HOLD_PAYMENT)
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.amount = amount
    payData.payMethod = method
    payData.merchantId = merchantId!!
    payData.orderRef = orderRef
    payData.remark = remark
    payData.activity = currentActivity
    payData.extraData = extraData

    if (cardDetails != null) {
      payData.cardDetails = cardDetails
    }
    paySDK.requestData = payData
    paySDK.process()
    paySDK.responseHandler(object : PaymentResponse() {
      override fun getResponse(payResult: PayResult) {
//        if (payResult.successCode == "0") {
//          val gson = Gson()
//          promise.resolve(gson.toJson(payResult))
//          Toast.makeText(getCurrentActivity(), payResult.getErrMsg() + "", Toast.LENGTH_SHORT).show()
//        } else {
//          promise.reject("${payResult.prc}:${payResult.src}", payResult.errMsg)
//          Toast.makeText(getCurrentActivity(), payResult.getErrMsg() + "", Toast.LENGTH_SHORT).show()
//        }

//        val gson = Gson()
//        val str = gson.toJson(payResult)
//        Toast.makeText(currentActivity, payResult.errMsg + "", Toast.LENGTH_SHORT).show()

        if (payResult.isSuccess) {
          Toast.makeText(currentActivity, payResult.successMsg, Toast.LENGTH_SHORT).show()
        } else {
          Toast.makeText(currentActivity, payResult.errMsg, Toast.LENGTH_SHORT).show()
        }
      }

      override fun onError(data: Data) {
        promise.reject("payment error", data.message + data.error)
      }
    })
  }

  private fun octopusPayment(merchantId: String?, method: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise, cardDetails: CardDetails?, payType: String = "N", extraData: HashMap<String, String> = hashMapOf()) {
    val payData = PayData()
    payData.envType = environment
    payData.channel = EnvBase.PayChannel.DIRECT
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.valueOf(currency))
    payData.setPayType(if (payType == "N") EnvBase.PayType.NORMAL_PAYMENT else EnvBase.PayType.HOLD_PAYMENT)
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.amount = amount
    payData.payMethod = method
    payData.merchantId = merchantId!!
    payData.orderRef = orderRef
    payData.remark = remark
    payData.activity = currentActivity
    payData.extraData = extraData

    if (cardDetails != null) {
      payData.cardDetails = cardDetails
    }
    paySDK.requestData = payData
    paySDK.process()
    paySDK.responseHandler(object : PaymentResponse() {
      override fun getResponse(payResult: PayResult) {
        try {

          // String octopusuri = payResult.getErrMsg();
          val intent = Intent(Intent.ACTION_VIEW, Uri.parse(payResult.errMsg))
          orderRefOctopus = payResult.ref
          payRef = payResult.payRef
//          startActivityForResult(intent, AuthActivity.OCTOPUS_APP_REQUEST_CODE)
          reactApplicationContext.startActivityForResult(intent,1,null)


        } catch (e: java.lang.Exception) {
          Toast.makeText(currentActivity, e.message + "  Exp", Toast.LENGTH_SHORT).show()
        }
      }

      override fun onError(data: Data) {
        promise.reject("payment error", data.message + data.error)
      }
    })
  }

  private fun unionPayment(merchantId: String?, method: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise, cardDetails: CardDetails?, payType: String = "N", extraData: HashMap<String, String> = hashMapOf()) {
    val payData = PayData()
    payData.envType = environment
    payData.channel = EnvBase.PayChannel.DIRECT
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.valueOf(currency))
    payData.setPayType(if (payType == "N") EnvBase.PayType.NORMAL_PAYMENT else EnvBase.PayType.HOLD_PAYMENT)
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.amount = amount
    payData.payMethod = method
    payData.merchantId = merchantId!!
    payData.orderRef = orderRef
    payData.remark = remark
    payData.activity = currentActivity
    payData.extraData = extraData

    if (cardDetails != null) {
      payData.cardDetails = cardDetails
    }
    paySDK.requestData = payData
    paySDK.process()
    paySDK.responseHandler(object : PaymentResponse() {
      override fun getResponse(payResult: PayResult) {
        try {
          UPPayAssistEx.startPay(currentActivity, null, null, payResult.errMsg, "01")
          //Toast.makeText(AuthActivity.this, payResult.getErrMsg(), Toast.LENGTH_SHORT).show();
        } catch (e: Exception) {
          e.message
        }
      }

      override fun onError(data: Data) {
        promise.reject("payment error", data.message + data.error)
      }
    })
  }

  private fun paymentFps(merchantId: String?, method: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise, cardDetails: CardDetails?, payType: String = "N", extraData: HashMap<String, String> = hashMapOf()) {
    val payData = PayData()
    payData.envType = environment
    payData.channel = EnvBase.PayChannel.DIRECT
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.valueOf(currency))
    payData.setPayType(if (payType == "N") EnvBase.PayType.NORMAL_PAYMENT else EnvBase.PayType.HOLD_PAYMENT)
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.amount = amount
    payData.payMethod = method
    payData.merchantId = merchantId!!
    payData.orderRef = "8163601"
    payData.remark = " "
//    payData.activity = currentActivity

//    if (cardDetails != null) {
//      payData.cardDetails = cardDetails
//    }

    val extraDataFps: MutableMap<String?, String?> = java.util.HashMap()
    extraDataFps["fpsqueryurl"] = "https://fps.paydollar.com/api/fpsQrUrl?encrypted="
    payData.extraData = extraDataFps

    paySDK.requestData = payData
    paySDK.process()
    paySDK.responseHandler(object : PaymentResponse() {
      override fun getResponse(payResult: PayResult) {
        val encryptedURL = paySDK.aesEncryption(payResult.ref, payResult.payRef)
        val intent = Intent(PaySDK.FPS_ACTION)
        intent.putExtra("url", encryptedURL)

        if (intent.resolveActivity(reactApplicationContext.getPackageManager()) != null) {
          reactApplicationContext.startActivityForResult(Intent.createChooser(intent, "Select App"),1,null)
        }
      }

      override fun onError(data: Data) {
          Toast.makeText(currentActivity,data.message, Toast.LENGTH_SHORT).show()
      }
    })
  }

  private fun paymentSamsung(merchantId: String?, method: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise, cardDetails: CardDetails?, payType: String = "N", extraData: HashMap<String, String> = hashMapOf()) {
    val payData = PayData()
    payData.envType = environment
    payData.channel = EnvBase.PayChannel.DIRECT
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.valueOf(currency))
    payData.setPayType(if (payType == "N") EnvBase.PayType.NORMAL_PAYMENT else EnvBase.PayType.HOLD_PAYMENT)
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.amount = amount
    payData.payMethod = method
    payData.merchantId = merchantId!!
    payData.orderRef = orderRef
    payData.activity = currentActivity

//    if (cardDetails != null) {
//      payData.cardDetails = cardDetails
//    }

    val brands = java.util.ArrayList<EnvBase.Brand>()

    brands.add(EnvBase.Brand.VISA)
    brands.add(EnvBase.Brand.MASTERCARD)
    brands.add(EnvBase.Brand.AMERICANEXPRESS)
    Log.e("Brands", brands.toString())

    payData.appName = "AsiaPay Production Demo" //the app name which you have mentioned while creating the service id on samsung portal
    payData.brands = brands
    payData.serviceId = "a2e7128c33c340b2a3ecec"
    payData.merchantId = merchantId!!

    var addressData = AddressData()
    addressData.firstname = "Victor"
    addressData.lastname = "Yu"
    addressData.addressLine1 = "Java Road"
    addressData.addressLine2 = "Struts2"
    addressData.city = "Sun"
    addressData.state = "State"
    addressData.countryCode = "HKG" //COUNTRY CODES ALPHA-3

    addressData.postalCode = "421301"
    addressData.phoneNumber = "7087654323"
    addressData.email = "arjun.nishad.apin@gmail.com"

    payData.addressData = addressData

    payData.remark = " "

    val extraDataS: Map<String?, String?> = java.util.HashMap()
    payData.extraData = extraDataS

    paySDK.requestData = payData

    paySDK.process()

    paySDK.responseHandler(object : PaymentResponse() {
      override fun getResponse(payResult: PayResult) {
        Toast.makeText(currentActivity, "Result: " + payResult.errMsg + "", Toast.LENGTH_SHORT).show()
      }

      override fun onError(data: Data) {
        promise.reject("payment error", data.message + data.error)
      }
    })

  }

  private fun paymePayment(merchantId: String?, method: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise, cardDetails: CardDetails?, payType: String = "N", extraData: HashMap<String, String> = hashMapOf()) {
    val payData = PayData()
    payData.envType = environment
    payData.channel = EnvBase.PayChannel.DIRECT
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.valueOf(currency))
    payData.setPayType(if (payType == "N") EnvBase.PayType.NORMAL_PAYMENT else EnvBase.PayType.HOLD_PAYMENT)
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.amount = amount
    payData.payMethod = method
    payData.merchantId = merchantId!!
    payData.orderRef = orderRef
    payData.remark = " "
    payData.activity = currentActivity

    payData.setSuccessUrl("mcd://www.apin.com/succ")
    payData.setCancelUrl("mcd://www.apin.com/cancel")
    payData.setFailUrl("mcd://www.apin.com/fail")
    payData.setErrorUrl("mcd://www.apin.com/fail")

    if (cardDetails != null) {
      payData.cardDetails = cardDetails
    }

    // Optional Parameter (For Value-Added Service)
    val extraDatap: Map<String?, String?> = java.util.HashMap()
    payData.extraData = extraDatap

    paySDK.requestData = payData
    paySDK.process()

    paySDK.responseHandler(object : PaymentResponse() {
      override fun getResponse(payResult: PayResult) {
        if (payResult.successCode == "0") {
          val gson = Gson()
          promise.resolve(gson.toJson(payResult))
          android.util.Log.d("paymeData", "Succ: " + payResult.orderId + " err " + payResult.payRef
          )
          Toast.makeText(getCurrentActivity(), payResult.getErrMsg() + "", Toast.LENGTH_SHORT).show()
        } else {
          promise.reject("${payResult.prc}:${payResult.src}", payResult.errMsg)
          Toast.makeText(getCurrentActivity(), payResult.getErrMsg() + "", Toast.LENGTH_SHORT).show()
        }
      }

      override fun onError(data: Data) {
        promise.reject("payment error", data.message + data.error)
      }
    })

  }

  private fun hostedcallPayment(merchantId: String?, method: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise, cardDetails: CardDetails?, payType: String = "N", extraData: HashMap<String, String> = hashMapOf()) {
    val payData = PayData()
    payData.channel = EnvBase.PayChannel.WEBVIEW
    payData.envType = environment
    payData.amount = amount
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.valueOf(currency))
    payData.setPayType(if (payType == "N") EnvBase.PayType.NORMAL_PAYMENT else EnvBase.PayType.HOLD_PAYMENT)
    payData.orderRef = orderRef
    payData.payMethod = method
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.merchantId = merchantId!!
    payData.resultPage = "T"


//    payData.activity = currentActivity

//    payData.extraData = extraData

//    if (cardDetails != null) {
//      payData.cardDetails = cardDetails
//    }

    paySDK.requestData = payData

    payData.remark = remark
    payData.setShowCloseButton(true)
    payData.setShowToolbar(true)
    payData.setWebViewClosePrompt("Do you really want to close this page ?")


    // Optional Parameter (For Value-Added Service)
    val extraDataHosted: MutableMap<String, String> = java.util.HashMap()
    extraDataHosted["deeplink"] = "3"
    extraDataHosted["redirect"] = "30"
    payData.extraData = extraDataHosted


    //Log.d("Request Data ", "PayData: " + payData);
    val factory: Factory = com.asiapay.sdk.integration.xecure3ds.Factory()
    val configParameters = factory.newConfigParameters()
    val uiCustomization = factory.newUiCustomization()

    val toolbarCustomization = factory.newToolbarCustomization()
    if (toolbarCustomization != null) {
      toolbarCustomization.headerText = "Payment Page"
      toolbarCustomization.backgroundColor = "#ff8000"
      toolbarCustomization.textColor = "#ffffff"
      toolbarCustomization.buttonText = "Close"
      toolbarCustomization.textFontName = "pacifico.ttf"
      uiCustomization.toolbarCustomization = toolbarCustomization
    }

    payData.configParameters = configParameters
    payData.uiCustomization = uiCustomization
    payData.activity = currentActivity
    paySDK.requestData = payData

    if (paySDK.isPaySDKInitialized()) {
      paySDK.process()
    } else {
      Toast.makeText(currentActivity, paySDK.getPaySDKInitializationError().getError().toString() + " ", Toast.LENGTH_SHORT).show()
    }


    paySDK.responseHandler(object : PaymentResponse() {
      override fun getResponse(payResult: PayResult) {
        if (payResult.errMsg.startsWith("No app installed to handle the request")) {
          Toast.makeText(currentActivity, payResult.errMsg, Toast.LENGTH_SHORT).show()
        } else if (payResult.errMsg == "Transaction page closed by user") {
          Toast.makeText(currentActivity, payResult.errMsg, Toast.LENGTH_SHORT).show()
        } else {
          Toast.makeText(currentActivity, payResult.isSuccess.toString(), Toast.LENGTH_SHORT).show()
        }
      }

      override fun onError(data: Data) {
        promise.reject("payment error", data.message + data.error)
      }
    })
  }

  @RequiresApi(Build.VERSION_CODES.N)
  private fun googlePayment(merchantId: String?, method: String?, amount: String?, currency: String, orderRef: String?, remark: String?, promise: Promise, cardDetails: CardDetails?, payType: String = "N", extraData: HashMap<String, String> = hashMapOf()) {
    val payData = PayData()
    payData.channel = EnvBase.PayChannel.DIRECT
    payData.envType = EnvBase.EnvType.PRODUCTION
    payData.setGooglePayAuth(EnvBase.GooglePayAuth.PAN_CRYPTO) // network capabilities
    payData.amount = amount
    payData.setPayGate(EnvBase.PayGate.PAYDOLLAR)
    payData.setCurrCode(EnvBase.Currency.valueOf(currency))
    payData.setPayType(if (payType == "N") EnvBase.PayType.NORMAL_PAYMENT else EnvBase.PayType.HOLD_PAYMENT)
    payData.orderRef = orderRef
    payData.payMethod = method
    payData.setLang(EnvBase.Language.ENGLISH)
    payData.merchantId = merchantId!!
    //payData.setMerchantId("88624034");
    payData.merchantName = "Abc"

    payData.setRemark(" ")

    val brands: ArrayList<EnvBase.GPayBrand> = ArrayList<EnvBase.GPayBrand>()
    brands.add(EnvBase.GPayBrand.VISA)
    brands.add(EnvBase.GPayBrand.MASTERCARD)
    brands.add(EnvBase.GPayBrand.AMERICANEXPRESS)
    payData.setGpayBrands(brands)

    val paymentDataRequestJson = GooglePay.getPaymentDataRequest(payData)
    if (!paymentDataRequestJson.isPresent) {
      return
    }
    val request: PaymentDataRequest =
      PaymentDataRequest.fromJson(paymentDataRequestJson.get().toString())
    //Optional<JSONObject> paymentDataRequestJson = GooglePay.getPaymentDataRequest("Webviewfgf");

    if (request != null) {
      currentActivity?.let {
        AutoResolveHelper.resolveTask(
          mPaymentsClient.loadPaymentData(request), it, PaySDK.LOAD_PAYMENT_DATA_REQUEST_CODE
        )
      }
    }
  }

  fun getOrderRef(): String? {
    val s = SimpleDateFormat("ddMMyyyyhhmmss")
    return s.format(Date())
  }

  fun toHashMap(map: ReadableMap?): HashMap<String, Any?>? {
    val hashMap: HashMap<String, Any?> = HashMap()
    val iterator = map!!.keySetIterator()
    while (iterator.hasNextKey()) {
      val key = iterator.nextKey()
      when (map.getType(key)) {
        ReadableType.Null -> hashMap[key] = null
        ReadableType.Boolean -> hashMap[key] = map.getBoolean(key).toString()
        ReadableType.Number -> hashMap[key] = map.getDouble(key)
        ReadableType.String -> hashMap[key] = map.getString(key)
        ReadableType.Map -> hashMap[key] = toHashMap(map.getMap(key))
        ReadableType.Array -> hashMap[key] = toArrayList(map.getArray(key))
        else -> throw IllegalArgumentException("Could not convert object with key: $key.")
      }
    }
    return hashMap
  }

  fun toHashMapString(map: ReadableMap?): HashMap<String, String> {
    val hashMap: HashMap<String, String> = HashMap()
    val iterator = map!!.keySetIterator()
    while (iterator.hasNextKey()) {
      val key = iterator.nextKey()
      when (map.getType(key)) {
        ReadableType.Null -> hashMap[key] = ""
        ReadableType.Boolean -> hashMap[key] = map.getBoolean(key).toString()
        ReadableType.Number -> hashMap[key] = map.getDouble(key).toString()
        ReadableType.String -> hashMap[key] = map.getString(key)!!
        else -> throw IllegalArgumentException("Could not convert object with key: $key.")
      }
    }
    return hashMap
  }

  fun toArrayList(array: ReadableArray?): ArrayList<Any?>? {
    val arrayList: ArrayList<Any?> = ArrayList(array!!.size())
    var i = 0
    val size = array!!.size()
    while (i < size) {
      when (array.getType(i)) {
        ReadableType.Null -> arrayList.add(null)
        ReadableType.Boolean -> arrayList.add(array.getBoolean(i))
        ReadableType.Number -> arrayList.add(array.getDouble(i))
        ReadableType.String -> arrayList.add(array.getString(i))
        ReadableType.Map -> arrayList.add(toHashMap(array.getMap(i)))
        ReadableType.Array -> arrayList.add(toArrayList(array.getArray(i)))
        else -> throw java.lang.IllegalArgumentException("Could not convert object at index: $i.")
      }
      i++
    }
    return arrayList
  }
}
