import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider_JRBV.dart';
import 'login_screen_JRBV.dart';
import 'home_screen_JRBV.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Provider.of<AuthProvider>(context, listen: false).loadToken();
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => token == null ? const LoginScreen() : const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}