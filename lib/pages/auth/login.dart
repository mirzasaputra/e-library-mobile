import 'package:flutter/material.dart';
import 'package:e_library_mobile/component/general/form_input.dart';
import 'package:e_library_mobile/models/auth.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14907A),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'E - Library App',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 50.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 30.0,
                  ),
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormInput(
                          controller: _usernameController,
                          label: 'Username',
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        const SizedBox(height: 20.0),
                        FormInput(
                          controller: _passwordController,
                          label: 'Password',
                          obsecureText: true,
                          prefixIcon: const Icon(Icons.key),
                        ),
                        const SizedBox(height: 5.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                              ),
                              const SizedBox(width: 10.0),
                              const Text(
                                'Remember Me',
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: RaisedButton(
                            splashColor: const Color(0xFF0C5D4E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: isLoading ? null : () {
                              if(_formKey.currentState!.validate()) {
                                _checkLogin(context, _usernameController.text, _passwordController.text);
                              }
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isLoading ? <Color> [
                                    const Color(0x8E086655),
                                    const Color(0x6C149079),
                                    const Color(0x8E086655),
                                  ] : <Color> [
                                    const Color(0xFF086655),
                                    const Color(0xFF14907A),
                                    const Color(0xFF086655),
                                  ],
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 88.0,
                                  minHeight: 50.0,
                                ),
                                alignment: Alignment.center,
                                child: isLoading ? const SizedBox(
                                  height: 30.0,
                                  width: 30.0,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  )
                                ) : const Text(
                                  'Login', 
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                InkWell(
                  onTap: (){},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                const Text(
                  'Copyright 2022 | Kelompok 4', 
                  style: TextStyle(
                    color: Colors.white54
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _checkLogin(BuildContext context, String username, String password) async {
    setState(() {
      isLoading = true;
    });

    final res = await login(username, password);

    setState(() {
      isLoading = false;
    });

    if(res.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/main');
    } else {
      if (res.statusCode == 422) {
        Map<String, dynamic> data = jsonDecode(res.body);

        if (data['errors']['username'] != null) {
          _showToast(context, data['errors']['username'][0]);
        }

        if (data['errors']['password'] != null) {
          _showToast(context, data['errors']['password'][0]);
        }
      } else {
        Map<String, dynamic> data = jsonDecode(res.body);

        _showToast(context, data['message']);
      }
    }
  }

  dynamic _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.close_rounded, color: Colors.red),
          const SizedBox(width: 5.0),
          Container(
            width: MediaQuery.of(context).size.width - 80,
            child: Text(message),
          )
        ],
      )
    ));
  }
}