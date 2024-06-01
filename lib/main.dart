// lib/main.dart
import 'package:flutter/material.dart';
import 'package:app_user/models/user.dart';
import 'package:app_user/services/api_service.dart';
import 'package:app_user/pages/user_detail_page.dart';
import 'package:app_user/pages/add_user_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Pencarian Orang',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListPage(),
    );
  }
}

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ApiService apiService = ApiService();
  late Future<List<User>> futureUsers;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    futureUsers = apiService.fetchUsers();
    futureUsers.then((loadedUsers) {
      setState(() {
        users = loadedUsers;
      });
    });
  }

  void _addUser(User user) {
    setState(() {
      users.add(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pencarian Orang'),
      ),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final users = snapshot.data ?? [];
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.firstName + ' ' + user.lastName),
                  subtitle: Text(user.email),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailPage(userId: user.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddUserPage(onUserAdded: _addUser)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
