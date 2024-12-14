import 'package:aitobu_sales/component/caption_title.dart';
import 'package:flutter/material.dart';

class ViewProfile extends StatelessWidget {
  const ViewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aitobu'),
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            child: Image.asset('assets/images/aitobu.png'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('v0.1'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const CaptionTitle(title: 'Product'),
            ListTile(
              title: const Text('Items'),
              subtitle: const Text('Manage all of your items product'),
              leading: const Icon(Icons.inventory),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Sections'),
              subtitle: const Text('Products category (eg: Foods, Drinks..)'),
              leading: const Icon(Icons.category),
              onTap: () {},
            ),
            const SizedBox(height: 10),
            const CaptionTitle(title: 'Settings'),
            ListTile(
              title: const Text('Log Out'),
              subtitle: const Text('Log out active season'),
              leading: const Icon(Icons.logout),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
