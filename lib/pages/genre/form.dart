import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:e_library_mobile/component/general/form_input.dart';
import 'package:e_library_mobile/api/genre_api.dart';
import 'package:e_library_mobile/arguments/update_user.dart';

class FormGenrePage extends StatefulWidget {
  const FormGenrePage({Key? key}) : super(key: key);

  @override
  State<FormGenrePage> createState() => _FormGenreState();
}

class _FormGenreState extends State<FormGenrePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  _getGenre(String hashid) {
    GenreApi.findOne(hashid).then((user){
      setState(() {
        _nameController.text = user.name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UpdateUserArgument?;
    
    if(args != null && _nameController.text == '') {
      _getGenre(args.hashid);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF14907A),
        title: Text(args != null ? 'Edit Genre' : 'Tambah Genre')
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
                      );
                    } else {
                      _updateData(
                        context,
                        _nameController.text,
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

  Future _createData(BuildContext context, String name) async {
    setState(() {
      isLoading = true;
    });

    final res = await GenreApi.store(jsonEncode(<String, String> {
      'name': name,
    }));

    setState(() {
      isLoading = false;
    });

    if(res.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, '/genre');
    } else {
      if (res.statusCode == 422) {
        Map<String, dynamic> data = jsonDecode(res.body);

        if (data['errors']['name'] != null) {
          _showToast(context, data['errors']['name'][0]);
        }
      } else {
        Map<String, dynamic> data = jsonDecode(res.body);

        _showToast(context, data['message']);
      }
    }
  }

  Future _updateData(BuildContext context, String name, String hashid) async {
    setState(() {
      isLoading = true;
    });

    final res = await GenreApi.update(hashid, jsonEncode(<String, String> {
      'name': name,
    }));

    if(res.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, '/genre');
    } else {
      if (res.statusCode == 422) {
        Map<String, dynamic> data = jsonDecode(res.body);

        if (data['errors']['name'] != null) {
          _showToast(context, data['errors']['name'][0]);
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