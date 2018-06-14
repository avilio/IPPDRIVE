package com.example.ippdrive;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.MethodChannel;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "it.versionestabile.ippdrive/pdfViewer";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if (call.method.equals("viewPdf")) {
                  if (call.hasArgument("url")) {
                    String url = call.argument("url");
                    File file = new File(url);
                    //*
                    Uri photoURI = FileProvider.getUriForFile(MainActivity.this,
                            BuildConfig.APPLICATION_ID + ".provider",
                            file);
                    //*/
                    Intent target = new Intent(Intent.ACTION_VIEW);
                    target.setDataAndType(photoURI,"application/pdf");
                    target.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
                    target.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                    startActivity(target);
                    result.success(null);
                  }
                } else {
                  result.notImplemented();
                }
              }
            });
  }
}
