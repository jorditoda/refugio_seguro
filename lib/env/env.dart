import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_URL', obfuscate: true)
  static String API_URL = _Env.API_URL;
  @EnviedField(varName: 'LOCAL_API_URL', obfuscate: true)
  static String LOCAL_API_URL = _Env.LOCAL_API_URL;
}
