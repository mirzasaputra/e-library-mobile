import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:e_library_mobile/component/general/form_input.dart';
import 'package:e_library_mobile/api/user_api.dart';
import 'package:e_library_mobile/arguments/update_user.dart';

class FormUserPage extends StatefulWidget {
  const FormUserPage({Key? key}) : super(key: key);

  @override
  State<FormUserPage> createState() => _FormUserState();
}

class _FormUserState extends State<FormUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  _getUser(String hashid) {
    UserApi.findOne(hashid).then((user){
      setState(() {
        _nameController.text = user.name;
        _usernameController.text = user.username;
        _emailController.text = user.email;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UpdateUserArgument?;
    
    if(args != null && _nameController.text == '') {
      _getUser(args.hashid);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF14907A),
        title: Text(args != null ? 'Edit User' : 'Tambah User')
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FormInput(
                  controller: _nameController,
                  label: 'Nama'
                ),
                const SizedBox(height: 20.0),
                FormInput(
                  controller: _emailController,
                  label: 'Email',
                ),
                const SizedBox(height: 20.0),
                FormInput(
                  controller: _usernameController,
                  label: 'Username',
                ),
                const SizedBox(height: 20.0),
                FormInput(
                  controller: _passwordController,
                  label: 'Password',
                  obsecureText: true,
                  readOnly: (args != null),
                ),
                const SizedBox(height: 20.0),
                FormInput(
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi Password',
                  obsecureText: true,
                  readOnly: (args != null),
                ),
                const SizedBox(height: 30.0),
                RaisedButton(
                  splashColor: const Color(0xFF0C5D4E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding: const EdgeInsets.all(0),
                  onPressed: isLoading ? null : () {
                    if(args == null) {
                      _createData(
                        context,
                        _nameController.text,
                        _usernameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _confirmPasswordController.text
                      );
                    } else {
                      _updateData(
                        context,
                        _nameController.text,
                        _emailController.text,
                        _usernameController.text,
                        args.hashid
                      );
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
                      ) : Text(
                        args == null ? 'Tambah' : 'Update', 
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  Future _createData(BuildContext context, String name, String username, String email, String password, String confirmPassword) async {
    setState(() {
      isLoading = true;
    });

    final res = await UserApi.store(jsonEncode(<String, String> {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword
    }));

    setState(() {
      isLoading = false;
    });

    if(res.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, '/user');
    } else {
      if (res.statusCode == 422) {
        Map<String, dynamic> data = jsonDecode(res.body);

        if (data['errors']['name'] != null) {
          _showToast(context, data['errors']['name'][0]);
        }

        if (data['errors']['email'] != null) {
          _showToast(context, data['errors']['email'][0]);
        }

        if (data['errors']['username'] != null) {
          _showToast(context, data['errors']['username'][0]);
        }

        if (data['errors']['password'] != null) {
          _showToast(context, data['errors']['password'][0]);
        }

        if (data['errors']['confirm_password'] != null) {
          _showToast(context, data['errors']['confirm_password'][0]);
        }
      } else {
        Map<String, dynamic> data = jsonDecode(res.body);

        _showToast(context, data['message']);
      }
    }
  }

  Future _updateData(BuildContext context, String name, String email, String username, String hashid) async {
    setState(() {
      isLoading = true;
    });

    final res = await UserApi.update(hashid, jsonEncode(<String, String> {
      'name': name,
      'username': username,
      'email': email
    }));

    if(res.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, '/user');
    } else {
      if (res.statusCode == 422) {
        Map<String, dynamic> data = jsonDecode(res.body);

        if (data['errors']['name'] != null) {
          _showToast(context, data['errors']['name'][0]);
        }

        if (data['errors']['email'] != null) {
          _showToast(context, data['errors']['email'][0]);
        }

        if (data['errors']['username'] != null) {
          _showToast(context, data['errors']['username'][0]);
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