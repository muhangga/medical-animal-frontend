
import 'package:device_info_plus/device_info_plus.dart';

class DeviceName {
  Future getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
    return androidInfo.model;
  }
}
