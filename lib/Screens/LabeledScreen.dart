import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum Actions{protect,delete}

class LabeledScreen extends StatefulWidget {
  bool listview;
  List<String> labelItems;
  String label;
  List<Map<String, dynamic>> notes;
  LabeledScreen({Key? key, required this.listview, required this.labelItems, required this.notes ,required this.label}) : super(key: key);

  @override
  State<LabeledScreen> createState() => _LabeledScreenState();
}

class _LabeledScreenState extends State<LabeledScreen> {

  late bool _listView;
  late List<String> _labelItems;
  late String _label;
  late List<Map<String, dynamic>> _notes;
  final List<Map<String,dynamic>> _workLabeledList = [];
  final List<Map<String,dynamic>> _personalLabeledList = [];
  final List<Map<String,dynamic>> _familyLabeledList = [];

  @override
  void initState() {
    super.initState();
    _listView = widget.listview;
    _labelItems = widget.labelItems;
    _notes = widget.notes;
    _label = widget.label;
    for(var i = 0; i < _notes.length; i++)
      {
        if(_notes[i]['label'] == 'Work')
          {
            _workLabeledList.add(_notes[i]);
          }
        else if(_notes[i]['label'] == 'Personal')
          {
            _personalLabeledList.add(_notes[i]);
          }
        else if(_notes[i]['label'] == 'Family') {
          _familyLabeledList.add(_notes[i]);
        }
      }
  }


  Widget _noteGridItem(note) {
    return GestureDetector(
      child: Card(
        color: Colors.yellow.shade300,
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
    bool lock = note['lock']?? false;
        return ListTile(
            leading: Icon(Icons.newspaper),
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
                          Navigator.pop(context);
                          print(e);
                        },
                      )).toList(),
                    )
                );
              }
            },
            itemBuilder: (context) => [
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
            ],)
        ],
      ),
      body: _label == 'Work' ? Container(
        padding: EdgeInsets.all(_listView ? 0 : 8),
        child: _listView
              ? SlidableAutoCloseBehavior(
          closeWhenOpened: true,
          child: ListView.separated(
              itemBuilder: (ctx, idx) {
                return _noteListItem(_workLabeledList[idx]);
              },
              separatorBuilder: (ctx, idx) => Divider(),
              itemCount: _workLabeledList.length),
        )
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (ctx, idx) => _noteGridItem(_workLabeledList[idx]),
          itemCount: _workLabeledList.length,
        ),
      ): _label == 'Personal'? Container(
        padding: EdgeInsets.all(_listView ? 0 : 8),
        child: _listView
            ? SlidableAutoCloseBehavior(
          closeWhenOpened: true,
          child: ListView.separated(
              itemBuilder: (ctx, idx) {
                return _noteListItem(_personalLabeledList[idx]);
              },
              separatorBuilder: (ctx, idx) => Divider(),
              itemCount: _personalLabeledList.length),
        )
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (ctx, idx) => _noteGridItem(_personalLabeledList[idx]),
          itemCount: _personalLabeledList.length,
        ),
      ) : _label == 'Family'? Container(
        padding: EdgeInsets.all(_listView ? 0 : 8),
        child: _listView
            ? SlidableAutoCloseBehavior(
          closeWhenOpened: true,
          child: ListView.separated(
              itemBuilder: (ctx, idx) {
                return _noteListItem(_familyLabeledList[idx]);
              },
              separatorBuilder: (ctx, idx) => Divider(),
              itemCount: _familyLabeledList.length),
        )
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (ctx, idx) => _noteGridItem(_familyLabeledList[idx]),
          itemCount: _familyLabeledList.length,
        ),
      ) : Container(child: Text("hi"),),
    );
  }
}
