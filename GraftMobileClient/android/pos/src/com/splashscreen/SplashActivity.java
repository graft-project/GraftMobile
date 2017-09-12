package com.vakoms.qt.graftpos;

import com.vakoms.qt.graftpos.R;
import android.content.Intent;
import android.os.Bundle;
import android.app.Activity;
import android.widget.LinearLayout;

import android.widget.ImageView;
import android.view.ViewGroup;
import android.graphics.drawable.Drawable;
//import android.R;

public class SplashActivity extends Activity {


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

		LinearLayout linLayout = new LinearLayout(this);
		linLayout.setOrientation(linLayout.VERTICAL);
		ViewGroup.LayoutParams linLayoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
		setContentView(linLayout, linLayoutParams);
		
		ViewGroup.LayoutParams lpView = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
		
		Drawable drawable = getResources().getDrawable(R.drawable.logo);
		
		ImageView imageObj = new ImageView(this);
		imageObj.setImageDrawable(drawable);
        System.out.println("!!!!!!!!!!!!!!!!!!!!");
        System.out.println("!!!!!!!!!!!!!!!!!!!!");
        System.out.println("!!!!!!!!!!!!!!!!!!!!");
        System.out.println(imageObj);
		imageObj.setLayoutParams(lpView);
		linLayout.addView(imageObj);
			
        Intent intent = new Intent(this, org.qtproject.qt5.android.bindings.QtActivity.class);
        startActivity(intent);
        finish();
    } 
}
