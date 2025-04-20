import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/core/providers/app_state.dart';
import '/routes.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // If already logged in, navigate to home
    if (appState.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, Routes.home);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                bool success;
                if (_isLogin) {
                  success = await appState.login(
                    _usernameController.text,
                    _passwordController.text,
                  );
                } else {
                  success = await appState.register(
                    _usernameController.text,
                    _passwordController.text,
                  );
                }

                if (success) {
                  Navigator.pushReplacementNamed(context, Routes.home);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Authentication failed')),
                  );
                }
              },
              child: Text(_isLogin ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(_isLogin ? 'Create account' : 'Login instead'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}