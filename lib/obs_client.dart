import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_hw_obs/obs_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:path/path.dart' as path;

import 'utils.dart';

class OBSClient {

  static String? ak;
  static String? sk;
  static String? bucketName;
  static String? domain;

  static void init(String ak, String sk, String domain, String bucketName){
    OBSClient.ak  = ak;
    OBSClient.sk = sk;
    OBSClient.domain = domain;
    OBSClient.bucketName = bucketName;
  }

  static Dio _getDio() {
    var dio = Dio();
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true, requestBody: true, responseHeader: true));
    return dio;
  }


  static Future<OBSResponse?> putObject(String objectName, List<int> data,{String xObsAcl = "public-read"}) async{
    String contentMD5 = data.toMD5Base64();
    int size = data.length;
    var stream = Stream.fromIterable(data.map((e) => [e]));
    OBSResponse? obsResponse = await put(objectName, stream, contentMD5, size, xObsAcl: xObsAcl);
    return obsResponse;
  }


  static Future<OBSResponse?> putString(String objectName, String content,{String xObsAcl = "public-read"}) async{
    var contentMD5 = content.toMD5Base64();
    var size = content.length;
    OBSResponse? obsResponse = await put(objectName, content, contentMD5, size, xObsAcl: xObsAcl);
    return obsResponse;
  }


  static Future<OBSResponse?> putFile(String objectName, File file,{String xObsAcl = "public-read"}) async{
    var contentMD5 = await getFileMd5Base64(file);
    var stream = file.openRead();
    OBSResponse? obsResponse = await put(objectName, stream, contentMD5, await file.length() xObsAcl: xObsAcl);
    return obsResponse;
  }


  static Future<OBSResponse?> put(String objectName, data , String md5, int size, {String xObsAcl = "public-read"}) async{
    if(objectName.startsWith("/")){
      objectName = objectName.substring(1);
    }
    String url = "$domain/$objectName";

    var contentMD5 = md5;
    var date = HttpDate.format(DateTime.now());
    var contentType = "application/octet-stream";

    Map<String, String> headers = {};
    headers["Content-MD5"] = contentMD5;
    headers["Date"] = date;
    headers["x-obs-acl"] = xObsAcl;
    headers["Authorization"] = _sign("PUT", contentMD5, contentType, date, "x-obs-acl:$xObsAcl", "/$bucketName/$objectName");

    Options options = Options(headers: headers, contentType: contentType);

    Dio dio = _getDio();

    await dio.put(url, data: data, options: options);
    OBSResponse obsResponse = OBSResponse();
    obsResponse.md5 = contentMD5;
    obsResponse.objectName = objectName;
    obsResponse.url = url;
    obsResponse.fileName = path.basename(objectName);
    obsResponse.ext = path.extension(objectName);
    obsResponse.size = size;
    return obsResponse;
  }

  static Future<OBSResponse?> putFileWithPath(String objectName, String filePath,{String xObsAcl = "public-read"}) async{
    return putFile(objectName, File(filePath));
  }

  static String _sign(String httpMethod, String contentMd5, String contentType,
      String date, String acl, String res) {
    if (ak == null || sk == null) {
      throw "ak or sk is null";
    }
    String signContent =
        "$httpMethod\n$contentMd5\n$contentType\n$date\n$acl\n$res";

    return "OBS $ak:${signContent.toHmacSha1Base64(sk!)}";
  }
}