package solutions.specter.specter_mobile

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

import java.util.logging.Logger
import org.json.JSONObject;
import android.util.Log;

import specter_mobile_java.CryptoService

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "specter.mobile/service"

    companion object {
        val LOG = Logger.getLogger(MainActivity::class.java.name)
        val cryptoService = CryptoService()
    }

    @Override
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL);
        channel.setMethodCallHandler {call, result ->
            if (call.method == "HmacSHA256Sign") {
                var keyName: String? = call.argument("keyName");
                var toSign: String? = call.argument("toSign");

                var ret: JSONObject = cryptoService.HmacSHA256Sign(keyName!!, toSign!!);
                result.success(ret.toString());
            }
        }
    }
}
