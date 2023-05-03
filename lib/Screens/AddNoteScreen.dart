import 'package:flutter/material.dart';
import 'package:short_uuids/short_uuids.dart';

class AddNoteScreen extends StatefulWidget {
  Map<String, dynamic>? note;
  AddNoteScreen({this.note, super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late Map<String, dynamic>? _note;
  late TextEditingController _title;
  late TextEditingController _content;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _content = TextEditingController();

    _note = widget.note;
    _title.text = _note?['title'] ?? '';
    _content.text = _note?['content'] ?? '';
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  bool get isNewNote {
    return _note == null;
  }

  void _createOrUpdateNote() {
    _note ??= {'id': ShortUuid().generate()};
    _note!['title'] = _title.text;
    _note!['content'] = _content.text;
    Navigator.pop(context, _note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNewNote ? 'Create New Note' : 'Edit a Note'),
        actions: [IconButton(onPressed: () {
          Row(children: [
           
          ],);
        }, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _title,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: TextFormField(
                controller: _content,
                maxLines: 50,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _createOrUpdateNote,
              child: Text(isNewNote ? 'Save Note' : 'Save all changes'),
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
            )
          ],
        ),
      ),
    );
  }
}
