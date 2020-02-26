package id.co.fresto.fresto_apps;

import android.os.Bundle;

import com.midtrans.sdk.corekit.callback.TransactionFinishedCallback;
import com.midtrans.sdk.corekit.core.LocalDataHandler;
import com.midtrans.sdk.corekit.core.MidtransSDK;
import com.midtrans.sdk.corekit.core.TransactionRequest;
import com.midtrans.sdk.corekit.models.ItemDetails;
import com.midtrans.sdk.corekit.models.UserAddress;
import com.midtrans.sdk.corekit.models.UserDetail;
import com.midtrans.sdk.corekit.models.snap.TransactionResult;
import com.midtrans.sdk.uikit.SdkUIFlowBuilder;

import java.util.ArrayList;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements TransactionFinishedCallback {

  private String CHANNEL = "fresto/fresto_apps";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler((call, result) -> {
      if(call.method.equals("testInvoke")){
        result.success("-----Congrats Method Channel Invoked-----");
      }

      if(call.method.equals("charge")){
        SdkUIFlowBuilder.init()
                .setClientKey("SB-Mid-client-bfA7pEzaHB0V1GuA") // client_key is mandatory
                .setContext(MainActivity.this) // context is mandatory
                .setTransactionFinishedCallback(this)
                .setMerchantBaseUrl("https://midtrans-server.herokuapp.com/checkout.php/") //set merchant url (required) BASE_URL
                .enableLog(true) // enable sdk log (optional)
                .buildSDK();
        UserDetail userDetail = LocalDataHandler.readObject("user_details", UserDetail.class);
        if (userDetail == null) {
          userDetail = new UserDetail();
          userDetail.setUserFullName("mamamia");
          userDetail.setEmail("mama@mia.com");
          userDetail.setUserId("uid123456");

          ArrayList<UserAddress> userAddresses = new ArrayList<>();
          UserAddress userAddress = new UserAddress();
          userAddress.setAddress("Jalan Andalas Gang Sebelah No. 1");
          userAddress.setCity("Jakarta");
          userAddress.setAddressType(com.midtrans.sdk.corekit.core.Constants.ADDRESS_TYPE_BOTH);
          userAddress.setZipcode("12345");
          userAddress.setCountry("IDN");
          userAddresses.add(userAddress);
          userDetail.setUserAddresses(userAddresses);
          LocalDataHandler.saveObject("user_details", userDetail);
        }
        final double amount = 20000;
        final TransactionRequest transactionRequest = new TransactionRequest("transaction1234", amount);
        ItemDetails itemDetails = new ItemDetails("IDKU", amount, 1, "Kost");

        ArrayList<ItemDetails> itemDetailsList = new ArrayList<>();
        itemDetailsList.add(itemDetails);

        MidtransSDK.getInstance().setTransactionRequest(transactionRequest);
        MidtransSDK.getInstance().startPaymentUiFlow(MainActivity.this);
        result.success("MIDTRANS DONE!!!");
      }
    });
  }

  @Override
  public void onTransactionFinished(TransactionResult transactionResult) {

  }
}
