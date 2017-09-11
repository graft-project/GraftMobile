package com.vakoms.qt.graftwallet;

import android.content.Intent;
import android.os.Bundle;
import android.app.Activity;

public class SplashActivity extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Intent intent = new Intent(this, org.qtproject.qt5.android.bindings.QtActivity.class);
        startActivity(intent);
        finish();
    }
}
