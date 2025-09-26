import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinningManager {
  static const _certificatePath = 'assets/certificates/themoviedb.pem';

  static Future<http.Client> createHttpClient() async {
    try {
      final sslCert = await rootBundle.load(_certificatePath);
      final securityContext = SecurityContext(withTrustedRoots: false)
        ..setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
      final httpClient = HttpClient(context: securityContext)
        ..badCertificateCallback = (cert, host, port) => false;
      return IOClient(httpClient);
    } catch (error, stackTrace) {
      debugPrint('SSL pinning setup failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return http.Client();
    }
  }
}
