

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringMd5Ext on String{
  List<int> toMD5Bytes(){
    var content = Utf8Encoder().convert(this);
    var digest = md5.convert(content);
    return digest.bytes;
  }

  String toMD5(){
    return toMD5Bytes().toString();
  }

  String toMD5Base64(){
    var md5Bytes = toMD5Bytes();
    return base64.encode(md5Bytes);
  }
  
  String toHmacSha1Base64(String sk){
    var hmacSha1 = Hmac(sha1, utf8.encode(sk));
    return base64.encode(hmacSha1.convert(utf8.encode(this)).bytes);
  }
}

extension ListIntExt on List<int>{
  List<int> toMD5Bytes(){
    return md5.convert(this).bytes;
  }

  String toMD5(){
    return toMD5Bytes().toString();
  }

  String toMD5Base64(){
    return base64.encode(toMD5Bytes());
  }
}

Future<List<int>> getFileMd5BytesFromPath(String filePath) async{
  File file = File(filePath);
  var digest = await md5.bind(file.openRead()).first;
  return digest.bytes;
}

Future<List<int>> getFileMd5Bytes(File file) async{
  var digest = await md5.bind(file.openRead()).first;
  return digest.bytes;
}

Future<String> getFileMd5Base64FromPath(String filePath) async{
  var md5bytes = await getFileMd5BytesFromPath(filePath);
  return base64.encode(md5bytes);
}

Future<String> getFileMd5Base64(File file) async{
  var md5bytes = await getFileMd5Bytes(file);
  return base64.encode(md5bytes);
}


String getRFC1123Date(){
  return HttpDate.format(DateTime.now());
}

