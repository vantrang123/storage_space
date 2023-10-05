import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class DiskSpace {
  static const MethodChannel _channel = const MethodChannel('disk_space');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> get getFreeDiskSpace async {
    final String? freeDiskSpace =
        await _channel.invokeMethod('getFreeDiskSpace');
    return freeDiskSpace;
  }

  static Future<String?> get getTotalDiskSpace async {
    final String? totalDiskSpace =
        await _channel.invokeMethod('getTotalDiskSpace');
    return totalDiskSpace;
  }

  static Future<String?> get getUsedDiskSpace async {
    final String? data =
    await _channel.invokeMethod('getUsedDiskSpace');
    return data;
  }

  static Future<String?> get getPercentageUsedDiskSpace async {
    final String? data =
    await _channel.invokeMethod('getPercentageUsedDiskSpace');
    return data;
  }

  static Future<String?> getFreeDiskSpaceForPath(String path) async {
    if (!Directory(path).existsSync()) {
      throw Exception("Specified path does not exist");
    }
    final String? freeDiskSpace =
        await _channel.invokeMethod('getFreeDiskSpaceForPath', {"path": path});
    return freeDiskSpace;
  }
}
