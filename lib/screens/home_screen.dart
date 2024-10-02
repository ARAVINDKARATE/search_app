import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool showLogo = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final filteredUsers = userProvider.getFilteredUsers(_searchQuery);

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          if (_searchQuery.isEmpty) {
            setState(() {
              showLogo = true;
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFD7D7EA),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFD7D7EA),
                          width: 2,
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
                          showLogo = false;
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
                const SizedBox(height: 40),
                if (userProvider.isLoading)
                  const Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Syncing User Data With FireBase....")
                    ],
                  )),
                if (!userProvider.isLoading && _searchQuery.isNotEmpty)
                  Expanded(
                    child: filteredUsers.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 51),
                                child: Image.asset(
                                  "assets/images/no_result.png",
                                  width: 249,
                                  height: 292,
                                ),
                              ),
                              const Text(
                                "No Results\n    Found",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF999999)),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                                child: Container(
                                  width: 240,
                                  height: 230,
                                  padding: const EdgeInsets.all(
                                    16.0,
                                  ),
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
                                      const SizedBox(
                                        height: 53,
                                        width: 53,
                                        child: CircleAvatar(
                                          backgroundImage: AssetImage('assets/images/profile.png'),
                                          radius: 32,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${user.first_name} ${user.last_name}',
                                            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 11,
                                                color: Color(0xFF425763),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                user.city,
                                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Color(0xFF425763)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 28),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.phone_rounded, size: 12),
                                                  const SizedBox(width: 2),
                                                  Text(user.contact_number, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF000000))),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              const Text('Available on phone', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Color(0xFFAFAFAF))),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 35,
                                            width: 120,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _showDetailsDialog(user.first_name, user.last_name, user.city, user.contact_number, "assets/images/profile.png");
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                backgroundColor: Colors.black,
                                              ),
                                              child: const Text(
                                                'Fetch Details',
                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFFFAFAFA)),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
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

  void _showDetailsDialog(String firstname, String lastname, String location, String contact, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: 299,
            height: 447,
            padding: const EdgeInsets.only(top: 22.22, left: 22.22, right: 0, bottom: 0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7.41),
                topRight: Radius.zero,
                bottomRight: Radius.zero,
                bottomLeft: Radius.zero,
              ),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Fetch Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        )),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const Text(
                  'Here are the details of following employee',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.96,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                    color: Color(0xFF71717A),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Text('Name: $firstname $lastname',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.96,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: Color(0xFF09090B),
                    )),
                Text('Location: $location',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.96,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: Color(0xFF09090B),
                    )),
                Text('Contact Number: $contact',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.96,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: Color(0xFF09090B),
                    )),
                const SizedBox(height: 14.81),
                const Text('Profile Image:',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.96,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: Color(0xFF09090B),
                    )),
                const SizedBox(
                  height: 14,
                ),
                Image.asset(imagePath, height: 192, width: 192, fit: BoxFit.cover),
              ],
            ),
          ),
        );
      },
    );
  }
}
