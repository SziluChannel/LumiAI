import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'email_service.g.dart';

@Riverpod(keepAlive: true)
class EmailService extends _$EmailService {
  final _storage = const FlutterSecureStorage();

  static const _kSmtpHostKey = 'smtp_host';
  static const _kSmtpPortKey = 'smtp_port';
  static const _kSmtpEmailKey = 'smtp_email';
  static const _kSmtpPasswordKey = 'smtp_password';

  @override
  Future<void> build() async {
    // No initialization needed for now
  }

  Future<void> saveSettings({
    required String host,
    required int port,
    required String email,
    required String password,
  }) async {
    await _storage.write(key: _kSmtpHostKey, value: host);
    await _storage.write(key: _kSmtpPortKey, value: port.toString());
    await _storage.write(key: _kSmtpEmailKey, value: email);
    await _storage.write(key: _kSmtpPasswordKey, value: password);
  }

  Future<Map<String, String?>> getSettings() async {
    return {
      'host': await _storage.read(key: _kSmtpHostKey),
      'port': await _storage.read(key: _kSmtpPortKey),
      'email': await _storage.read(key: _kSmtpEmailKey),
      // Password is not returned for security in UI, only used internally
    };
  }

  Future<void> sendEmail({
    required String recipient,
    required String subject,
    required String body,
  }) async {
    // Web Fallback: Direct SMTP is not supported on Web due to browser security (no TCP sockets).
    if (kIsWeb) {
      debugPrint('🌍 Web platform detected: Falling back to mailto.');
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: recipient,
        query: _encodeQueryParameters(<String, String>{
          'subject': subject,
          'body': body,
        }),
      );
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
        return;
      } else {
        throw Exception('Could not launch email client on Web.');
      }
    }

    // Native Platform: Use SMTP
    final host = await _storage.read(key: _kSmtpHostKey);
    final portStr = await _storage.read(key: _kSmtpPortKey);
    final email = await _storage.read(key: _kSmtpEmailKey);
    final password = await _storage.read(key: _kSmtpPasswordKey);

    if (host == null || portStr == null || email == null || password == null) {
      throw Exception(
        'SMTP settings are missing. Please configure them in Settings.',
      );
    }

    final port = int.tryParse(portStr) ?? 587;

    final smtpServer = SmtpServer(
      host,
      port: port,
      username: email,
      password: password,
      ssl: port == 465, // Usually 465 is SSL, 587 is STARTTLS
      ignoreBadCertificate: false,
    );

    final message = Message()
      ..from = Address(email, 'LumiAI User')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
    } catch (e) {
      debugPrint('Message not sent.\n$e');
      throw Exception('Failed to send email: $e');
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}
