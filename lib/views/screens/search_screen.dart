import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/search_controller.dart'
    as search_controller;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final search_controller.SearchController _searchController;

  @override
  void initState() {
    super.initState();
    _initAllControllers();
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  void _initAllControllers() {
    _searchController = Get.put(search_controller.SearchController());
  }

  void _disposeAllControllers() {
    // _searchController.dispose();
  }

  void _searchForUsers(String value) => _searchController.searchUsers(value);

  bool _isSearchedUsersEmpty() => _searchController.searchedUsers.isEmpty;

  void _navigateToProfileScreen(String userUid) => Navigator.pushNamed(
        context,
        '/profile_screen',
        arguments: userUid,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: SizedBox.shrink(),
        ),
        title: TextFormField(
          onFieldSubmitted: _searchForUsers,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      body: Obx(
        () {
          return ListView.builder(
            itemCount: _searchController.searchedUsers.length,
            itemBuilder: (context, index) {
              final user = _searchController.searchedUsers[index];

              if (index == 0) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    ListTile(
                      onTap: () => _navigateToProfileScreen(user.uid),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePhoto),
                      ),
                      title: Text(user.username),
                    ),
                  ],
                );
              }

              return ListTile(
                onTap: () => _navigateToProfileScreen(user.uid),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePhoto),
                ),
                title: Text(user.username),
              );
            },
          );
        },
      ),
    );
  }
}
