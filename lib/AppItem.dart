import 'dart:convert';
import 'dart:typed_data';

class AppItem {
  late String packageName;
  late String icon;
  late String appName;
  late String author;
  late String introduction;
  late String appStoreUrl;
  late Uint8List iconRawList;

  AppItem.make(this.packageName, this.icon, this.appName, this.author,
      this.introduction, this.appStoreUrl){
    iconRawList = const Base64Decoder().convert(icon);
  }

}