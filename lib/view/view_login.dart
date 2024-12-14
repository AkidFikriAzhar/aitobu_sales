import 'package:aitobu_sales/router.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewLogin extends StatefulWidget {
  const ViewLogin({super.key});

  @override
  State<ViewLogin> createState() => _ViewLoginState();
}

class _ViewLoginState extends State<ViewLogin> {
  final _providers = [EmailAuthProvider()];
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: _providers,
      showAuthActionSwitch: false,
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          context.go(MyRouter.home);
        }),
      ],
    );
  }
}
