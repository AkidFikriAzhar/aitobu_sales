import 'package:flutter/material.dart';

class ViewCup extends StatelessWidget {
  const ViewCup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cup Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_drink, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 10),
              Text(
                'Current Cup',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20),
              ),
              Text(
                '392',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: () {},
                label: const Text('Add Cup'),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
