import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/Screens/LabeledScreen.dart';
import 'AddNoteScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note_app/utils/ListNote.dart';
import 'package:note_app/Screens/SettingsPage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DeletedNotesScreen.dart';
import 'package:share/share.dart';

enum Actions { protect, delete, removePassNote, unlockNote, changeNotePass }

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredNotes = [];
  bool listView = true;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String username = '';
  late FocusNode myFocusNode;
  String password = "";
  String confirmPassword = "";
  String oldPass = "";
  bool validate = false;
  Offset _tapPos = Offset.zero;
  String selectedValue = 'Personal';
  var labelItems = ['Work', 'Personal', 'Family'];
  List<Map<String, dynamic>> deletedNotes = [];
  var _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    _getUserData();
    filteredNotes = notes;
  }

  void _getUserData() async {
    // Get the current user's data from Firestore
    final user = _auth.currentUser;
    final userData = await _firestore.collection('users').doc(user?.uid).get();
    setState(() {
      username = userData['username'];
    });
  }

  void _getTapPos(TapDownDetails tapPos) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPos = renderBox.globalToLocal(tapPos.globalPosition);
    });
  }

  void _showContextMenu(context, note, lock) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    final res = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPos.dx, _tapPos.dy, 10, 10),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: lock
            ? [
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete'),
                  ),
                ),
                PopupMenuItem(
                  value: 'label',
                  child: ListTile(
                    leading: Icon(Icons.label_outline),
                    title: Text('Label'),
                  ),
                ),
                PopupMenuItem(
                  value: 'RemovePass',
                  child: ListTile(
                    leading: Icon(Icons.remove),
                    title: Text('Remove password'),
                  ),
                ),
                PopupMenuItem(
                  value: 'ChangePass',
                  child: ListTile(
                    leading: Icon(Icons.change_circle),
                    title: Text('Change password'),
                  ),
                ),
                PopupMenuItem(
                  value: 'pinned',
                  child: ListTile(
                    leading: Icon(Icons.push_pin),
                    title: Text('Pin'),
                  ),
                ),
              ]
            : [
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete'),
                  ),
                ),
                PopupMenuItem(
                  value: 'label',
                  child: ListTile(
                    leading: Icon(Icons.label_outline),
                    title: Text('Label'),
                  ),
                ),
                PopupMenuItem(
                  value: 'setPass',
                  child: ListTile(
                    leading: Icon(Icons.password),
                    title: Text('Set Password'),
                  ),
                ),
                PopupMenuItem(
                  value: 'pinned',
                  child: ListTile(
                    leading: Icon(Icons.push_pin),
                    title: Text('Pin'),
                  ),
                ),
              ]);
    switch (res) {
      case 'delete':
        _onDelete(notes.indexOf(note), lock, Actions.delete);
        break;
      case 'label':
        _label(note);
        break;
      case 'setPass':
        _onProtect(note, lock, Actions.protect);
        break;
      case 'RemovePass':
        _onProtect(note, lock, Actions.removePassNote);
        break;
      case 'ChangePass':
        _onProtect(note, lock, Actions.changeNotePass);
        break;
      case 'pinned':
        setState(() {
          if (isPinned(note)) {
            note['pinned'] = false;
          } else {
            note['pinned'] = true;
            // Move the pinned note to the top of the list.
            notes.remove(note);
            notes.insert(0, note);
          }
          // Save the updated notes list to the database.
          // ...
        });
        break;
    }
  }

  void _label(note) async {
    showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
              builder: (ctx, setDialogState) => AlertDialog(
                title: Text('Choose label'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: labelItems
                      .map((e) => RadioListTile(
                          title: Text(e),
                          value: e,
                          groupValue: selectedValue,
                          onChanged: (v) {
                            setState(() {
                              setDialogState(() {
                                selectedValue = v!;
                              });
                            });
                          }))
                      .toList(),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        note['label'] = selectedValue;
                        Fluttertoast.showToast(
                            msg: "Note added to ${note['label']} label",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      },
                      child: Text('OK')),
                ],
              ),
            ));
  }

  bool isPinned(Map<String, dynamic> note) {
    return note['pinned'] ?? false;
  }

  void _handleSubmit(note, lock, action) {
    if (action == Actions.protect) {
      if (_key.currentState?.validate() ?? false) {
        _key.currentState?.save();
        note['password'] = confirmPassword;
        setState(() {
          note['lock'] = !lock;
        });
        Fluttertoast.showToast(
            msg: "Password set!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        print(note['lock']);
        _key.currentState?.reset();
        myFocusNode.requestFocus();
      } else {
        Fluttertoast.showToast(
            msg: "Failed to set, please check again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    if (action == Actions.removePassNote) {
      if (_key.currentState?.validate() ?? false) {
        _key.currentState?.save();
        print(password);
        if (password == note['password']) {
          note['password'] = '';
          setState(() {
            note['lock'] = !lock;
          });
          Fluttertoast.showToast(
              msg: "Password removed!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Wrong password!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        _key.currentState?.reset();
        myFocusNode.requestFocus();
      } else {
        Fluttertoast.showToast(
            msg: "Wrong password!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    if (action == Actions.unlockNote) {
      if (_key.currentState?.validate() ?? false) {
        _key.currentState?.save();
        if (password == note['password']) {
          createOrUpdate(note);
        } else {
          Fluttertoast.showToast(
              msg: "Wrong password!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        _key.currentState?.reset();
        myFocusNode.requestFocus();
      } else {
        Fluttertoast.showToast(
            msg: "Please enter the password field!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    if (action == Actions.changeNotePass) {
      if (_key.currentState?.validate() ?? false) {
        _key.currentState?.save();
        if (oldPass == note['password']) {
          note['password'] = confirmPassword;
          Fluttertoast.showToast(
              msg: "Password changed successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Wrong old password, check again!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        _key.currentState?.reset();
        myFocusNode.requestFocus();
      } else {
        Fluttertoast.showToast(
            msg: "Failed to change, please check again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    if (action == Actions.delete) {
      if (_key.currentState?.validate() ?? false) {
        _key.currentState?.save();
        if (password == note['password']) {
          setState(() {
            deletedNotes.add(note);
            notes.remove(note);
            Fluttertoast.showToast(
                msg: "Note deleted",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          });
        } else {
          Fluttertoast.showToast(
              msg: "Wrong password!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        _key.currentState?.reset();
        myFocusNode.requestFocus();
      } else {
        Fluttertoast.showToast(
            msg: "Please enter the password field!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  void _searchNotes(String query) {
    setState(() {
      filteredNotes = notes.where((note) {
        final titleLower = note['title'].toLowerCase();
        final contentLower = note['content'].toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            contentLower.contains(searchLower);
      }).toList();
    });
  }

  void filterNotes(String keyword) {
    setState(() {
      filteredNotes = notes
          .where((note) =>
              note['title']
                  .toString()
                  .toLowerCase()
                  .contains(keyword.toLowerCase()) ||
              note['content']
                  .toString()
                  .toLowerCase()
                  .contains(keyword.toLowerCase()))
          .toList();
    });
  }

  void createOrUpdate([Map<String, dynamic>? note]) async {
    String title = note?['title'] ?? '';
    String content = note?['content'] ?? '';
    String dueDate = note?['dueDate'] ?? '';

    var data = await Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => AddNoteScreen(note: note)));

    if (data == null) return;

    int index = notes.indexWhere((element) => element['id'] == data['id']);
    if (index >= 0) {
      if (data['title'] != title ||
          data['content'] != content ||
          data['dueDate'] != dueDate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Note has been updated'),
          ),
        );
        setState(() {
          notes[index] = data;
        });
      }
    } else {
      setState(() {
        notes.insert(0, Map<String, dynamic>.from(data));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A new note has been created'),
        ),
      );
    }
  }

  void _onProtect(note, lock, Actions action) {
    if (action == Actions.protect) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ct) => AlertDialog(
                insetPadding: EdgeInsets.all(20.0),
                contentPadding: EdgeInsets.all(10.0),
                title: Text('Set password'),
                content: Form(
                  key: _key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: myFocusNode,
                        onChanged: (v) {
                          password = v;
                        },
                        onSaved: (v) {
                          password = v ?? '';
                        },
                        validator: (v) {
                          var passNonNullValue = v ?? "";
                          if (passNonNullValue.isEmpty) {
                            return ("Password is required");
                          } else if (passNonNullValue.length < 6) {
                            return ("Password Must be more than 5 characters");
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSaved: (v) {
                          confirmPassword = v ?? '';
                        },
                        validator: (v) {
                          if (v == null ||
                              v.isEmpty ||
                              v.length < 3 ||
                              v != password) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Confirm password",
                          hintText: "Confirm password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_4),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _handleSubmit(note, lock, action);
                        Navigator.pop(context);
                      },
                      child: Text('Set')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel')),
                ],
              ));
    } else if (action == Actions.removePassNote) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ct) => AlertDialog(
                insetPadding: EdgeInsets.all(20.0),
                contentPadding: EdgeInsets.all(10.0),
                title: Text('Enter password'),
                content: Form(
                  key: _key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: myFocusNode,
                        onChanged: (v) {
                          password = v;
                        },
                        onSaved: (v) {
                          password = v ?? '';
                        },
                        validator: (v) {
                          var passNonNullValue = v ?? "";
                          if (passNonNullValue.isEmpty) {
                            return ("Password is required");
                          } else if (passNonNullValue.length < 6) {
                            return ("Password Must be more than 5 characters");
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _handleSubmit(note, lock, action);
                        Navigator.pop(context);
                      },
                      child: Text('OK')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel')),
                ],
              ));
    } else if (action == Actions.unlockNote) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ct) => AlertDialog(
                insetPadding: EdgeInsets.all(20.0),
                contentPadding: EdgeInsets.all(10.0),
                title: Text('Enter password'),
                content: Form(
                  key: _key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: myFocusNode,
                        onChanged: (v) {
                          password = v;
                        },
                        onSaved: (v) {
                          password = v ?? '';
                        },
                        validator: (v) {
                          var passNonNullValue = v ?? "";
                          if (passNonNullValue.isEmpty) {
                            return ("Password is required");
                          } else if (passNonNullValue.length < 6) {
                            return ("Password Must be more than 5 characters");
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleSubmit(note, lock, action);
                      },
                      child: Text('OK')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel')),
                ],
              ));
    } else if (action == Actions.changeNotePass) {
      if (note['password'] == '') {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ct) => AlertDialog(
            title: Text('Warning'),
            content: Text('Please set password first!'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          ),
        );
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ct) => AlertDialog(
                  insetPadding: EdgeInsets.all(20.0),
                  contentPadding: EdgeInsets.all(10.0),
                  title: Text('Set password'),
                  content: Form(
                    key: _key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          focusNode: myFocusNode,
                          onSaved: (v) {
                            oldPass = v ?? '';
                          },
                          validator: (v) {
                            var passNonNullValue = v ?? "";
                            if (passNonNullValue.isEmpty) {
                              return ("Password is required");
                            } else if (passNonNullValue.length < 6) {
                              return ("Password Must be more than 5 characters");
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Old password",
                            hintText: "Old password",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.password),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (v) {
                            password = v;
                          },
                          onSaved: (v) {
                            password = v ?? '';
                          },
                          validator: (v) {
                            var passNonNullValue = v ?? "";
                            if (passNonNullValue.isEmpty) {
                              return ("Password is required");
                            } else if (passNonNullValue.length < 6) {
                              return ("Password Must be more than 5 characters");
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "New password",
                            hintText: "New password",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.password),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSaved: (v) {
                            confirmPassword = v ?? '';
                          },
                          validator: (v) {
                            if (v == null ||
                                v.isEmpty ||
                                v.length < 3 ||
                                v != password) {
                              return 'Password does not match';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "Confirm password",
                            hintText: "Confirm password",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          _handleSubmit(note, lock, action);
                          Navigator.pop(context);
                        },
                        child: Text('Set')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')),
                  ],
                ));
      }
    }
  }

  void _navigateToDeletedNotesScreen() {
    List<Map<String, dynamic>> deletedNotes =
        notes.where((note) => note['deleted'] == true).toList();
    Navigator.pushNamed(context, '/deleted_notes', arguments: deletedNotes);
  }

  void _onDelete(int index, lock, Actions action) {
    if (notes[index]['password'] != '') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ct) => AlertDialog(
                insetPadding: EdgeInsets.all(20.0),
                contentPadding: EdgeInsets.all(10.0),
                title: Text('Enter password to delete'),
                content: Form(
                  key: _key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: myFocusNode,
                        onSaved: (v) {
                          password = v ?? '';
                        },
                        validator: (v) {
                          var passNonNullValue = v ?? "";
                          if (passNonNullValue.isEmpty) {
                            return ("Password is required");
                          } else if (passNonNullValue.length < 6) {
                            return ("Password Must be more than 5 characters");
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.password),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleSubmit(notes[index], lock, action);
                      },
                      child: Text('OK')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel')),
                ],
              ));
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ct) => AlertDialog(
                title: Text('Delete?'),
                content: Text('Are you sure want to delete?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          deletedNotes.add(notes[index]);
                          notes.removeAt(index);
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Yes')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No')),
                ],
              ));
    }
  }

  Widget _noteGridItem(note) {
    bool lock = note['lock'] ?? false;
    return GestureDetector(
      onTap: () {
        lock
            ? _onProtect(note, lock, Actions.unlockNote)
            : createOrUpdate(note);
      },
      onTapDown: (position) {
        _getTapPos(position);
      },
      onLongPress: () {
        _showContextMenu(context, note, lock);
      },
      child: Card(
        color: lock ? Colors.lightGreen : Colors.yellow.shade300,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(children: [
            Text(
              note['title'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.deepOrange.shade900,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Due: ${note['dueDate']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              note['content'],
              maxLines: 5,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
      ),
    );
  }

  Widget _noteListItem(note) {
    bool lock = note['lock'] ?? false;
    return Slidable(
      key: Key(note['title']),
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          lock
              ? SlidableAction(
                  backgroundColor: Colors.lightBlue,
                  icon: Icons.lock,
                  label: 'Remove password',
                  onPressed: (context) =>
                      _onProtect(note, lock, Actions.removePassNote))
              : SlidableAction(
                  backgroundColor: Colors.lightBlue,
                  icon: Icons.lock,
                  label: 'Set password',
                  onPressed: (context) =>
                      _onProtect(note, lock, Actions.protect)),
          SlidableAction(
              backgroundColor: Colors.lightGreenAccent,
              icon: Icons.label_outline,
              label: 'Label',
              onPressed: (context) => _label(note)),
          SlidableAction(
              backgroundColor: Color.fromARGB(255, 248, 151, 5),
              icon:
                  isPinned(note) ? (Icons.push_pin) : (Icons.push_pin_outlined),
              label: 'Pin',
              onPressed: (context) {
                setState(() {
                  if (isPinned(note)) {
                    note['pinned'] = false;
                  } else {
                    note['pinned'] = true;
                    notes.remove(note);
                    notes.insert(0, note);
                  }
                });
              }),
          SlidableAction(
              backgroundColor: Color.fromARGB(255, 255, 59, 213),
              icon: Icons.share,
              label: 'Share',
              onPressed: (context) =>
                  shareNote(context, note['title'], note['content'])),
        ],
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.pinkAccent,
            icon: Icons.change_circle,
            label: 'Change password',
            onPressed: (context) =>
                _onProtect(note, lock, Actions.changeNotePass),
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (context) =>
                _onDelete(notes.indexOf(note), lock, Actions.delete),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.newspaper),
        onTap: () {
          lock
              ? _onProtect(note, lock, Actions.unlockNote)
              : createOrUpdate(note);
        },
        trailing: lock ? Icon(Icons.lock) : null,
        title: Row(
          children: [
            Text(
              note['title'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Color.fromARGB(255, 133, 34, 4),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              'Due: ${note['dueDate']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: Text(
          note['content'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  void shareNote(BuildContext context, String title, String content) {
    final text = '$title\n\n$content';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createOrUpdate();
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Note Management'),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                if (value == 'changeview') {
                  setState(() {
                    listView = !listView;
                  });
                } else if (value == 'logout') {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ct) => AlertDialog(
                            title: Text('Logout?'),
                            content: Text('Are you sure want to logout?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.popUntil(
                                        context, ModalRoute.withName('/'));
                                  },
                                  child: Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No')),
                            ],
                          ));
                } else if (value == 'View_label') {
                  showModalBottomSheet(
                      context: context,
                      builder: (ctx) => ListView(
                            shrinkWrap: true,
                            children: labelItems
                                .map((e) => ListTile(
                                      title: Text(
                                        e,
                                        textAlign: TextAlign.center,
                                      ),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) => LabeledScreen(
                                                    listview: listView,
                                                    labelItems: labelItems,
                                                    notes: notes,
                                                    label: e)));
                                      },
                                    ))
                                .toList(),
                          ));
                } else if (value == 'trash_can') {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeletedNotesScreen(
                          notes: deletedNotes,
                        ),
                      ),
                    );
                  });
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'username',
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(username),
                  ),
                ),
                PopupMenuItem(
                  value: 'changeview',
                  child: ListTile(
                    leading: Icon(listView ? Icons.grid_view : Icons.list),
                    title: Text(listView ? 'Grid view' : 'List view'),
                  ),
                ),
                PopupMenuItem(
                    value: 'View_label',
                    child: ListTile(
                      leading: Icon(Icons.label_important_outlined),
                      title: Text('View labeled items'),
                    )),
                PopupMenuItem(
                    value: 'trash_can',
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Trash can'),
                    )),
                PopupMenuItem(
                  value: 'settings',
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the popup menu
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => SettingsPage(),
                        ),
                      );
                    },
                    title: Text('Settings'),
                  ),
                ),
                PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    )),
              ],
            )
          ],
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) => filterNotes(value),
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(listView ? 0 : 8),
                child: listView
                    ? SlidableAutoCloseBehavior(
                        closeWhenOpened: true,
                        child: ListView.separated(
                            itemBuilder: (ctx, idx) =>
                                _noteListItem(filteredNotes[idx]),
                            separatorBuilder: (ctx, idx) => Divider(),
                            itemCount: filteredNotes.length),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (ctx, idx) =>
                            _noteGridItem(filteredNotes[idx]),
                        itemCount: filteredNotes.length,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
