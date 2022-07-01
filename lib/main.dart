import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:collection/collection.dart';

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
  String _text = "Loading...";

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
    var logged_in = jsonData['LOGGED_IN'];

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
    developer.log(logged_in.toString(), name: "LoggedIn");
    developer.log(continuation.toString().split('{"token":"')[1],
        name: "Continuation");

    var response2 = await Dio().post(
        "https://www.youtube.com/youtubei/v1/browse?key=$key",
        data:
            '{"context":{"client":{"hl":"en","gl":"US","remoteHost":"1.1.1.1","deviceMake":"Apple","deviceModel":"","visitorData":"CgtjTWFfTGs0YmxUZyiAt_eVBg%3D%3D","userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36,gzip(gfe)","clientName":"WEB","clientVersion":"2.20220630.01.00","osName":"Macintosh","osVersion":"10_15_7","originalUrl":"https://www.youtube.com/","screenPixelDensity":2,"platform":"DESKTOP","clientFormFactor":"UNKNOWN_FORM_FACTOR","configInfo":{"appInstallData":"CIC395UGEJje_RIQz_L9EhC4i64FEK6ergUQt8utBRDUg64FENi-rQUQkfj8Eg%3D%3D"},"screenDensityFloat":2,"userInterfaceTheme":"USER_INTERFACE_THEME_DARK","timeZone":"America/Chicago","browserName":"Chrome","browserVersion":"103.0.0.0","screenWidthPoints":851,"screenHeightPoints":687,"utcOffsetMinutes":-300,"connectionType":"CONN_CELLULAR_4G","memoryTotalKbytes":"8000000","mainAppWebInfo":{"graftUrl":"https://www.youtube.com/","pwaInstallabilityStatus":"PWA_INSTALLABILITY_STATUS_UNKNOWN","webDisplayMode":"WEB_DISPLAY_MODE_BROWSER","isWebNativeShareAvailable":false}},"user":{"lockedSafetyMode":false},"request":{"useSsl":true,"internalExperimentFlags":[],"consistencyTokenJars":[]},"clickTracking":{"clickTrackingParams":"CBoQ8eIEIhMIipi89NfV-AIVTx2ECh1qNQhu"},"adSignalsInfo":{"params":[{"key":"dt","value":"1656609664307"},{"key":"flash","value":"0"},{"key":"frm","value":"0"},{"key":"u_tz","value":"-300"},{"key":"u_his","value":"2"},{"key":"u_h","value":"900"},{"key":"u_w","value":"1440"},{"key":"u_ah","value":"798"},{"key":"u_aw","value":"1440"},{"key":"u_cd","value":"30"},{"key":"bc","value":"31"},{"key":"bih","value":"687"},{"key":"biw","value":"835"},{"key":"brdim","value":"0,25,0,25,1440,25,1440,798,851,687"},{"key":"vis","value":"1"},{"key":"wgl","value":"true"},{"key":"ca_type","value":"image"}]}},"continuation":"4qmFsgKFAxIPRkV3aGF0X3RvX3dhdGNoGtQCQ0JoNi1nRkhUa3d4TVdaVVdERm1aME5OWjNOSmNrcGhUbXMyV0cxdVkxUnZRVlp3ZEVOdGMwdEhXR3d3V0ROQ2FGb3lWbVpqTWpWb1kwaE9iMkl6VW1aamJWWnVZVmM1ZFZsWGQxTklNVlUwVW14YVlWcEZhSGRPUjFwdVZqRkdSR0ZXVG5GbFIzaERWVlZvTWsxNlRqUlhiVVpJWlVkallVeFJRVUZhVnpSQlFWWldWRUZCUmxaVmQwRkNRVVZhUm1ReWFHaGtSamt3WWpFNU0xbFlVbXBoUVVGQ1FVRkZRa0ZCUVVKQlFVVkJRVUZGUWtGSFNYTkRRVUZUUlROQ2FGb3lWbVpqTWpWb1kwaE9iMkl6VW1aa1J6bHlXbGMwWVVWM2FVdHRUSG93TVRsWU5FRm9WbEJJV1ZGTFNGZHZNVU5ITnpadVRXVTVRMUZKU1VkUpoCGmJyb3dzZS1mZWVkRkV3aGF0X3RvX3dhdGNo"}',
        options: Options(headers: {"Content-Type": "application/json"}));

    var items = jsonDecode(response2.toString())["onResponseReceivedActions"][0]
        ["appendContinuationItemsAction"]["continuationItems"];
    var titles = [];
    for (var item in items) {
      if (item.containsKey("richItemRenderer")) {
        var title = item["richItemRenderer"]["content"]["videoRenderer"]
            ["title"]["runs"][0]["text"];
        titles.add(title);
        developer.log(title, name: "video title");
      }
    }
    ;

    var outputString = "";
    for (var title in titles) {
      outputString += title + "\n\n\n\n";
    }

    // and get the videoIds
    return outputString;
  };

  void _incrementCounter() {
    fetchKey().then((value) => {
          setState(() {
            _text = value.toString();
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text( 
              'FlutterTube videos',
            ),
            Text(
              _text,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
