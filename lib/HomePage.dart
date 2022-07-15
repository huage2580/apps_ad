
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

    appList.addAll(Apps().makeApps());
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
      floatingActionButton: FloatingActionButton.small(onPressed: (){
        _showAbout();
      },child: const Text("?",style: TextStyle(color: Colors.white),),),
    );
  }

  Widget _buildAppCard(BuildContext context, int index) {
    final item = appList[index];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
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
            hoverColor: Colors.green[50],
            splashColor: Colors.green[100],
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
                      const SizedBox(height: 4,),
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


  void _showAbout() async{
    await showDialog(context: context, builder: (ctx)=>AlertDialog(
      title: const Text("推荐我的应用"),
      content: const Text("加入推荐联盟，只需通过Github项目发起PR，合并后自动发布。\n\nhttps://github.com/huage2580/apps_ad\n\n更多信息，参考README。"),
      actions: [
        TextButton(onPressed: (){
          launchUrlString("https://github.com/huage2580/apps_ad");
        }, child: const Text("前往项目Github"))
      ],
    ));
  }
}


