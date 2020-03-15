package id.co.fresto.fresto_apps;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import com.midtrans.sdk.corekit.callback.TransactionFinishedCallback;
import com.midtrans.sdk.corekit.core.LocalDataHandler;
import com.midtrans.sdk.corekit.core.MidtransSDK;
import com.midtrans.sdk.corekit.core.TransactionRequest;
import com.midtrans.sdk.corekit.core.UIKitCustomSetting;
import com.midtrans.sdk.corekit.models.CustomerDetails;
import com.midtrans.sdk.corekit.models.ItemDetails;
import com.midtrans.sdk.corekit.models.UserAddress;
import com.midtrans.sdk.corekit.models.UserDetail;
import com.midtrans.sdk.corekit.models.snap.MerchantData;
import com.midtrans.sdk.corekit.models.snap.TransactionResult;
import com.midtrans.sdk.uikit.SdkUIFlowBuilder;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements TransactionFinishedCallback {

  private String CHANNEL = "fresto/fresto_apps";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler((call, result) -> {
      if(call.method.equals("init")) setSdkUIFlow(call, result);
      else if(call.method.equals("makePayment")){
        payNow(call,result, MainActivity.this);
      }else{
        result.notImplemented();
      }
    });
  }

  private void payNow(MethodCall methodCall, MethodChannel.Result result, Context context){
    try {
      String clientString = (String) methodCall.argument("clientStr");
      String orderString = (String) methodCall.argument("orderStr");

      Log.d(CHANNEL, "payNow: " + clientString);
      Log.d(CHANNEL, "payNow: " + orderString);

      // Validation
      if(clientString == null) throw new NullPointerException("clientStr is null");
      if(orderString == null) throw new NullPointerException("orderStr is null");

      JSONObject clientJson = new JSONObject(clientString);
      JSONObject orderJson = new JSONObject(orderString);

      TransactionRequest transactionRequest = new TransactionRequest(
              orderJson.getString("uid"),
              orderJson.getDouble("total")
      );
      // Menus
      ArrayList<ItemDetails> itemDetails = new ArrayList<>();
      JSONArray menusJson = orderJson.getJSONArray("menus");
      for(int i = 0; i < menusJson.length(); i++){
        JSONObject tempObj = menusJson.getJSONObject(i);
        ItemDetails item = new ItemDetails();
        item.setName(tempObj.getString("name"));
        item.setPrice(tempObj.getDouble("price"));
        item.setQuantity(tempObj.getInt("quantity"));
        itemDetails.add(item);
      }

      double tax = orderJson.getDouble("total") / 11;
      ItemDetails taxItem = new ItemDetails();
      taxItem.setName("Tax");
      taxItem.setPrice(tax);
      taxItem.setQuantity(1);
      itemDetails.add(taxItem);

      // Customer
      CustomerDetails customerDetails = new CustomerDetails();
      customerDetails.setEmail(clientJson.getString("email"));
      customerDetails.setFirstName(clientJson.getString("fullName"));
      customerDetails.setPhone(clientJson.getString("phoneNumber"));

      transactionRequest.setCustomerDetails(customerDetails);
      transactionRequest.setItemDetails(itemDetails);

      UIKitCustomSetting setting = MidtransSDK.getInstance().getUIKitCustomSetting();

      MidtransSDK.getInstance().setUIKitCustomSetting(setting);
      MidtransSDK.getInstance().setTransactionRequest(transactionRequest);
      MidtransSDK.getInstance().startPaymentUiFlow(context);
      result.success("Payment Invoked");
    }catch (Exception e){
      Log.d(CHANNEL, "payNow: " + e.getMessage());
      result.success(e.getMessage());
    }
  }

  private void setSdkUIFlow(MethodCall call, MethodChannel.Result result){
    SdkUIFlowBuilder.init()
            .setClientKey((String) call.argument("client_api_key")) // client_key is mandatory
            .setContext(MainActivity.this) // context is mandatory
            .setTransactionFinishedCallback(this)
            .setMerchantBaseUrl((String) call.argument("check_out_url")) //set merchant url (required) BASE_URL
            .enableLog(true) // enable sdk log (optional)
            .buildSDK();
    result.success("Successfully Initialized SDKUIFlowBuilder");
  }

  @Override
  public void onTransactionFinished(TransactionResult transactionResult) {
    Map<String, Object> content = new HashMap<>();
    content.put("transactionCanceled", transactionResult.isTransactionCanceled());
    content.put("status", transactionResult.getStatus());
    content.put("source", transactionResult.getSource());
    content.put("statusMessage", transactionResult.getStatusMessage());
    if(transactionResult.getResponse() != null)
      content.put("response", transactionResult.getResponse().toString());
    else
      content.put("response", null);
    Log.d(CHANNEL, "onTransactionFinished: " + content.toString());
    new MethodChannel(getFlutterView(), CHANNEL).invokeMethod("onTransactionFinished", content);
  }
}
