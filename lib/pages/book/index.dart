// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:e_library_mobile/models/book.dart';
import 'package:e_library_mobile/api/book_api.dart';
import 'package:e_library_mobile/arguments/update_user.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookState();
}

class _BookState extends State<BookPage> {
  late List<Book> _books;

  @override
  void initState() {
    super.initState();
    _books = [];
    _getBooks();
  }

  _getBooks() {
    BookApi.findAll().then((books) {
      setState(() {
        _books = books;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF14907A),
        title: const Text('Data Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/book/create');
              },
              splashColor: const Color(0xFF0A6655),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                constraints: const BoxConstraints(
                  minWidth: 88.0,
                  minHeight: 40.0,
                  maxWidth: 150.0,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF14907A),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                child: const Center(
                  child: Text(
                    'Tambah', 
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Nama')),
                  DataColumn(label: Text('Tahun Terbit')),
                  DataColumn(label: Text('Penulis')),
                  DataColumn(label: Text('Aksi')),
                ],
                rows: _books.map(
                  (book) => DataRow(cells: [
                      DataCell(Text(book.name)),
                      DataCell(Text(book.publicationYear)),
                      DataCell(Text(book.author)),
                      DataCell(Row(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pushNamed(
                                context,
                                '/book/update',
                                arguments: UpdateUserArgument(
                                  hashid: book.hashid
                                )
                              );
                            },
                            splashColor: Colors.yellow.shade800,
                            child: Container(
                              width: 35.0,
                              height: 35.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.yellow.shade700, width: 2.0),
                              ),
                              child: const Icon(Icons.edit_note, color: Color(0xFFFBC02D)),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          InkWell(
                            onTap: (){
                              showDialog(
                                context: context, 
                                builder: (BuildContext context) {
                                  return Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      height: MediaQuery.of(context).size.height * 0.35,
                                      padding: const EdgeInsets.all(25.0),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('Delete?', style: TextStyle(fontSize: 20.0, color: Colors.black87)),
                                          const SizedBox(height: 15.0),
                                          const Icon(Icons.delete, size: 50.0, color: Colors.red),
                                          const SizedBox(height: 15.0),
                                          const Text('Anda yakin ingin menghapus data?', textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0, color: Colors.black87)),
                                          const SizedBox(height: 10.0),
                                          Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                RaisedButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  splashColor: Colors.grey,
                                                  child: const Text('Cancel'),
                                                ),
                                                const SizedBox(width: 10.0),
                                                RaisedButton(
                                                  onPressed: (){
                                                    _deleteData(context, book.hashid);
                                                  },
                                                  splashColor: Colors.red.shade900,
                                                  color: Colors.red,
                                                  child: const Text('Yes, delete', style: TextStyle(color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                  );
                                }
                              );
                            },
                            splashColor: Colors.red.shade900,
                            child: Container(
                              width: 35.0,
                              height: 35.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.red.shade700, width: 2.0),
                              ),
                              child: const Icon(Icons.delete_forever, color: Colors.red),
                            ),
                          ),
                        ],
                      )),
                    ]),
                ).toList(),
                border: TableBorder.all(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _deleteData(BuildContext context, String hashid) async {
    Navigator.pop(context);
    final res = await BookApi.delete(hashid);

    if(res.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(res.body);
      
      Future.delayed(const Duration(milliseconds: 200)).then((_) {
        _showToast(context, 'danger', data['message']);
      });
      _getBooks();
    } else {
      Map<String, dynamic> data = jsonDecode(res.body);
      
      Future.delayed(const Duration(milliseconds: 200)).then((_) {
        _showToast(context, 'danger', data['message']);
      });
    }
  }

  dynamic _showToast(BuildContext context, String type, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(type == 'success' ? Icons.check_circle_outline_outlined : Icons.close_outlined, color: type == 'success' ? const Color(0xFF2E7D32) : Colors.red.shade900),
          const SizedBox(width: 5.0),
          SizedBox(
            width: MediaQuery.of(context).size.width - 80,
            child: Text(message),
          )
        ],
      )
    ));
  }
}