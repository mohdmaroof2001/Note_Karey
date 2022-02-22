// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:me_note/sqlite_dphelper.dart';

class Add_and_Edit extends StatefulWidget {
  Map<String, dynamic>? data;

  Add_and_Edit({Key? key, this.data}) : super(key: key);

  @override
  _Add_and_EditState createState() => _Add_and_EditState();
}

class _Add_and_EditState extends State<Add_and_Edit> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    if (widget.data != null) {
      setState(() {
        title.text = '${widget.data!['title']}';
        description.text = '${widget.data!['body']}';
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CostomButton(context),
            GestureDetector(
              onTap: () async {
                if (widget.data != null) {
                  var date = DateTime.now();

                  int updateId = await DbHelper.instance.updateRow(
                      'notes',
                      {
                        'title': title.text,
                        'body': description.text,
                        'date': date.toString()
                      },
                      'id = ?',
                      [
                        widget.data != ['id']
                      ]);
                  print("Update count $updateId");
                  Navigator.pop(context, "update");
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Update Notes")));
                } else {
                  var date = DateTime.now();
                  int insertId = await DbHelper.instance.insertRow('notes', {
                    'title': title.text,
                    'body': description.text,
                    'date': date.toString()
                  });
                  print("Update count $insertId");
                  Navigator.pop(context, "add");
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Save Notes")));
                }
              },
              child: Container(
                width: 80,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(249, 66, 64, 64),
                ),
                child: Center(
                    child: Text(
                  widget.data == null ? 'Save' : 'Update',
                  style: TextStyle(fontSize: 15),
                )),
              ),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color.fromRGBO(40, 40, 40, 5),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: title,
              showCursor: true,
              cursorWidth: 2,
              cursorColor: Colors.yellow,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(248, 134, 132, 132))),
              style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Expanded(
                child: TextField(
              showCursor: true,
              cursorWidth: 2,
              cursorColor: Colors.yellow,
              controller: description,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type somthing...',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(248, 134, 132, 132),
                  )),
              style: TextStyle(color: Colors.white),
            ))
          ],
        ),
      ),
      //   floatingActionButton: FloatingActionButton.extended(
      //     onPressed: () async {
      //       if (widget.data != null) {
      //         var date = DateTime.now();

      //         int updateId = await DbHelper.instance.updateRow(
      //             'notes',
      //             {
      //               'title': title.text,
      //               'body': description.text,
      //               'date': date.toString()
      //             },
      //             'id = ?',
      //             [
      //               widget.data != ['id']
      //             ]);
      //         print("Update count $updateId");
      //         Navigator.pop(context, "update");
      //       } else {
      //         var date = DateTime.now();
      //         int insertId = await DbHelper.instance.insertRow('notes', {
      //           'title': title.text,
      //           'body': description.text,
      //           'date': date.toString()
      //         });
      //         print("Update count $insertId");
      //         Navigator.pop(context, "add");
      //       }
      //     },
      //     label: Text(widget.data == null ? 'Save' : 'Update'),
      //     backgroundColor: Color.fromRGBO(40, 40, 40, 5),
      //     // elevation: 30,

      //     // icon: Icon(Icons.save),
      //   ),
    );
  }

  GestureDetector CostomButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(249, 66, 64, 64),
        ),
        child: Icon(Icons.arrow_back_ios_new_rounded),
      ),
    );
  }
}
