import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'auth_provider_JRBV.dart';
import 'dart:convert';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      setState(() {
        _error = 'Not authenticated';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/users/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _users = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load users';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _getGenderText(String? genderCode) {
    switch (genderCode) {
      case 'M':
        return 'Male';
      case 'F':
        return 'Female';
      case 'O':
        return 'Other';
      case 'N':
        return 'Prefer not to say';
      default:
        return 'Not specified';
    }
  }

  Color _getGenderColor(String? genderCode) {
    switch (genderCode) {
      case 'M':
        return Colors.blue;
      case 'F':
        return Colors.pink;
      case 'O':
        return Colors.purple;
      case 'N':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUsers,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _users.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.people_outline, size: 48, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'No users found',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadUsers,
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadUsers,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _users.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                // Add user detail view functionality
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: _getGenderColor(user['gender'])
                                              .withOpacity(0.2),
                                          child: Icon(
                                            Icons.person,
                                            size: 20,
                                            color: _getGenderColor(user['gender']),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user['username'] ?? 'Unknown',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                user['email'] ?? 'No email',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: Colors.grey[600],
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        Chip(
                                          avatar: Icon(
                                            Icons.transgender,
                                            size: 16,
                                            color: _getGenderColor(user['gender']),
                                          ),
                                          label: Text(
                                            _getGenderText(user['gender']),
                                            style: TextStyle(
                                              color: _getGenderColor(user['gender']),
                                            ),
                                          ),
                                          backgroundColor: _getGenderColor(user['gender'])
                                              .withOpacity(0.1),
                                        ),
                                        if (user['birthday'] != null)
                                          Chip(
                                            avatar: const Icon(
                                              Icons.cake,
                                              size: 16,
                                              color: Colors.orange,
                                            ),
                                            label: Text(
                                              DateFormat('MMM dd').format(
                                                DateTime.tryParse(user['birthday'] ?? '') ??
                                                    DateTime(2000, 1, 1)),
                                              style: const TextStyle(
                                                color: Colors.orange,
                                              ),
                                            ),
                                            backgroundColor: Colors.orange.withOpacity(0.1),
                                          ),
                                        Chip(
                                          avatar: const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.green,
                                          ),
                                          label: Text(
                                            'Since ${user['registration_date'] != null ? DateFormat('yyyy').format(DateTime.tryParse(user['registration_date']) ?? DateTime(2000, 1, 1)) : 'Unknown'}',
                                            style: const TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                          backgroundColor: Colors.green.withOpacity(0.1),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}