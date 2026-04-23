import 'package:flutter/material.dart';

import 'core/di/core_di.dart';
import 'core/di/service_locator.dart';
import 'core/env/app_env.dart';
import 'modules/single_screen_dummy/domain/usecases/fetch_user_details_use_case.dart';
import 'modules/single_screen_dummy/presentation/ui/user_details_screen.dart';
import 'modules/single_screen_dummy/single_screen_dummy_di.dart';

void main() {
  AppEnv.init(Environment.dev);
  CoreDI.register();
  SingleScreenDummyDI.register();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Details App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: UserDetailsScreen(
        fetchUserDetailsUseCase: sl<FetchUserDetailsUseCase>(),
      ),
    );
  }
}
