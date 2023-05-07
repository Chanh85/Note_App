import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'SettingsPage_screen.dart';

enum Actions{protect,delete}

class LabeledScreen extends StatefulWidget {
  bool listview;
  List<String> labelItems;
  String label;
  List<Map<String, dynamic>> notes;
  LabeledScreen({Key? key, required this.listview, required this.labelItems, required this.notes, required this.username ,required this.label}) : super(key: key);
  String username;

  @override
  State<LabeledScreen> createState() => _LabeledScreenState();
}

class _LabeledScreenState extends State<LabeledScreen> {

  late bool _listView;
  late List<String> _labelItems;
  late String _label;
  late String _username;
  late List<Map<String, dynamic>> _notes;
  final List<Map<String,dynamic>> _workLabeledList = [];
  final List<Map<String,dynamic>> _personalLabeledList = [];
  final List<Map<String,dynamic>> _familyLabeledList = [];
  List<Map<String, dynamic>> filteredNotes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listView = widget.listview;
    _labelItems = widget.labelItems;
    _notes = widget.notes;
    _label = widget.label;
    _username = widget.username;
    if(_label == 'Work')
    {
      if(_workLabeledList.isEmpty)
      {
        for(var i = 0; i < _notes.length; i++)
        {
          if(_notes[i]['label'] == 'Work')
          {
            _workLabeledList.add(_notes[i]);
            filteredNotes = _workLabeledList;
          }

        }
      }
      else{
        filteredNotes = _workLabeledList;
      }
    }
    else if(_label == 'Family')
    {
      if(_familyLabeledList.isEmpty)
      {
        for(var i = 0; i < _notes.length; i++)
        {
          if(_notes[i]['label'] == 'Family')
          {
            _familyLabeledList.add(_notes[i]);
            filteredNotes = _familyLabeledList;
          }

        }
      }
      else{
        filteredNotes = _familyLabeledList;
      }
    }
    else if(_label == 'Personal')
    {
      if(_personalLabeledList.isEmpty)
      {
        for(var i = 0; i < _notes.length; i++)
        {
          if(_notes[i]['label'] == 'Personal')
          {
            _personalLabeledList.add(_notes[i]);
            filteredNotes = _personalLabeledList;
          }
        }
      }
      else{
        filteredNotes = _personalLabeledList;
      }
    }
  }


  void filterNotes(String keyword, String label) {
    if(label == 'Work')
      {
        setState(() {
          filteredNotes = _workLabeledList
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
   else if(label == 'Personal')
    {
      setState(() {
        filteredNotes = _personalLabeledList
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
    else if(label == 'Family')
    {
      setState(() {
        filteredNotes = _familyLabeledList
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
  }

  Widget _noteGridItem(note) {
    bool lock = note['lock'] ?? false;
    return GestureDetector(
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
            SizedBox(height: 3,),
            note['label'] != ''?
            Text(
              'Label: ${note['label']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
              ),
            ): SizedBox(height: 1,),
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
    bool lock = note['lock']?? false;
        return ListTile(
            leading: Icon(Icons.note_rounded),
            onTap: () {
            },
            trailing: lock? Icon(Icons.lock): null,
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
                SizedBox(width: 15,),
                Text(
                  'Due: ${note['dueDate']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                note['label'] != ''?
                Text(
                  'Label: ${note['label']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ): SizedBox(width: 1,),
              ],
            ),
            subtitle: Text(
              note['content'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Management'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if(value == 'changeview'){
                setState(() {
                  _listView = !_listView;
                });
              }
              else if(value == 'logout')
              {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ct) => AlertDialog(
                      title: Text('Logout?'),
                      content: Text('Are you sure want to logout?'),
                      actions: [
                        TextButton(
                            onPressed: (){
                              Navigator.popUntil(context, ModalRoute.withName('/'));
                            },
                            child: Text('Yes')
                        ),
                        TextButton(
                            onPressed: (){Navigator.pop(context);},
                            child: Text('No')
                        ),
                      ],
                    ));
              }
              else if(value == 'View_label')
              {
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) =>ListView(
                      shrinkWrap: true,
                      children: _labelItems.map((e) => ListTile(
                        title: Text(e, textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                        onTap: (){
                          setState(() {
                            _label = e;
                          });
                          if(_label == 'Work')
                          {
                            if(_workLabeledList.isEmpty)
                            {
                              for(var i = 0; i < _notes.length; i++)
                              {
                                if(_notes[i]['label'] == 'Work')
                                {
                                  _workLabeledList.add(_notes[i]);
                                  filteredNotes = _workLabeledList;
                                }
                              }
                              if(filteredNotes.isEmpty)
                              {
                                filteredNotes = [];
                              }
                            }
                            else{
                              filteredNotes = _workLabeledList;
                            }
                          }
                          else if(_label == 'Family')
                          {
                            if(_familyLabeledList.isEmpty)
                            {
                              for(var i = 0; i < _notes.length; i++)
                              {
                                if(_notes[i]['label'] == 'Family')
                                {
                                  _familyLabeledList.add(_notes[i]);
                                  filteredNotes = _familyLabeledList;
                                }
                              }
                              if(filteredNotes.isEmpty)
                                {
                                  filteredNotes = [];
                                }
                            }
                            else{
                              filteredNotes = _familyLabeledList;
                            }
                          }
                          else if(_label == 'Personal')
                          {
                            if(_personalLabeledList.isEmpty)
                            {
                              for(var i = 0; i < _notes.length; i++)
                              {
                                if(_notes[i]['label'] == 'Personal')
                                {
                                  _personalLabeledList.add(_notes[i]);
                                  filteredNotes = _personalLabeledList;
                                }
                              }
                              if(filteredNotes.isEmpty)
                                {
                                  filteredNotes = [];
                                }
                            }
                            else{
                              filteredNotes = _personalLabeledList;
                            }
                          }
                          Navigator.pop(context);
                        },
                      )).toList(),
                    )
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'username',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(_username),
                ),
              ),
              PopupMenuItem(
                value: 'changeview',
                child: ListTile(leading: Icon(_listView ? Icons.grid_view : Icons.list),
                  title: Text(_listView ? 'Grid view': 'List view'),), ),
              PopupMenuItem(
                  value: 'logout',
                  child: ListTile(leading: Icon(Icons.logout),
                    title: Text('Logout'),)),
              PopupMenuItem(
                  value: 'View_label',
                  child: ListTile(leading: Icon(Icons.label_important_outlined),
                    title: Text('View labeled items'),)),
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
            ],)
        ],
      ),
      body: _label == 'Work' ? Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => filterNotes(value, _label),
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(_listView ? 0 : 8),
              child: _listView
                    ? SlidableAutoCloseBehavior(
                closeWhenOpened: true,
                child: ListView.separated(
                    itemBuilder: (ctx, idx) {
                      return _noteListItem(filteredNotes[idx]);
                    },
                    separatorBuilder: (ctx, idx) => Divider(),
                    itemCount: filteredNotes.length),
              )
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (ctx, idx) => _noteGridItem(filteredNotes[idx]),
                itemCount: filteredNotes.length,
              ),
            ),
          ),
        ],
      ):
      _label == 'Personal'? Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => filterNotes(value, _label),
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(_listView ? 0 : 8),
              child: _listView
                  ? SlidableAutoCloseBehavior(
                closeWhenOpened: true,
                child: ListView.separated(
                    itemBuilder: (ctx, idx) {
                      return _noteListItem(filteredNotes[idx]);
                    },
                    separatorBuilder: (ctx, idx) => Divider(),
                    itemCount: filteredNotes.length),
              )
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (ctx, idx) => _noteGridItem(filteredNotes[idx]),
                itemCount: filteredNotes.length,
              ),
            ),
          ),
        ],
      ) :
      _label == 'Family'? Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => filterNotes(value, _label),
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(_listView ? 0 : 8),
              child: _listView
                  ? SlidableAutoCloseBehavior(
                closeWhenOpened: true,
                child: ListView.separated(
                    itemBuilder: (ctx, idx) {
                      return _noteListItem(filteredNotes[idx]);
                    },
                    separatorBuilder: (ctx, idx) => Divider(),
                    itemCount: filteredNotes.length),
              )
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (ctx, idx) => _noteGridItem(filteredNotes[idx]),
                itemCount: filteredNotes.length,
              ),
            ),
          ),
        ],
      ) : Container(child: Text("Empty"),),
    );
  }
}
