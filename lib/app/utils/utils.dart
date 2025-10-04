
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermission({required Permission permission}) async {
  final status = await permission.status;
  if (status.isGranted) {
    debugPrint('${permission.toString()} is already granted.');
  }else if (status.isDenied){
    if(await permission.request().isGranted){
      debugPrint('${permission.toString()} permission granted after request.');
    } else {
      debugPrint('${permission.toString()} permission denied after request.');
    }
  }else{
    debugPrint('${permission.toString()} permission status: $status');
    
  }
}