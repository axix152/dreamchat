import 'package:dreamchat/common/widget/loader.dart';
import 'package:dreamchat/features/auth/controller/auth_controller.dart';
import 'package:dreamchat/router.dart';
import 'package:dreamchat/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './screens/splash_Screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ref.watch(userDataAuthProvider).when(
          data: (user) {
            if (user == null) {
              return const SplashScreen();
            }
            return HomeScreen();
          },
          error: (err, trace) {
            return Scaffold(
              body: Center(
                child: Text(err.toString()),
              ),
            );
          },
          loading: () => const Loader()),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
