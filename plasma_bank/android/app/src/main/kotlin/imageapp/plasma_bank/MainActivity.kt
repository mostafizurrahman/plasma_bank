package imageapp.plasma_bank

<<<<<<< HEAD
import android.os.Build
import android.os.Bundle
import android.view.View
import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat
=======
import android.annotation.SuppressLint
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.text.TextUtils
import androidx.annotation.NonNull
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.net.NetworkInterface

class MainActivity: FlutterActivity() {

    companion object {
        const val DEVICE_INFO_CHANNEL = "flutter.plasma.com.device_info"

    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

    }

    @SuppressLint("HardwareIds")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val _binExe = flutterEngine?.dartExecutor?.binaryMessenger
        MethodChannel(_binExe,
                DEVICE_INFO_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getPackageInfo") {
                val packageName = context.packageName
                val deviceName = this.getDeviceName()
                val androidID: String = Settings.Secure.getString(context.contentResolver,
                        Settings.Secure.ANDROID_ID)
                val hardwareID = this.generateIdHardwareAddress()
                val deviceMap = HashMap<String, String>()
                deviceMap["package_name"] = packageName
                deviceMap["device_id"] = if (androidID.isEmpty() ) hardwareID  else  androidID
                deviceMap["device_name"] = deviceName
                result.success(deviceMap)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun generateIdHardwareAddress(): String {
        try {
            val list = NetworkInterface.getNetworkInterfaces()
            while (list.hasMoreElements()) {
                val nextInterface = list.nextElement();

                if (!nextInterface.isLoopback &&
                        !nextInterface.isVirtual &&
                        nextInterface.hardwareAddress != null) {

                    var interfaceName = nextInterface.displayName
                    if (interfaceName == null) {
                        interfaceName = nextInterface.name
                    }
                    if (interfaceName != null) {
                        val macAddress = String.format("%x%x%x%x%x%x",
                                nextInterface.getHardwareAddress()[0],
                                nextInterface.getHardwareAddress()[1],
                                nextInterface.getHardwareAddress()[2],
                                nextInterface.getHardwareAddress()[3],
                                nextInterface.getHardwareAddress()[4],
                                nextInterface.getHardwareAddress()[5])
                        return macAddress;
                    }
                }
            }
        } catch (ex: java.lang.Exception) {
        }
        return "";
    }

    /** Returns the consumer friendly device name  */
    fun getDeviceName(): String {
        val manufacturer: String = Build.MANUFACTURER
        val model: String = Build.MODEL
        return if (model.startsWith(manufacturer)) {
            capitalize(model)
        } else capitalize(manufacturer) + " " + model
    }

    private fun capitalize(str: String): String {
        if (TextUtils.isEmpty(str)) {
            return str
        }
        val arr = str.toCharArray()
        var capitalizeNext = true
        val phrase = StringBuilder()
        for (c in arr) {
            if (capitalizeNext && Character.isLetter(c)) {
                phrase.append(Character.toUpperCase(c))
                capitalizeNext = false
                continue
            } else if (Character.isWhitespace(c)) {
                capitalizeNext = true
            }
            phrase.append(c)
        }
        return phrase.toString()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }
}
