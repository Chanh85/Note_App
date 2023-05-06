import 'package:flutter/material.dart';
import 'AddNoteScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum Actions { protect, delete }

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Map<String, dynamic>> notes = [
    {
      'id': 'kl3091j2j2',
      'title': 'Việt Nam khởi đầu tốt nhất lịch sử dự U20 châu Á',
      'content':
          'Lần đầu trong lịch sử 64 năm của giải U20 châu Á, Việt Nam thắng cả hai trận đầu tiên, trước Australia và Qatar.',
      'lable': '',
      'pinned': false
    },
    {
      'id': '21343242434',
      'title': 'Truyền thông Indonesia khen U20 Việt Nam phi thường',
      'content':
          'Nhiều báo, đài Indonesia ngạc nhiên khi Việt Nam toàn thắng hai trận đầu ở bảng đấu khó tại vòng chung kết U20 châu Á 2023',
      'lable': '',
      'pinned': false
    },
    {
      'id': 'sk20918340',
      'title': 'Hai nghi can cướp ngân hàng ở Sài Gòn bị bắt',
      'content':
          'Ngày 5/3, Trương Minh Thiện và đồng phạm Trương Vĩnh Xương, 34 tuổi, bị Công an TP HCM phối hợp Cục cảnh sát Hình sự (C02, Bộ Công an) bắt về hành vi Cướp tài sản. Trong đó, Thiện bị xác định vai trò cầm đầu. Khẩu súng người này sử dụng khi gây án là loại bắn đạn bi nhựa.',
      'lable': '',
      'pinned': false
    },
    {
      'id': 'l091283-k29',
      'title': 'Phạt dưới 250.000 đồng, CSGT không cần lập biên bản',
      'content':
          '''Giải đáp vấn đề trên, luật sư Nguyễn Đại Hải (Công ty Luật TNHH Fanci) cho hay Điều 56 Luật Xử lý vi phạm hành chính 2012 có quy định về mức phạt tối thiểu để lập biên bản.

Cụ thể, cử phạt vi phạm hành chính không lập biên bản được áp dụng trong 2 trường hợp: xử phạt cảnh cáo hoặc phạt tiền đến 250.000 đồng với cá nhân, 500.000 đồng với tổ chức. Trong cả hai trường hợp, quy định được áp dụng khi người có thẩm quyền xử phạt ra quyết định xử phạt vi phạm hành chính tại chỗ.

Điều 56 cũng nêu ngoại lệ: Nếu vi phạm hành chính được phát hiện nhờ sử dụng phương tiện, thiết bị kỹ thuật, nghiệp vụ thì phải lập biên bản.

Theo điều luật trên, luật sư Hải cho hay dù mức phạt dưới 250.000 đồng (cá nhân) mà vi phạm được phát hiện thông qua phương tiện, kỹ thuật, nghiệp vụ thì vẫn phải lập biên bản. Với trường hợp phát hiện vi phạm tại chỗ mà mức phạt dưới 250.000 đồng thì không cần lập biên bản.''',
      'lable': '',
      'pinned': false
    },
    {
      'id': 'lkku0918230',
      'title': 'Cắt giảm nhân sự lan rộng trong ngành địa ốc',
      'content':
          'Công ty anh Hoàng làm việc có trụ sở tại quận 3, TP HCM, đã cắt giảm nhân sự từ cuối năm 2022 nhưng tình hình ngày càng trầm trọng hơn trong hơn 2 tháng đầu năm 2023. Từ tháng 1 đến tháng 2, bên cạnh số nhân viên bị công ty cho thôi việc còn có nhiều người chủ động xin nghỉ vì thu nhập bị cắt giảm mạnh không đủ trang trải cuộc sống. Hoàng cho hay hiện các phòng ban của công ty đều giảm nhân sự 50-70% do hoạt động đầu tư và bán hàng đều đình trệ.',
      'lable': '',
      'pinned': false
    },
    {
      'id': '122098390245l',
      'title': 'Ngành vận tải biển qua thời hoàng kim',
      'content':
          'Khi nhìn về khả năng phục hồi đơn hàng của ngành gỗ, ông Trần Lam Sơn, Tổng giám đốc Thiên Minh - nhà xuất khẩu sang châu Âu - nhận thấy chi phí vận chuyển là một trong những cơ hội.',
      'lable': '',
      'pinned': false
    },
    {
      'id': 'lkj9882901',
      'title':
          'Doanh nghiệp phát hành trái phiếu được kéo dài kỳ hạn thêm 2 năm',
      'content':
          'Cụ thể, trước đây doanh nghiệp không được thay đổi kỳ hạn trái phiếu đã phát hành, nhưng quy định mới sửa đổi cho phép kéo dài thời hạn của trái phiếu thêm tối đa 2 năm. Trong trường hợp trái chủ không đồng ý thay đổi này, doanh nghiệp "phải có trách nhiệm đàm phán để đảm bảo quyền lợi của nhà đầu tư". Nếu quá trình đàm phán vẫn không đạt kết quả như mong đợi, doanh nghiệp phải thực hiện nghĩa vụ với trái chủ theo phương án phát hành trái phiếu đã công bố.',
      'lable': '',
      'pinned': false
    },
  ];

  bool listView = true;
  var _passcontroller1 = TextEditingController();
  var _passcontroller2 = TextEditingController();
  bool validate = false;
  Offset _tapPos = Offset.zero;
  String selectedValue = 'Personal';
  var labelItems = ['Work', 'Personal', 'Family'];

  void _getTapPos(TapDownDetails tapPos) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPos = renderBox.globalToLocal(tapPos.globalPosition);
      print(_tapPos);
    });
  }

  void _showContextMenu(context, note) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    final res = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPos.dx, _tapPos.dy, 10, 10),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
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
            value: 'pinned',
            child: ListTile(
              leading: Icon(Icons.push_pin),
              title: Text('Pin'),
            ),
          ),
        ]);
    switch (res) {
      case 'delete':
        _onDelete(notes.indexOf(note), Actions.delete);
        break;
      case 'label':
        _label(note);
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
                            // Navigator.pop(context);
                          }))
                      .toList(),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        note['lable'] = selectedValue;
                        print(note['lable']);
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

  bool _handleSubmit() {
    setState(() {
      if (_passcontroller1.text.isEmpty || _passcontroller2.text.isEmpty) {
        validate = true;
      } else {
        validate = false;
        _passcontroller1.text = '';
        _passcontroller2.text = '';
      }
    });
    if (validate) {
      return false;
    }
    return true;
  }

  void createOrUpdate([Map<String, dynamic>? note]) async {
    String title = note?['title'] ?? '';
    String content = note?['content'] ?? '';

    var data = await Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => AddNoteScreen(note: note)));

    if (data == null) return;

    int index = notes.indexWhere((element) => element['id'] == data['id']);
    if (index >= 0) {
      if (data['title'] != title || data['content'] != content) {
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
        notes.insert(0, Map<String, String>.from(data));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A new note has been created'),
        ),
      );
    }
  }

  void _onProtect(note, lock, Actions action) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ct) => AlertDialog(
              title: Text('Set password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    controller: _passcontroller1,
                    maxLines: 1,
                    maxLength: 30,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter password',
                      border: OutlineInputBorder(),
                      errorText: validate ? "Value can not be empty" : null,
                    ),
                  ),
                  TextField(
                    controller: _passcontroller2,
                    maxLines: 1,
                    maxLength: 30,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      hintText: 'Confirm',
                      border: OutlineInputBorder(),
                      errorText: validate ? "Value can not be empty" : null,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      _handleSubmit();
                      // if(_handleSubmit())
                      //   {
                      //     Navigator.pop(context);
                      //   }
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

    setState(() {
      if (_handleSubmit()) {
        note['lock'] = !lock;
      }
    });
    print(note['title']);
  }

  void _onDelete(int index, Actions action) {
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

  Widget _noteGridItem(note) {
    return GestureDetector(
      onTap: () {
        createOrUpdate(note);
      },
      onTapDown: (position) {
        _getTapPos(position);
      },
      onLongPress: () {
        _showContextMenu(context, note);
      },
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
          SlidableAction(
              backgroundColor: Colors.lightBlue,
              icon: Icons.lock,
              label: 'Protect',
              onPressed: (context) => _onProtect(note, lock, Actions.protect)),
          SlidableAction(
              backgroundColor: Colors.lightGreenAccent,
              icon: Icons.label_outline,
              label: 'Label',
              onPressed: (context) => _label(note)),
          SlidableAction(
            backgroundColor: Color.fromARGB(255, 248, 151, 5),
            icon: isPinned(note) ? (Icons.push_pin) : (Icons.push_pin_outlined),
            label: 'Pin',
            onPressed: (context) {
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
            },
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (context) =>
                _onDelete(notes.indexOf(note), Actions.delete),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.newspaper),
        onTap: () {
          createOrUpdate(note);
        },
        trailing: lock ? Icon(Icons.lock) : null,
        title: Text(
          note['title'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Color.fromARGB(255, 133, 34, 4),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          note['content'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
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
                  //TODO: view label
                  showModalBottomSheet(
                      context: context,
                      builder: (ctx) => ListView(
                            shrinkWrap: true,
                            children: labelItems
                                .map((e) => ListTile(
                                      title: Text(e),
                                      onTap: () {
                                        Navigator.pop(context);
                                        print(e);
                                      },
                                    ))
                                .toList(),
                          ));
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'changeview',
                  child: ListTile(
                    leading: Icon(listView ? Icons.grid_view : Icons.list),
                    title: Text(listView ? 'Grid view' : 'List view'),
                  ),
                ),
                PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    )),
                PopupMenuItem(
                    value: 'View_label',
                    child: ListTile(
                      leading: Icon(Icons.label_important_outlined),
                      title: Text('View labeled items'),
                    )),
              ],
            )
          ],
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: EdgeInsets.all(listView ? 0 : 8),
          child: listView
              ? SlidableAutoCloseBehavior(
                  closeWhenOpened: true,
                  child: ListView.separated(
                      itemBuilder: (ctx, idx) => _noteListItem(notes[idx]),
                      separatorBuilder: (ctx, idx) => Divider(),
                      itemCount: notes.length),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (ctx, idx) => _noteGridItem(notes[idx]),
                  itemCount: notes.length,
                ),
        ),
      ),
    );
  }
}
