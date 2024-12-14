import 'package:aitobu_sales/component/caption_title.dart';
import 'package:aitobu_sales/controller/controller_profile.dart';
import 'package:aitobu_sales/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewProfile extends StatelessWidget {
  ViewProfile({super.key});

  final _controllerProfile = ControllerProfile();
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
              onTap: () {
                context.push(MyRouter.items);
              },
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
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator.adaptive(),
                            SizedBox(height: 10),
                            Text('Please wait...'),
                          ],
                        ),
                      );
                    });
                await _controllerProfile.logOut();
                // Navigator.pop(context);
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
