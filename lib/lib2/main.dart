import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './data/repositories/persisted_reminder_repository.dart';
import './data/repositories/reminder_repository.dart';
import './data/tools/notification_handler.dart';
import './pages/homepage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final ReminderRepository repository = PersistedReminderRepository();

//   // only initialize notification handler if not web
//   if (!kIsWeb) {
//     final NotificationHandler notificationHandler =
//         NotificationHandler(repository);
//     await notificationHandler.initialize();
//   }

//   runApp(ReminderNewPage(reminderRepository: repository));
// }

const _brandPrimary = Color(0xFF4F57A9);

class ReminderNewPage extends StatelessWidget {
  final ReminderRepository reminderRepository;
  const ReminderNewPage({Key? key, required this.reminderRepository})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: reminderRepository,
        child: DynamicColorBuilder(
          builder: ((lightDynamic, darkDynamic) {
            ColorScheme lightColorScheme;
            ColorScheme darkColorScheme;

            if (lightDynamic != null && darkDynamic != null) {
              lightColorScheme = lightDynamic.harmonized();

              darkColorScheme = darkDynamic.harmonized();
            } else {
              // Otherwise, use fallback schemes.
              lightColorScheme = ColorScheme.fromSeed(
                seedColor: _brandPrimary,
              );

              darkColorScheme = ColorScheme.fromSeed(
                seedColor: _brandPrimary,
                brightness: Brightness.dark,
              );
              // switch around the error container colors
              darkColorScheme = darkColorScheme.copyWith(
                  error: darkColorScheme.errorContainer,
                  errorContainer: darkColorScheme.error,
                  onError: darkColorScheme.onErrorContainer,
                  onErrorContainer: darkColorScheme.onError);
            }

            return MaterialApp(
              title: 'RemindMe',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme,
                appBarTheme: AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
                        statusBarColor: const Color.fromARGB(0, 0, 0, 0)),
                    titleTextStyle: TextStyle(
                        color: lightColorScheme.onBackground, fontSize: 22),
                    backgroundColor: Colors.white.withAlpha(0),
                    centerTitle: true,
                    elevation: 0),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: lightColorScheme.primaryContainer,
                    foregroundColor: lightColorScheme.onPrimaryContainer),
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme,
                appBarTheme: AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
                        statusBarColor: const Color.fromARGB(0, 0, 0, 0)),
                    titleTextStyle: TextStyle(
                        color: darkColorScheme.onBackground, fontSize: 22),
                    backgroundColor: Colors.white.withAlpha(0),
                    centerTitle: true,
                    elevation: 0),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: darkColorScheme.primaryContainer,
                    foregroundColor: darkColorScheme.onPrimaryContainer),
              ),
              home: const HomePage(),
            );
          }),
        ));
  }

  void dispose() {
    reminderRepository.dispose();
  }
}
