import 'package:flutter/material.dart';
import 'package:note_app/Screens/ChangePassword_Screen.dart';
import 'package:note_app/Screens/TextSizeAndFontSettings_screen.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('Set Text Size and Font for New Notes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TextSizeAndFontSettings()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Set automatic deletion time for notes in the trash'),
            onTap: () {
              // Navigate to Auto-Delete Settings Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification sound'),
            onTap: () {
              // Navigate to Notification Sound Settings Screen
            },
          ),
        ],
      ),
    );
  }
}
