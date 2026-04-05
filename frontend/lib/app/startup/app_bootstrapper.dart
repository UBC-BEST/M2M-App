import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/app_config.dart';
import '../../core/constants/dev_auth.dart';
import '../../core/constants/storage_keys.dart';
import 'app_launch_state.dart';

class AppBootstrapper {
  AppBootstrapper({SharedPreferences? preferences})
      : _preferences = preferences;

  final SharedPreferences? _preferences;

  Future<AppLaunchState> load() async {
    final prefs = _preferences ?? await SharedPreferences.getInstance();

    if (AppConfig.bypassAuth) {
      await prefs.setString(StorageKeys.accessToken, kDevBypassAccessToken);
      await prefs.setBool(StorageKeys.hasLaunched, true);
    }

    final hasLaunched = prefs.getBool(StorageKeys.hasLaunched) ?? false;
    final isLoggedIn = prefs.getString(StorageKeys.accessToken) != null;

    if (!hasLaunched) {
      await prefs.setBool(StorageKeys.hasLaunched, true);
    }

    return AppLaunchState(
      showOnboarding: !hasLaunched,
      isLoggedIn: isLoggedIn,
    );
  }
}
