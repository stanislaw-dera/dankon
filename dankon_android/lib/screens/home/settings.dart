import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout),
            onTap: () {

            },
          ),
          ListTile(
            title: Text('About the app'),
            leading: Icon(Icons.info),
            onTap: () {
              showAboutDialog(context: context, applicationIcon: CircleAvatar(backgroundColor: Theme.of(context).primaryColor, backgroundImage: AssetImage('assets/app_logo.png')), applicationVersion: '2.0.0');
            },
          )
        ],
      ),
    );
  }
}
