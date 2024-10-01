import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Girman Technologies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.web),
            onPressed: () {
              // Handle redirect to website via web view
            },
          ),
          IconButton(
            icon: const Icon(Icons.link_outlined),
            onPressed: () {
              // Handle redirect to LinkedIn via web view
            },
          ),
          IconButton(
            icon: const Icon(Icons.contact_mail),
            onPressed: () {
              // Handle open email
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                Provider.of<UserProvider>(context, listen: false).searchUsers(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  if (userProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: userProvider.users.length,
                    itemBuilder: (context, index) {
                      final user = userProvider.users[index];
                      return Card(
                        child: ListTile(
                          title: Text('${user.firstName} ${user.lastName}'),
                          subtitle: Text(user.city),
                          trailing: IconButton(
                            icon: const Icon(Icons.info),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('User Details'),
                                    content: Text('Phone: ${user.contactNumber}'),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
