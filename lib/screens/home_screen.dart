import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showLogo = true;
  String _searchQuery = ''; // Track the search query

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final filteredUsers = userProvider.getFilteredUsers(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 66,
        shadowColor: Colors.black,
        elevation: 5,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/logo.png",
            width: 102,
            height: 48,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 17, top: 17, right: 33, left: 12),
            child: PopupMenuButton<int>(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
                size: 24,
              ),
              offset: const Offset(0, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                userProvider.handleMenuOption(value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: -1,
                  enabled: false,
                  child: RichText(
                    text: const TextSpan(
                      text: 'SEARCH',
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const PopupMenuItem(
                  value: 0,
                  child: Text('WEBSITE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      )),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text('LINKEDIN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      )),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text('CONTACT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // When tapping outside of the TextField
          if (_searchQuery.isEmpty) {
            setState(() {
              showLogo = true; // Show logo again
            });
          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Conditionally display the logo based on the search query
                if (showLogo && _searchQuery.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 109, bottom: 20),
                    child: Image.asset(
                      "assets/images/title_logo.png",
                      height: 65,
                      width: 323,
                    ),
                  ),
                SizedBox(
                  height: 51,
                  width: 338,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFD7D7EA),
                          width: 1,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                    ),
                    onTap: () {
                      if (_searchQuery.isEmpty) {
                        setState(() {
                          showLogo = false; // Hide logo when tapping the search bar
                        });
                      }
                    },
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                        showLogo = query.isEmpty ? true : false;
                      });
                      userProvider.searchUsers(query);
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Loading indicator when users are being fetched
                if (userProvider.isLoading) const Center(child: CircularProgressIndicator()),

                // Display search results using ListView.builder if search query is not empty
                if (!userProvider.isLoading && _searchQuery.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(user.firstName),
                                      radius: 32,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${user.firstName} ${user.lastName}',
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on, size: 16),
                                            const SizedBox(width: 4),
                                            Text(
                                              user.city,
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.phone, size: 16),
                                            const SizedBox(width: 8),
                                            Text(user.contactNumber),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        const Text('Available on phone'),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Fetch details action (if required)
                                        // userProvider.fetchUserDetails(user.id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        backgroundColor: Colors.black, // Button color
                                      ),
                                      child: const Text('Fetch Details'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
