import 'package:flutter/material.dart';
import 'package:note_app/Screens/FontSettingsData.dart';
import 'package:provider/provider.dart';

class TextSizeAndFontSettings extends StatefulWidget {
  @override
  _TextSizeAndFontSettingsState createState() =>
      _TextSizeAndFontSettingsState();
}

class _TextSizeAndFontSettingsState extends State<TextSizeAndFontSettings> {
  final List<String> fonts = [
    'Roboto',
    'Arial',
    'Verdana',
    'Darumadrop One',
    'Poppins',
  ];

  void showUpdateSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Text Size and Font Settings'),
          ),
          body: Consumer<FontSettingsData>(
            builder: (context, fontSettingsData, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Font:'),
                  ),
                  DropdownButton<String>(
                    value: fontSettingsData.selectedFont,
                    onChanged: (newValue) {
                      fontSettingsData.updateFont(newValue ?? 'Roboto');
                      showUpdateSnackBar(context, 'Font updated!');
                    },
                    items: fonts.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Font Size:'),
                  ),
                  Slider(
                    value: fontSettingsData.selectedFontSize,
                    min: 10,
                    max: 30,
                    divisions: 4, // Change to a smaller value
                    onChanged: (newValue) {
                      fontSettingsData.updateFontSize(newValue);
                      showUpdateSnackBar(context, 'Font size updated!');
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Selected Font Size: ${fontSettingsData.selectedFontSize}'), // Display the current font size
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
