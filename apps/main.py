#!/usr/bin/python3
# coding=utf-8
import datetime
import json
import os
import base64

app_item_list = []


def make_app_item(item_dir):
    json_file = os.getcwd() + '/' + item_dir + '/' + 'app.json'
    icon_file = os.getcwd() + '/' + item_dir + '/' + 'icon.png'
    if not os.path.exists(json_file) or not os.path.exists(icon_file):
        return
    global app_item_list
    with open(json_file, 'r', encoding='utf8') as f:
        json_str = f.read()
        # 解析出app字段
        json_dict = json.loads(json_str)
        package_name = json_dict['packageName']
        app = json_dict['appName']
        author = json_dict['author']
        introduction = json_dict['introduction']
        url = json_dict['appStoreUrl']
        # icon_file to base64 string
        icon_base64 = ''
        with open(icon_file, 'rb') as f2:
            icon_base64 = base64.b64encode(f2.read()).decode()
        line = 'list.add(AppItem.make("%s", "%s", "%s", "%s", "%s", "%s"));' % (package_name, icon_base64, app, author, introduction, url)
        print(line)
        app_item_list.append(line)


def scan_dir():
    # 获取目录下的文件夹
    dir_list = os.listdir(os.getcwd())
    for dir_name in dir_list:
        # 过滤隐藏文件夹
        if os.path.isdir(dir_name) and dir_name[0] != '.':
            print(dir_name)
            make_app_item(dir_name)


if __name__ == '__main__':
    scan_dir()
    # 写入文件
    #
    # import 'package:apps_ad/AppItem.dart';
    #
    # /// 由python脚本自动生成 不要手动编辑
    # class Apps{
    #
    # List<AppItem> getApps(){
    # List<AppItem> list = [];
    #
    #
    # return list;
    # }
    #
    # }
    #
    #

    path = os.path.abspath(os.path.join(os.getcwd(), "..")) + '/lib/gen/Apps.dart'
    with open(path, 'w', encoding='utf8') as f:
        f.write('import \'package:apps_ad/AppItem.dart\';\n')
        f.write('\n')
        f.write('/// 由python脚本自动生成 不要手动编辑\n')
        f.write('/// time->' + str(datetime.datetime.now())+"\n")
        f.write('class Apps{\n')
        f.write('\n')
        f.write('\tList<AppItem> makeApps(){\n')
        f.write('\t\tList<AppItem> list = [];\n')
        f.write('\n')
        for line in app_item_list:
            f.write('\t\t')
            f.write(line)
            f.write('\n')
        f.write('\n')
        f.write('\t\treturn list;\n')
        f.write('\t}\n')
        f.write('\n')
        f.write('}\n')
    print('done')
