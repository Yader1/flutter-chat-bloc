import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bloc/blocs/blocs.dart';
import 'package:flutter_chat_bloc/screens/screens.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
//import 'package:flutter_chat_bloc/utils/utils.dart';
//import 'package:flutter_chat_bloc/widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = "splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    _initialize();
    super.didChangeDependencies();
  }

  void _initialize() async {
    if (!_isInit) {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      final authState = context.read<AuthBloc>().state;

      final redirectScreen = authState.isAuthenticated
          ? ChatListScreen.routeName
          : GuestScreen.routeName;

      Navigator.of(context).pushReplacementNamed(redirectScreen);
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BlankContent(
        isLoading: true,
      ),
    );
  }
}
