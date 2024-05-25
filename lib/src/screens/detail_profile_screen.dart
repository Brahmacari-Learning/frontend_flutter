import 'package:flutter/material.dart';

class DetailProfileScreen extends StatefulWidget {
  const DetailProfileScreen({super.key});

  @override
  State<DetailProfileScreen> createState() => _DetailProfileScreenState();
}

class _DetailProfileScreenState extends State<DetailProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/detail_profil_background.png'), 
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  AppBar(
                    title: const Text('Privasi'),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    scrolledUnderElevation: 0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    child: const Center(
                        child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('lib/assets/images/user2.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextFormField(
                    // controller: _usernameController,
                    decoration: const InputDecoration(
                        labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    // controller: _emailController,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    // controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    // controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your new password';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    // controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm New Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your New password';
                      }
                      // if (value != _passwordController.text) {
                      //   return 'Password does not match';
                      // }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButtonTheme(
                    data: Theme.of(context).elevatedButtonTheme,
                    child: ElevatedButton(
                      style: ElevatedButtonTheme.of(context).style,
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                        ),
                      ),
                      onPressed: () {}
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}