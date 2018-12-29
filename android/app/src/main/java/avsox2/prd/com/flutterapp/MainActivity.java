package avsox2.prd.com.flutterapp;

import android.annotation.SuppressLint;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.webkit.MimeTypeMap;
import android.widget.TextView;
import android.widget.Toast;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {


    private static final String CHANNEL = "samples.flutter.io/sign";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);


        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (methodCall.method.equals("getsign")) {
                    final String ts = String.valueOf(System.currentTimeMillis() / 1000);
                    String vid = methodCall.argument("vid");
                    result.success(String.format("http://api.rekonquer.com/psvs/mp4.php?vid=%s&ts=%s&sign=%s", vid, ts, b(vid, ts)));
                    playVideoUse(String.format("http://api.rekonquer.com/psvs/mp4.php?vid=%s&ts=%s&sign=%s", vid, ts, b(vid, ts)));
                }else if(methodCall.method.equals("preview")){
                    String url = methodCall.argument("url");
                    playVideoUse(url);
                    result.success("");
                }
            }
        });

    }



    public void playVideoUse(String url){
//        String extension = MimeTypeMap.getFileExtensionFromUrl(url);
////        String mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
//        Intent mediaIntent = new Intent(Intent.ACTION_VIEW);
////        mediaIntent.setDataAndType(Uri.parse(url), "video/*");
//        mediaIntent.putExtra("url",url);
//        startActivity(mediaIntent);

        Intent intent = new Intent();
        intent.addCategory(Intent.CATEGORY_DEFAULT);
        ComponentName cn = new ComponentName("wq.video.com.videolook", "wq.video.com.videolook.ui.avlist.detail.OtherMoveActivity");
        intent.putExtra("url", url);
        intent.setComponent(cn);
        if (isIntentAvailable(this,intent)){
            try {
                startActivity(intent);
            }catch (Exception e){
                e.printStackTrace();
            }
        }else {
            Toast.makeText(this,"没找到",Toast.LENGTH_LONG).show();
        }
    }


    public static boolean isIntentAvailable(Context context, Intent intent) {
        final PackageManager packageManager = context.getPackageManager();
        @SuppressLint("WrongConstant") List<ResolveInfo> list = packageManager.queryIntentActivities(intent,
                PackageManager.GET_ACTIVITIES);
        return list.size() > 0;

    }

    public static String b(String s1, String s2) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(String.format("%s%sBrynhildr", s1, s2).getBytes());
            return bytesToHex(bytes);
        } catch (NoSuchAlgorithmException e) {
            return null;
        }
    }

    public static String bytesToHex(byte[] bytes) {
        final char[] hexArray = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
        char[] hexChars = new char[bytes.length * 2];
        int v;
        for (int j = 0; j < bytes.length; j++) {
            v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }

}
