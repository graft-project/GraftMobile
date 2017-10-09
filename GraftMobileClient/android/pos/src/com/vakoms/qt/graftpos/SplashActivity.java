package com.vakoms.qt.graftpos;

import android.content.Intent;
import android.os.Bundle;
import android.app.Activity;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Build;
import android.view.View;

public class SplashActivity extends Activity {

    private static final int SPLASH_TIME = 3000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            getWindow().getDecorView().setSystemUiVisibility(
//                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE
//                            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
//                            getWindow().setStatusBarColor(Color.TRANSPARENT);
//            }

    setContentView(R.drawable.image);

    new BackgroundTask().execute();
    }

    private class BackgroundTask extends AsyncTask {
    Intent intent;

        @Override
        protected void onPreExecute()
        {
            super.onPreExecute();
            intent = new Intent(SplashActivity.this, org.qtproject.qt5.android.bindings.QtActivity.class);
        }

        @Override
        protected Object doInBackground(Object[] params)
        {
            try
            {
                Thread.sleep(SPLASH_TIME);
            }
            catch (InterruptedException e)
            {
                e.printStackTrace();
            }
            return null;
        }
-
        @Override
        protected void onPostExecute(Object o)
        {
        super.onPostExecute(o);
        startActivity(intent);
        finish();
        }
    }
}
