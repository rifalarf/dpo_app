// lib/user_detail_page.dart
import 'package:flutter/material.dart';
import 'package:app_user/models/user.dart';
import 'package:app_user/services/api_service.dart';

class UserDetailPage extends StatelessWidget {
  final int userId;

  UserDetailPage({required this.userId});

  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pelaku'),
      ),
      body: FutureBuilder<User>(
        future: apiService.fetchUserById(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.avatar),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      '${user.firstName} ${user.lastName}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Divider(),
                  SizedBox(height: 16),
                  Text(
                    'Informasi Pribadi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'ID: ${user.id}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  // Tambahkan lebih banyak informasi pribadi di sini
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
