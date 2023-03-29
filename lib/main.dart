import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'app/app.dart';

void main() {
  final container = ProviderContainer();
  runApp(UncontrolledProviderScope(
    container: container,
    child: const FerrinoxClockApp(),
  ));

  String writeKey;
  if (Platform.isAndroid) {
    writeKey = 'YOUR_ANDROID_WRITE_KEY';
  } else {
    writeKey = 'YOUR_IOS_WRITE_KEY';
  }

  Segment.config(
      options: SegmentConfig(
          writeKey: writeKey,
          trackApplicationLifecycleEvents: false,
          amplitudeIntegrationEnabled: false,
          debug: false));
}
