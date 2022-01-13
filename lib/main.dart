import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'navigation/app_router.dart';

void main() {
  runApp(const HeroClient());
}

class HeroClient extends StatefulWidget {
  const HeroClient({
    Key? key,
  }) : super(key: key);

  @override
  State<HeroClient> createState() => _HeroClientState();
}

class _HeroClientState extends State<HeroClient> {
  final _appStateManager = AppStateManager();
  final _createAccountManager = LoginStateManager();
  late AppRouter _appRouter;

  @override
  void initState() {
    _appRouter = AppRouter(
        appStateManager: _appStateManager,
        loginStateManager: _createAccountManager
        // groceryManager: _groceryManager,
        // profileManager: _profileManager,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _appStateManager),
        ChangeNotifierProvider(create: (context) => _createAccountManager)
      ],
      child: MaterialApp(
        title: 'Hero Client',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSwatch(
        //       accentColor: kPrimaryColor,
        //       primarySwatch: Colors.green,
        //       cardColor: kPrimaryColor),
        // ),
        home: Router(
          routerDelegate: _appRouter,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
