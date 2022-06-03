import 'package:permission_handler/permission_handler.dart';

late Permission permission;

Future<void> listenforpermissions() async {
  final status = await Permission.location.status;

  switch (status) {
    case PermissionStatus.denied:
      requestForPermission();

      break;
    default:
  }
}

Future<void> requestForPermission() async {
  await Permission.location.request();
}
