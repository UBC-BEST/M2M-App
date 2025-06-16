import 'package:flutter/material.dart';

class NameChange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Name Settings'),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Change Name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
              ),
              const Text(
                'Please note you can only change your name once every 90 days and your username once every 30 days',
                style: TextStyle(fontSize:16),
              ),
              const SizedBox(height: 20),

            // First Name Editing Box
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  labelStyle:
                      TextStyle(fontSize: 13, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 13,
                ),
                obscureText: false,
                cursorColor: Colors.black,
              ),
              const SizedBox(height: 10),

            // Last name editing box
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  labelStyle:
                      TextStyle(fontSize: 13, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 13,
                ),
                obscureText: false,
                cursorColor: Colors.black,
              ),
              const SizedBox(height:10),

            // Username editing box
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle:
                      TextStyle(fontSize: 13, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 13,
                ),
                obscureText: false,
                cursorColor: Colors.black,
              ),
              const SizedBox(height:10),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Logic to change the name goes here
                  Navigator.pop(context); // Go back after changing name
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
