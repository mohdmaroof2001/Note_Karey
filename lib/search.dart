import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jiffy/jiffy.dart';
import 'package:me_note/add_&_edit.dart';
import 'package:me_note/sqlite_dphelper.dart';

class SearchUI extends StatefulWidget {
  const SearchUI({Key? key}) : super(key: key);

  @override
  _SearchUIState createState() => _SearchUIState();
}

class _SearchUIState extends State<SearchUI> {
  List<Map<String, dynamic>> dataArr = [];
  List<Map<String, dynamic>> showdata = [];
  TextEditingController search = TextEditingController();
  List<Color> randomcolors = [
    Color.fromARGB(255, 253, 153, 255),
    Color.fromARGB(255, 255, 158, 158),
    Color.fromARGB(255, 145, 244, 143),
    Color.fromARGB(255, 255, 245, 153),
    Color.fromARGB(255, 158, 255, 255),
  ];

  // List<String> showData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CostomButton(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color.fromRGBO(40, 40, 40, 5),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        child: Column(
          children: [
            // SizedBox(
            //   height: 50,
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                // color: Color.fromARGB(248, 87, 85, 85),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: search,
                showCursor: true,
                cursorWidth: 2,
                cursorColor: Colors.yellow,
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      splashColor: Colors.transparent,
                      onPressed: () {
                        search.clear();
                        readData();
                      },
                      icon: Icon(
                        Icons.close_outlined,
                        color: Color.fromARGB(248, 134, 132, 132),
                      )),
                  filled: true,
                  fillColor: Color.fromARGB(249, 66, 64, 64),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(25)),
                  hintText: "Search",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(248, 134, 132, 132)),
                ),
                onChanged: (text) {
                  text = text.toLowerCase();
                  showdata = dataArr
                      .where((element) {
                        var titleName = element["title"].toLowerCase();
                        return titleName.contains(text);
                      })
                      .toSet()
                      .toList();
                  setState(() {});
                },
              ),
            ),
            showdata.isEmpty
                ? Expanded(
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 100),
                        Center(child: Image.asset('images/cuate.png')),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'File not found. Try searching again.',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: showdata.length,
                        itemBuilder: ((context, indexNO) {
                          Map<String, dynamic> data = showdata[indexNO];
                          var Date = Jiffy(data['date'].toString())
                              .format("dd/MM/yyyy");
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
                                    dismissible:
                                        DismissiblePane(onDismissed: () async {
                                      await DbHelper.instance.deleteRow(
                                          'notes', 'id = ?', [data['id']]);
                                      readData();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("Delete Notes")));
                                      // print("delete 111");
                                    }),
                                    children: [
                                      SlidableAction(
                                        onPressed:
                                            (BuildContext context) async {
                                          await DbHelper.instance.deleteRow(
                                              'notes', 'id = ?', [data['id']]);
                                          readData();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text("Delete Notes")));
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
                                      color: randomcolors[
                                          indexNO % randomcolors.length]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['title'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color:
                                                  Color.fromRGBO(40, 40, 40, 5),
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
                  ),
          ],
        ),
      ),
    );
  }

  readData() async {
    var db = DbHelper.instance;
    dataArr = await db.getAllRows('notes');
    showdata = dataArr;
    // print("students are $dataArr");
    setState(() {});
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
