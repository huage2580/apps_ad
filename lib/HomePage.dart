
import 'dart:ui';

import 'package:apps_ad/AppItem.dart';
import 'package:apps_ad/gen/Apps.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  final String? pkgName;

  const HomePage({required this.pkgName,Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AppItem> appList = [];

  @override
  void initState() {
    super.initState();

    appList.addAll(Apps().getApps());
    _sortList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                "友情推广",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView.builder(
                    itemBuilder: _buildAppCard,
                    itemCount: appList.length,
                  ))),
        ],
      ),
    );
  }

  Widget _buildAppCard(BuildContext context, int index) {
    final item = appList[index];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: const Color(0xffF8F8F8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x40000000),
                      offset: Offset(0, 4),
                      blurRadius: 10)
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                child: InkWell(
                  onTap: () {
                    launchUrlString(item.appStoreUrl);
                  },
                  hoverColor: Colors.orange[50],
                  splashColor: Colors.orange[100],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                        child: SizedBox(
                          height: 120,
                          width: 120,
                          child: Image.memory(item.iconRawList,width: 120,height: 120,),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.appName,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              item.author,
                              style: const TextStyle(fontSize: 12),
                            ),
                            SizedBox.fromSize(
                              size: const Size(0, 12),
                            ),
                            Text(
                              item.introduction,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Stack(
              children: [
                ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Colors.white.withAlpha(0),
                      ),
                    )),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(200),
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8),
                          topLeft: Radius.circular(8))),
                  height: 30,
                  width: 30,
                  child: const Center(
                      child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 16,
                  )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _sortList() {
    //获取想置顶的包名
    var topPackage = widget.pkgName?.split('?')[0];
    print(topPackage);
    if(topPackage != null){
      var index = -1;
      for(var i=0;i<appList.length;i++){
        var p = appList[i];
        if(p.packageName == topPackage){
          index = i;
          break;
        }
      }
      if(index > 0){
        final app = appList.removeAt(index);
        List<AppItem> t = [];
        t.add(app);
        t.addAll(appList);
        appList = t;
      }
    }
  }
}


