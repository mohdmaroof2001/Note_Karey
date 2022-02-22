// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:me_note/add_&_edit.dart';
import 'package:me_note/colorsclass.dart';
import 'package:me_note/search.dart';
import 'package:me_note/sqlite_dphelper.dart';
import 'package:jiffy/jiffy.dart';

class Note_Dashbord extends StatefulWidget {
  const Note_Dashbord({Key? key}) : super(key: key);

  @override
  _Note_DashbordState createState() => _Note_DashbordState();
}

class _Note_DashbordState extends State<Note_Dashbord> {
  List<Map<String, dynamic>> dataArr = [];
  List<Color> randomcolors = [
    Color.fromARGB(255, 253, 153, 255),
    Color.fromARGB(255, 255, 158, 158),
    Color.fromARGB(255, 145, 244, 143),
    Color.fromARGB(255, 255, 245, 153),
    Color.fromARGB(255, 158, 255, 255),
  ];

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notes',
              style: TextStyle(fontSize: 35),
            ),
            CostomButton(context)
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color.fromRGBO(40, 40, 40, 5),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        child: dataArr.isEmpty
            ? Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 100),
                    Center(child: Image.asset('images/rafiki.png')),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Create your first note !',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
              )
            : ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: dataArr.length,
                itemBuilder: ((context, indexNO) {
                  Map<String, dynamic> data = dataArr[indexNO];
                  var Date =
                      Jiffy(data['date'].toString()).format("dd/MM/yyyy");
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Add_and_Edit(
                                      data: data,
                                    )));
                        if (result != null) {
                          readData();
                        }
                      },
                      child: Slidable(
                        key: ValueKey(dataArr[indexNO]),
                        // groupTag: Slidable.of(context),
                        endActionPane: ActionPane(
                            extentRatio: 0.30,
                            motion: ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () async {
                              await DbHelper.instance
                                  .deleteRow('notes', 'id = ?', [data['id']]);
                              readData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Delete Notes")));
                              // print("delete 111");
                            }),
                            children: [
                              SlidableAction(
                                onPressed: (BuildContext context) async {
                                  await DbHelper.instance.deleteRow(
                                      'notes', 'id = ?', [data['id']]);
                                  readData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Delete Notes")));
                                  // print("delete");
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              )
                            ]),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color:
                                  randomcolors[indexNO % randomcolors.length]),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['title'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromRGBO(40, 40, 40, 5),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      Date.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        data['body'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                separatorBuilder: (context, indexNo) {
                  return SizedBox();
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => Add_and_Edit()));
          if (result != null) {
            readData();
          }
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
        backgroundColor: Color.fromRGBO(40, 40, 40, 5),
        elevation: 20,
      ),
    );
  }

  readData() async {
    var db = DbHelper.instance;
    dataArr = await db.getAllRows('notes');
    print("students are $dataArr");
    setState(() {});
  }

  GestureDetector CostomButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchUI()));
      },
      child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(249, 66, 64, 64),
          ),
          child: Icon(
            Icons.search_sharp,
          )),
    );
  }
}
