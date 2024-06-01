// lib/add_user_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_user/services/api_service.dart';
import 'package:app_user/models/user.dart';

class AddUserPage extends StatefulWidget {
  final Function(User) onUserAdded;

  AddUserPage({required this.onUserAdded});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah DPO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan nama';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('Form is valid, creating user...');
                    apiService
                        .createUser(_nameController.text, _emailController.text)
                        .then((response) {
                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');
                      if (response.statusCode == 201) {
                        final Map<String, dynamic> responseData =
                            json.decode(response.body);
                        final user = User(
                          id: int.parse(responseData['id']),
                          email: _emailController.text,
                          firstName: _nameController.text.split(' ').first,
                          lastName: _nameController.text.split(' ').length > 1
                              ? _nameController.text.split(' ').last
                              : '',
                          avatar:
                              'https://reqres.in/img/faces/1-image.jpg', // default avatar
                        );
                        widget.onUserAdded(user);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Berhasil')));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Gagal')));
                      }
                    }).catchError((error) {
                      print('Error: $error');
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Gagal')));
                    });
                  }
                },
                child: Text('Tambhkan orang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
