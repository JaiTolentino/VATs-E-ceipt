import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posclient/counter/view/account_page.dart';
import 'package:posclient/counter/view/expenses_page.dart';
import 'package:posclient/counter/view/home_page.dart';
import 'package:posclient/counter/view/landing_page.dart';
import 'package:posclient/counter/view/qrcode_page.dart';
import 'package:posclient/counter/view/receiptDetails_page.dart';
import 'package:posclient/counter/view/receipt_page.dart';
import 'package:posclient/counter/view/register_page.dart';
import 'package:posclient/l10n/l10n.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return LandingPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return RegisterPage();
          },
        ),
        GoRoute(
          path: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return HomePage();
          },
        ),
        GoRoute(
          path: 'expenses',
          builder: (BuildContext context, GoRouterState state) {
            return ExpensesPage();
          },
        ),
        GoRoute(
          path: 'qr',
          builder: (BuildContext context, GoRouterState state) {
            return QrCodePage();
          },
        ),
        GoRoute(
          path: 'account',
          builder: (BuildContext context, GoRouterState state) {
            return AccountPage();
          },
        ),
        GoRoute(
          path: 'receipt/:referenceNumber',
          builder: (BuildContext context, GoRouterState state) {
            return ReceiptPage(
              referenceNumber:
                  int.parse(state.pathParameters['referenceNumber']!),
            );
          },
        ),
        GoRoute(
          path: 'receiptdetails/:referenceNumber',
          builder: (BuildContext context, GoRouterState state) {
            return ReceiptdetailsPage(
              referenceNumber:
                  int.parse(state.pathParameters['referenceNumber']!),
            );
          },
        ),
      ],
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        textTheme: TextTheme(
          bodySmall: TextStyle(),
          bodyLarge: TextStyle(),
          bodyMedium: TextStyle(),
        ).apply(bodyColor: Colors.white),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
