import 'package:flutter/material.dart';
import 'package:short_uuids/short_uuids.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';

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
  late TextEditingController _dateController;

  DateTime _selectedDate = DateTime.now();
  String? _attachment;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _content = TextEditingController();
    _dateController = TextEditingController();

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
    _note!['dueDate'] = '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
    Navigator.pop(context, _note);
  }

  Future<void> _selectAttachment() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      final fileName = file.name;
      final filePath = file.path;
      final fileType = lookupMimeType(fileName);
      // Save the file to a cloud storage service, e.g. Firebase Storage.
      // ...
      setState(() {
        _attachment = fileName;
      });
    }
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
            GestureDetector(
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(2000, 1, 1),
                  maxTime: DateTime(2030, 12, 31),
                  onConfirm: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  currentTime: _selectedDate,
                  locale: LocaleType.en,
                );
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Text('Set due'),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Color.fromARGB(255, 166, 33, 243),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: _selectAttachment,
                  ),
                  if (_attachment != null)
                    Text(
                      _attachment!,
                      style: TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20,),
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
