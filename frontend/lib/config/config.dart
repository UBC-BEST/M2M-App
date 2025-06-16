import 'package:flutter_dotenv/flutter_dotenv.dart';

String get serverEndpoint {
  final ip = dotenv.env['FLUTTER_APP_EXP_IP'];
  final port = dotenv.env['FLUTTER_APP_EXP_PORT'];
  return 'http://$ip:$port';
}
