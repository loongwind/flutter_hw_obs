
import 'dart:io';

import 'package:flutter_hw_obs/obs_clent.dart';
import 'package:flutter_hw_obs/utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_hw_obs/flutter_hw_obs.dart';

void main() {

  test('file md5', () async{
    String result = await getFileMd5Base64FromPath("/Users/chengminghui/Downloads/red-packet-3.2.1.gif");
    print("------>$result");
    expect(result, "O+LG0pNKl05SPhc8/CxFIA==");
  });

  test('hmac', () async{
    String stringToSign = "PUT\nO+LG0pNKl05SPhc8/CxFIA==\nimage/gif\nMon, 14 Mar 2022 07:48:19 GMT\nx-obs-acl:public-read\n/isong/test/test.gif";

    var hmacSha1 = stringToSign.toHmacSha1Base64("TZGBsXqTQtMiBtIQXwsAPxQHkzZzjmVJTLOjlDhU");
    print("------>${hmacSha1}");
    expect(hmacSha1, "zQKH67+rWpDjOH/2Y2oDiz3R168=");
  });
  test('putObject', () async{
      OBSClient.init("5RJWSBKN6FN0X1ADNB8B", "TZGBsXqTQtMiBtIQXwsAPxQHkzZzjmVJTLOjlDhU", "https://isong.obs.cn-east-3.myhuaweicloud.com", "isong");
      await OBSClient.putObject("test/test_dart.txt", "Hello Dart");
  });
  test('putFile', () async{
      OBSClient.init("5RJWSBKN6FN0X1ADNB8B", "TZGBsXqTQtMiBtIQXwsAPxQHkzZzjmVJTLOjlDhU", "https://isong.obs.cn-east-3.myhuaweicloud.com", "isong");
      await OBSClient.putFile("test/red.gif", File("/Users/chengminghui/Downloads/red-packet-3.2.1.gif"));
  });
}
