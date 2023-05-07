import 'package:flutter/material.dart';
import 'NoteListScreen.dart';

class DeletedNotesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> notes;

  const DeletedNotesScreen({Key? key, required this.notes}) : super(key: key);

  @override
  _DeletedNotesScreenState createState() => _DeletedNotesScreenState();
}

class _DeletedNotesScreenState extends State<DeletedNotesScreen> {
  List<int> _deletedNoteIndexes = [];

  @override
  void initState() {
    super.initState();
    List<Map<String, dynamic>> deletedNotes = widget.notes;
    _deletedNoteIndexes = List.generate(deletedNotes.length, (index) => index);

    if (_deletedNoteIndexes.isEmpty) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deleted Notes'),
      ),
      body: ListView.builder(
        itemCount: _deletedNoteIndexes.length,
        itemBuilder: (context, index) {
          final noteIndex = _deletedNoteIndexes[index];
          final note = widget.notes[noteIndex];
          return ListTile(
            title: Text(note['title']),
            subtitle: Text(note['content']),
            onTap: () {
              Navigator.pushNamed(context, '/note_detail',
                  arguments: noteIndex);
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _restoreNoteDialog(context, noteIndex);
              },
            ),
          );
        },
      ),
    );
  }

  void _restoreNoteDialog(BuildContext context, int noteIndex) {
    final note = widget.notes[noteIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Completely'),
        content: Text('Do you want to delete completely this note?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restoreNote(noteIndex);
            },
            child: Text('Sure'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _restoreNote(int noteIndex) {
    setState(() {
      final note = widget.notes[noteIndex];
      note['deleted'] = false;
      _deletedNoteIndexes.remove(noteIndex);
    });
  }
}
