import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterTube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'FlutterTube'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  Function() fetchKey = () async {
    final response = await Dio().get("https://youtube.com",
        options: Options(headers: {"User-Agent": "Mozilla/5.0"}));
    // log response.data.first.toString();
    var data = response.data.toString();
    // get text in between ABC and DEF
    const start = "{window.ytplayer={};\nytcfg.set(";
    const end = ");";

    final startIndex = data.indexOf(start);
    final endIndex = data.indexOf(end, startIndex + start.length);

    var ytcfg = data.substring(startIndex + start.length, endIndex);

    developer.log(ytcfg, name: 'ytcfg');

    var jsonData = jsonDecode(ytcfg);
    var key = jsonData['INNERTUBE_API_KEY'];
    var context = jsonData['INNERTUBE_CONTEXT'];
    var loggedIn = jsonData['LOGGED_IN'];

    const start1 =
        '","commandMetadata":{"webCommandMetadata":{"sendPost":true,"apiUrl":"/youtubei/v1/browse"}},"continuationCommand":{"token":"';
    const end1 =
        '","request":"CONTINUATION_REQUEST_TYPE_BROWSE","command":{"clickTrackingParams":"';

    final startIndex1 = data.indexOf(start1);
    final endIndex1 = data.indexOf(end1, startIndex1 + start1.length);

    var continuation = data.substring(startIndex1 + start1.length, endIndex1);

    // log text
    developer.log(key, name: "ApiKey");
    developer.log(context.toString(), name: "Context");
    developer.log(loggedIn.toString(), name: "LoggedIn");
    developer.log(continuation.toString().split('{"token":"')[1],
        name: "Continuation");

    var response2 = await Dio().post(
        "https://www.youtube.com/youtubei/v1/browse?key=$key&prettyPrint=false",
        data:
            '{"context":{"client":{"hl":"en","gl":"US","remoteHost":"1.1.1.1","deviceMake":"Apple","deviceModel":"","visitorData":"CgsxTm80bzhUMVB0TSjp9v6VBg%3D%3D","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36,gzip(gfe)","clientName":"WEB","clientVersion":"2.20220701.01.00","osName":"Macintosh","osVersion":"10_15_7","originalUrl":"https://www.youtube.com/","platform":"DESKTOP","clientFormFactor":"UNKNOWN_FORM_FACTOR","configInfo":{"appInstallData":"COn2_pUGELfLrQUQ1IOuBRD6qK4FEJje_RIQyuz9EhC4i64FEM_y_RIQrp6uBRCH8_0SEN-RrgUQ2L6tBRCR-PwS"},"browserName":"Chrome","browserVersion":"103.0.0.0","screenWidthPoints":851,"screenHeightPoints":687,"screenPixelDensity":2,"screenDensityFloat":2,"utcOffsetMinutes":-300,"userInterfaceTheme":"USER_INTERFACE_THEME_DARK","connectionType":"CONN_CELLULAR_4G","memoryTotalKbytes":"8000000","mainAppWebInfo":{"graftUrl":"https://www.youtube.com/","pwaInstallabilityStatus":"PWA_INSTALLABILITY_STATUS_UNKNOWN","webDisplayMode":"WEB_DISPLAY_MODE_BROWSER","isWebNativeShareAvailable":false},"timeZone":"America/Chicago"},"user":{"lockedSafetyMode":false},"request":{"useSsl":true,"internalExperimentFlags":[],"consistencyTokenJars":[{"encryptedTokenJarContents":"ALOGzFz8lX-bydZ7BeAqpnGGhXsARKpOSK1JJuZhcXzq7HmVKczs5o4RwuFqo-eO6hG2HR8rFmhPuYgTKz3pXUnG9El2sIoAPFpUMbX_mW5RPzllsZSfmff5S5zQfnHMBqaE-4-VZIU6K88ja_Sm-h0","expirationSeconds":"600"}]},"clickTracking":{"clickTrackingParams":"CAAQhGciEwjVutPUodn4AhWPC4QKHdqqDck="},"adSignalsInfo":{"params":[{"key":"dt","value":"1656732522104"},{"key":"flash","value":"0"},{"key":"frm","value":"0"},{"key":"u_tz","value":"-300"},{"key":"u_his","value":"2"},{"key":"u_h","value":"900"},{"key":"u_w","value":"1440"},{"key":"u_ah","value":"798"},{"key":"u_aw","value":"1440"},{"key":"u_cd","value":"30"},{"key":"bc","value":"31"},{"key":"bih","value":"687"},{"key":"biw","value":"835"},{"key":"brdim","value":"0,25,0,25,1440,25,1440,798,851,687"},{"key":"vis","value":"1"},{"key":"wgl","value":"true"},{"key":"ca_type","value":"image"}]}},"continuation":"4qmFsgKFAxIPRkV3aGF0X3RvX3dhdGNoGtQCQ0RCNi1nRkhTa05vZWsxMWFESm1aME5OWjNOSmMzWnFiVGs0Y1dGM1pXRmlRVlp3ZEVOdGMwdEhXR3d3V0ROQ2FGb3lWbVpqTWpWb1kwaE9iMkl6VW1aamJWWnVZVmM1ZFZsWGQxTklla0UwVDBaamVtTkdaekpWV0d4T1YyeEdSR0ZXVG5GbFIzaERWVlZvTVUweFdsWlRSa0pJWlVkallVeFJRVUZhVnpSQlFWWldWRUZCUmxaVmQwRkNRVVZhUm1ReWFHaGtSamt3WWpFNU0xbFlVbXBoUVVGQ1FVRkZRa0ZCUVVKQlFVVkJRVUZGUWtGSFNYTkRRVUZUUlROQ2FGb3lWbVpqTWpWb1kwaE9iMkl6VW1aa1J6bHlXbGMwWVVWM2FsWjFkRkJWYjJSdU5FRm9WMUJETkZGTFNHUnhjVVJqYmpadVRXVTVRMUZKU1UxUpoCGmJyb3dzZS1mZWVkRkV3aGF0X3RvX3dhdGNo"}',
        options: Options(headers: {"Content-Type": "application/json"}));

    var items = jsonDecode(response2.toString())["onResponseReceivedActions"][0]
        ["appendContinuationItemsAction"]["continuationItems"];
    var videos = [];
    for (var item in items) {
      if (item.containsKey("richItemRenderer")) {
        var title = item["richItemRenderer"]["content"]["videoRenderer"]
            ["title"]["runs"][0]["text"];
        var thumbnail = item["richItemRenderer"]["content"]["videoRenderer"]
            ["thumbnail"]["thumbnails"][0]["url"];
        var author = item["richItemRenderer"]["content"]["videoRenderer"]
            ["longBylineText"]["runs"][0]["text"];
        var videoId =
            item["richItemRenderer"]["content"]["videoRenderer"]["videoId"];
        var video = {
          "title": title,
          "thumbnail": thumbnail,
          "author": author,
          "videoId": videoId
        };
        videos.add(video);
        developer.log(video.toString(), name: "video title");
      }
    }

    var videoCardOutput = <Widget>[];
    for (var video in videos) {
      // add title to widget
      videoCardOutput.add(
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Image.network(video["thumbnail"]),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(video["author"]),
                ),
                title: Text(video["title"]),
                subtitle: Text(
                  video["author"],
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // and get the videoIds
    return videoCardOutput;
  };

  void _incrementCounter() {
    fetchKey().then((value) => {
          setState(() {
            _videoCards = value;
          })
        });
  }

  var _videoCards = <Widget>[
    const Text(
      'Loading Videos...',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: _videoCards,
        ),
      ),
    );
  }
}
