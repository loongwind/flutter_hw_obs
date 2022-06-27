

## Features

support huawei obs put object and file

support platform : All (Android、iOS、Windows、Mac、Linux、Web)

## Getting started
`pubspec.yaml` add library
```yaml
  flutter_hw_obs:
    git:
      url: https://github.com/loongwind/flutter_hw_obs.git
      ref: 0.0.3
```

## Usage

### init
init huawei obs ak、sk、domain and bucket
```dart
OBSClient.init("xxxxx", "xxxxxxxx", "https://xxxx.obs.cn-east-3.myhuaweicloud.com", "xxxx");
```
### putObject
```dart
await OBSClient.putObject("test/test.txt", "Hello OBS");
```

### putFile
```dart
await OBSClient.putFile("test/test.png", File("/sdcard/Downloads/test.gif"));
```

### response

```dart
class OBSResponse{
  String? objectName;
  String? fileName;
  String? url;
  int? size;
  String? ext;
  String? md5;
}
```
## TODO
- [ ] add debug switch
- [ ] add upload progress