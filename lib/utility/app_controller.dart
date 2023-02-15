import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  
  RxList positions = <Position>[].obs;
  RxList files = <File>[].obs;
}