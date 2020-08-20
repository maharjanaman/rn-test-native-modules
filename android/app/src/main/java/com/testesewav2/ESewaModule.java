package com.testesewav2;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;

import com.esewa.android.sdk.payment.ESewaConfiguration;
import com.esewa.android.sdk.payment.ESewaPayment;
import com.esewa.android.sdk.payment.ESewaPaymentActivity;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class ESewaModule extends ReactContextBaseJavaModule {
    private static ReactApplicationContext reactContext;

    private static final int REQUEST_CODE_PAYMENT = 1;
    private static final String E_ACTIVITY_DOES_NOT_EXIST = "E_ACTIVITY_DOES_NOT_EXIST";
    private static final String E_USER_CANCELLED = "E_USER_CANCELLED";
    private static final String E_RESULT_EXTRAS_INVALID = "E_RESULT_EXTRAS_INVALID";
    private static final String E_FAILED_TO_START_PAYMENT = "E_FAILED_TO_START_PAYMENT";

    private ESewaConfiguration eSewaConfiguration;
    private Promise mPromise;

    private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
            super.onActivityResult(activity, requestCode, resultCode, data);
            if(requestCode == REQUEST_CODE_PAYMENT) {
                if(mPromise != null) {
                    if(resultCode == activity.RESULT_OK) {
                        String message = data.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE);
                        mPromise.resolve(message);
                    } else if (resultCode == activity.RESULT_CANCELED) {
                        mPromise.reject(E_USER_CANCELLED, "Payment was cancelled by user");
                    } else if(resultCode == ESewaPayment.RESULT_EXTRAS_INVALID) {
                        if(data == null) return;
                        String message = data.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE);
                        mPromise.reject(E_RESULT_EXTRAS_INVALID, message);
                    }

                    mPromise = null;
                }
            }
        }
    };

    ESewaModule(ReactApplicationContext context) {
        super(context);
        reactContext = context;

        // Add the listener for `onActivityResult`
        reactContext.addActivityEventListener(mActivityEventListener);
    }

    @NonNull
    @Override
    public String getName() {
        return "ESewaModule";
    }

    @ReactMethod
    public void init(String clientId, String secretKey) {
        eSewaConfiguration = new ESewaConfiguration()
                .clientId(clientId)
                .secretKey(secretKey)
                .environment(ESewaConfiguration.ENVIRONMENT_TEST);
    }

    @ReactMethod
    public void pay(
            String productPrice,
            String productName,
            String productId,
            String callBackUrl,
            final Promise promise
    ) {
        Activity currentActivity = getCurrentActivity();

        if(currentActivity == null) {
            promise.reject(E_ACTIVITY_DOES_NOT_EXIST, "Activity doesn't exist");
            return;
        }

        // Store the promise to resolve/reject when eSewa returns data
        mPromise = promise;

        try {
            ESewaPayment eSewaPayment = new ESewaPayment(productPrice, productName, productId, callBackUrl);

            Intent eSewaIntent = new Intent(currentActivity, ESewaPaymentActivity.class);
            eSewaIntent.putExtra(ESewaConfiguration.ESEWA_CONFIGURATION, eSewaConfiguration);
            eSewaIntent.putExtra(ESewaPayment.ESEWA_PAYMENT, eSewaPayment);

            currentActivity.startActivityForResult(eSewaIntent, REQUEST_CODE_PAYMENT);
        } catch (Exception e) {
            mPromise.reject(E_FAILED_TO_START_PAYMENT, e);
            mPromise = null;
        }
    }
}
