import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/app_theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false; // Track the "Remember Me" checkbox state

  @override
  void initState() {
    super.initState();
    // Check "Remember Me" status when the login screen is initialized
    Provider.of<AuthProvider>(context, listen: false).checkRememberMe();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Masuk ke akun',
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Halo, Selamat datang',
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Theme(
                  data: AppTheme.lightTheme,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.alternate_email_rounded)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.lock_outline_rounded)),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value;
                                });
                              },
                              activeTrackColor: Colors.blue,
                              inactiveThumbColor: Colors.white,
                            ),
                          ),
                          const Text('Remember Me',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      authProvider.isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButtonTheme(
                              data: Theme.of(context).elevatedButtonTheme,
                              child: ElevatedButton(
                                style: ElevatedButtonTheme.of(context).style,
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    bool success = await authProvider.login(
                                      _emailController.text,
                                      _passwordController.text,
                                      _rememberMe,
                                    );
                                    if (success) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/home');
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Login failed')),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                      const SizedBox(height: 20),
                      // Register text redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Belum punya akun? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/register');
                            },
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     await authProvider.logout();
                      //     Navigator.of(context).pushReplacementNamed('/login');
                      //   },
                      //   child: const Text('Logout'),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
