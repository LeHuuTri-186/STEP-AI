import 'package:flutter/material.dart';

import '../pages/emailPage.dart';

class HistoryDrawer extends StatelessWidget {
  TextEditingController searchController = TextEditingController();
  HistoryDrawer({super.key});

  void onSearchTextChanged() {}

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: [
      //Logo and App Name
      DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.deblur,
                  color: Colors.white,
                  size: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'STEP AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            // Search Bar
            SizedBox(
              height: 40,
              child: SearchBar(
                controller: searchController,
                onTap: onSearchTextChanged,
                leading: const Icon(Icons.search),
                hintText: 'Search...',
              ),
            ),
          ],
        ),
      ),

      // Expanded ListView for Bots and Histories
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // List of BOTs
              ExpansionTile(
                title: const Text('BOTs'),
                children: <Widget>[
                  ListTile(
                      title: const Text('Math BOT'),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  ListTile(
                      title: const Text('English BOT'),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  ListTile(
                      title: const Text('Email BOT'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmailPage()),
                        );
                      }),
                ],
              ),

              // Histories
              const Text(
                'Histories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Histories
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(title: Text('History $index'), onTap: () {});
                },
              ),
            ],
          ),
        ),
      ),

      //Account
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: const Icon(Icons.account_circle),
          title: const Text('Account'),
          onTap: () {},
        ),
      ),
    ]));
  }
}
