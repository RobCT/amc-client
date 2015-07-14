//
// IntentView.java
//
package org.qtproject.example.testapi;

import android.app.Activity;
import java.lang.Runnable;
import android.content.Intent;
import java.io.File;
import android.net.Uri;



public class IntentView extends org.qtproject.qt5.android.bindings.QtActivity
{

public static IntentView m_instance;

public IntentView()
{
m_instance = this;
}

public static void openUrl(final String m_url, final String m_application_type)
{
    m_instance.runOnUiThread(new Runnable() {
    public void run() {

	 Intent intent = new Intent();
	 intent.setAction(android.content.Intent.ACTION_VIEW);
	 //File file = new File(m_url);
	 intent.setDataAndType(Uri.parse(m_url), m_application_type);

	    m_instance.startActivity(intent);


     }
   });

}

}


