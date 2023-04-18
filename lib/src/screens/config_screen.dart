import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConfigScreenState createState() => ConfigScreenState();
}

class ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    String recaptchaHtml = '''
<!DOCTYPE html>
<html>
<head>
  <title>reCAPTCHA Example</title>
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</head>
<body>
  <form id="recaptcha-form">
    <div class="g-recaptcha" data-sitekey="YOUR_SITE_KEY" data-callback="recaptchaCallback"></div>
  </form>
  <script>
    function recaptchaCallback() {
      var response = grecaptcha.getResponse();
      if (response) {
        window.flutter_inappwebview.callHandler('onVerifiedSuccessfully', response);
      }
    }
  </script>
</body>
</html>
''';

    return Scaffold(
      // ... appBar, body e bottomNavigationBar
      body: WebView(
        initialUrl: Uri.dataFromString(
          recaptchaHtml,
          mimeType: 'text/html',
        ).toString(),
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: {
          JavascriptChannel(
            name: 'flutter_inappwebview',
            onMessageReceived: (message) {
            },
          ),
        },
      ),
    );
  }
}
