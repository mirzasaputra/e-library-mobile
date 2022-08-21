import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:e_library_mobile/component/general/form_input.dart';
import 'package:e_library_mobile/api/book_api.dart';
import 'package:e_library_mobile/arguments/update_user.dart';

class FormBookPage extends StatefulWidget {
  const FormBookPage({Key? key}) : super(key: key);

  @override
  State<FormBookPage> createState() => _FormBookState();
}

class _FormBookState extends State<FormBookPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _publicationYearController;
  late TextEditingController _authorController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _publicationYearController = TextEditingController();
    _authorController = TextEditingController();
  }

  _getBooks(String hashid) {
    BookApi.findOne(hashid).then((book){
      setState(() {
        _nameController.text = book.name;
        _descriptionController.text = book.description!;
        _publicationYearController.text = book.publicationYear;
        _authorController.text = book.author;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UpdateUserArgument?;
    
    if(args != null && _nameController.text == '') {
      _getBooks(args.hashid);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF14907A),
        title: Text(args != null ? 'Edit Buku' : 'Tambah Buku')
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
                  controller: _descriptionController,
                  label: 'Description'
                ),
                const SizedBox(height: 20.0),
                FormInput(
                  controller: _publicationYearController,
                  label: 'Tahun Terbit'
                ),
                const SizedBox(height: 20.0),
                FormInput(
                  controller: _authorController,
                  label: 'Penulis'
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
                        _descriptionController.text,
                        _publicationYearController.text,
                        _authorController.text,
                      );
                    } else {
                      _updateData(
                        context,
                        _nameController.text,
                        _descriptionController.text,
                        _publicationYearController.text,
                        _authorController.text,
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

  Future _createData(BuildContext context, String name, String description, String publicationYear, String author) async {
    setState(() {
      isLoading = true;
    });

    final res = await BookApi.store(jsonEncode(<String, String> {
      'name': name,
      'genre_id': '2',
      'description': description,
      'publication_year': publicationYear,
      'author': author,
    }));

    setState(() {
      isLoading = false;
    });

    if(res.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, '/book');
    } else {
      if (res.statusCode == 422) {
        Map<String, dynamic> data = jsonDecode(res.body);

        if (data['errors']['name'] != null) {
          _showToast(context, data['errors']['name'][0]);
        }

        if (data['errors']['description'] != null) {
          _showToast(context, data['errors']['description'][0]);
        }

        if (data['errors']['publication_year'] != null) {
          _showToast(context, data['errors']['publication_year'][0]);
        }

        if (data['errors']['author'] != null) {
          _showToast(context, data['errors']['author'][0]);
        }
      } else {
        Map<String, dynamic> data = jsonDecode(res.body);

        _showToast(context, data['message']);
      }
    }
  }

  Future _updateData(BuildContext context, String name, String description, String publicationYear, String author, String hashid) async {
    setState(() {
      isLoading = true;
    });

    final res = await BookApi.update(hashid, jsonEncode(<String, String> {
      'name': name,
      'genre_id': '2',
      'description': description,
      'publication_year': publicationYear,
      'author': author,
    }));

    if(res.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, '/book');
    } else {
      if (res.statusCode == 422) {
        Map<String, dynamic> data = jsonDecode(res.body);

        if (data['errors']['name'] != null) {
          _showToast(context, data['errors']['name'][0]);
        }

        if (data['errors']['description'] != null) {
          _showToast(context, data['errors']['description'][0]);
        }

        if (data['errors']['publication_year'] != null) {
          _showToast(context, data['errors']['publication_year'][0]);
        }

        if (data['errors']['author'] != null) {
          _showToast(context, data['errors']['author'][0]);
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