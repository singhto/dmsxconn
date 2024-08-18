import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AppController extends GetxController {
  
  RxList positions = <Position>[].obs;
  RxList files = <File>[].obs;

  RxList<XFile> xFiles = <XFile>[].obs;
  RxList<String> nameFiles =<String>[].obs;

}