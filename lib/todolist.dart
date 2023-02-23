import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:team2todolist/database.dart';
import 'package:team2todolist/write.dart';
import 'package:team2todolist/calendar.dart';

final DBHelper helper = DBHelper();

class TodolistInfo {
  int id;
  String? date;
  String? name;
  String? note;
  int? color;

  TodolistInfo(this.id, String this.date, String this.name, String? note, int? color) {
    this.note = note ?? "";
    this.color = color ?? getColorInt(Color.fromRGBO(31,48,199,1));
  }

  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'date': date,
      'name': name,
      'note': note,
      'color': color
    };
  }
}

DateTime toPrevMonth(DateTime dateSet){
  if (dateSet.month == 1) {
    return DateTime(dateSet.year - 1, 12, 1);
  }else{
    return DateTime(dateSet.year, dateSet.month - 1, 1);
  }
}

DateTime toNextMonth(DateTime dateSet){
  if (dateSet.month == 12) {
    return DateTime(dateSet.year + 1, 1, 1);
  }else{
    return DateTime(dateSet.year, dateSet.month + 1, 1);
  }
}

String getDateString(DateTime dateSet){
  return dateSet.year.toString() + dateSet.month.toString().padLeft(2,"0") + dateSet.day.toString().padLeft(2,"0");
}

int getColorInt(Color color){
  String colorString = color.toString().split('(0x')[1].split(')')[0]; // kind of hacky..
  return int.parse(colorString, radix: 16);
}

class Todolist extends StatefulWidget {
  final DateTime focusedDay;
  const Todolist(this.focusedDay, {Key? key}) : super(key: key);

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  DateTime dateSet = DateTime.now();
  List<String> dayKRList = ["월","화","수","목","금","토","일"];
  Map<String, List<TodolistInfo>> todolist = {};
  List<TodolistInfo> todolists = [];

  @override
  void initState() {
    super.initState();
    dateSet = widget.focusedDay;
    helper.getID();
  }
  @override
  Widget build(BuildContext context) {
    String dayKR = dayKRList[dateSet.weekday-1];
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.menu, color: Colors.black), onPressed: () {}),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                icon: Icon(Icons.arrow_left, color: Color.fromRGBO(224,224,224,1), size: 30),
                onPressed: () {
                  setState(() {
                    dateSet = toPrevMonth(dateSet);
                  });
                },
              ),
              Text(
                  DateFormat("yyyy년 MM월").format(dateSet),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 26)
              ),
              IconButton(
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                icon: Icon(Icons.arrow_right, color: Color.fromRGBO(224,224,224,1), size: 30),
                onPressed: () {
                  setState(() {
                    dateSet = toNextMonth(dateSet); // 월 이동 (매달 첫날로)
                  });
                },
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(255,255,255,1),
          elevation: 0
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(32,20,32,20),
                child: TableCalendar(
                  firstDay: DateTime(1990),
                  lastDay: DateTime(2099),
                  daysOfWeekHeight: 30,
                  locale: "ko_KR",
                  focusedDay: dateSet,
                  calendarFormat: CalendarFormat.week,
                  headerVisible: false,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  selectedDayPredicate: (DateTime date){
                    return isSameDay(dateSet, date);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(dateSet, selectedDay)) {
                      setState(() {
                        dateSet = selectedDay;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    dateSet = focusedDay;
                  },
                  calendarBuilders: CalendarBuilders(
                    todayBuilder: (context, day, focusedDay){ // 달력 부분: 오늘 날짜
                      return Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(32,32,32,0.5),
                          shape: BoxShape.circle
                        ),
                        padding: EdgeInsets.all(5),
                        child: Text(
                          day.day.toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 12),
                        )
                      );
                    },
                    selectedBuilder: (context, day, focusedDay){ // 달력 부분: 선택 날짜
                      return Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(32,32,32,1),
                          shape: BoxShape.circle
                        ),
                        padding: EdgeInsets.all(5),
                        child: Text(
                          day.day.toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 12),
                        )
                      );
                    },
                    defaultBuilder: (context, day, focusedDay){ // 달력 부분: 선택X 날짜
                      if (day.weekday == DateTime.sunday) { // 일요일
                        return Container(
                          margin: EdgeInsets.only(left: 1.0, right: 1.0, top: 3.5),
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(color: Color.fromRGBO(200,76,76,1), fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 12),
                          ),
                        );
                      }else if (day.weekday == DateTime.saturday){ // 토요일
                        return Container(
                          margin: EdgeInsets.only(left: 1.0, right: 1.0, top: 3.5),
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(color: Color.fromRGBO(57,71,197,1), fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 12),
                          ),
                        );
                      }else{ // 평일
                        return Container(
                          margin: EdgeInsets.only(left: 1.0, right: 1.0, top: 3.5),
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(color: Color.fromRGBO(32,32,32,1), fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 12),
                          ),
                        );
                      }
                    },
                    outsideBuilder: (context, day, focusedDay){ // 달력 부분: 바깥 날짜
                      return Container(
                          margin: EdgeInsets.only(left: 1.0, right: 1.0, top: 3.5),
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(color: Color.fromRGBO(208,208,208,1), fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 12),
                          )
                      );
                    },
                    dowBuilder: (context, day) { // 상단 요일 부분
                      if (day.weekday == DateTime.sunday) { // 일요일
                        return const Center(
                          child: Text(
                            "일",
                            style: TextStyle(color: Color.fromRGBO(200,76,76,1), fontWeight: FontWeight.w400, fontFamily: "NanumGothic", fontSize: 12),
                          ),
                        );
                      }else if (day.weekday == DateTime.saturday){ // 토요일
                        return const Center(
                          child: Text(
                            "토",
                            style: TextStyle(color: Color.fromRGBO(57,71,197,1), fontWeight: FontWeight.w400, fontFamily: "NanumGothic", fontSize: 12),
                          ),
                        );
                      }else{ // 평일
                        return Center(
                          child: Text(
                            dayKRList[day.weekday-1],
                            style: const TextStyle(color: Color.fromRGBO(32,32,32,1), fontWeight: FontWeight.w400, fontFamily: "NanumGothic", fontSize: 12),
                          ),
                        );
                      }
                    },
                  ),
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: true,
                    cellAlignment: Alignment.topCenter,
                    markersAlignment: Alignment.topCenter,
                    markerSizeScale: 5.0,
                    tableBorder: TableBorder(
                      horizontalInside: BorderSide(
                        color: Colors.black12,
                        width: 1.5,
                      ),
                    ),
                  )
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(32,0,0,0),
                padding: EdgeInsets.fromLTRB(3,0,0,0),
                child: Text(
                    DateFormat('MM월 dd일 ').format(dateSet) + dayKR,
                    style: TextStyle(color: Color.fromRGBO(32,32,32,1), fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 20)
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(32,16,32,26),
                height: 1,
                color: Color.fromRGBO(235,235,235,1),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(32,0,0,0),
                padding: EdgeInsets.fromLTRB(3,0,0,0),
                child: FutureBuilder(
                  future: _fetch(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData == false) {
                      return CircularProgressIndicator();
                    } else {
                      return Column(
                        children: [
                          if (todolists.isNotEmpty)...[
                            for (TodolistInfo todo in todolists)...[
                              GestureDetector(
                                onLongPress: () async {
                                  final newTodolists = await showModalBottomSheet<List<TodolistInfo>>(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0),
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return WriteTodolist(dateSet, dayKR, todo);
                                    },
                                  );
                                  if (newTodolists != null) {
                                    setState(() {
                                      todolists = newTodolists;
                                    });
                                  }
                                },
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "노트",
                                        style: TextStyle(color: Color.fromRGBO(32,32,32,1), fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 20)
                                      ),
                                      content: Text(
                                        todo.note ?? "노트가 없습니다.",
                                        style: TextStyle(color: Color.fromRGBO(32,32,32,1), fontWeight: FontWeight.w400, fontFamily: "NanumGothic", fontSize: 16)
                                      ),
                                      insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                                      );
                                    }
                                  );
                                },
                                child: Container( // 추가) 선택이 가능하게?
                                  margin: EdgeInsets.fromLTRB(0,0,0,16),
                                  child: Row (
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.crop_square_outlined, color: Color(todo.color!), size: 20), // 추가) 체크 박스 눌러서 했는지 확인 기능?
                                      Text(
                                        "  " + todo.name.toString(),
                                        style: TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "NanumGothic",
                                          fontSize: 16)
                                      ),
                                    ]
                                  ),
                                ),
                              )
                            ]
                          ]else...[
                            const Text(
                                "할 일이 없습니다.",
                                style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "NanumGothic",
                                    fontSize: 16)
                            ),
                          ]
                        ]
                      );
                    }
                  }
                )
              )
            ]
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(32,32,32,1),
        child: Icon(Icons.add),
        onPressed: () async {
          final newTodolists = await showModalBottomSheet<List<TodolistInfo>>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            backgroundColor: Colors.white,
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return WriteTodolist(dateSet, dayKR, null);
            },
          );
          if (newTodolists != null) {
            setState(() {
              todolists = newTodolists;
            });
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: 375,
          height: 60,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Icon(Icons.calendar_month, color: Color.fromRGBO(224,224,224,1)),
                      Text("스케줄", style: TextStyle(color: Color.fromRGBO(224,224,224,1))),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context, dateSet);
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Icon(Icons.check_box),
                      Text("할 일"),
                    ],
                  ),
                  onPressed: () {
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<String> _fetch() async { // https://eory96study.tistory.com/21
    todolists = await helper.getQueryFromDate(dateSet);
    return 'Call Data';
  }
}

class WriteTodolist extends StatefulWidget {
  final DateTime dateSet;
  final String dayKR;
  final TodolistInfo? todo;

  const WriteTodolist(this.dateSet, this.dayKR, this.todo, {Key? key}) : super(key: key);

  @override
  State<WriteTodolist> createState() => _WriteTodolist();
}

class _WriteTodolist extends State<WriteTodolist> {
  bool alreadyExists = true;
  TextEditingController tec1 = TextEditingController();
  TextEditingController tec2 = TextEditingController();
  Color initialColor = const Color.fromRGBO(31,48,199,1);

  @override
  void initState() {
    super.initState();
    if (widget.todo == null) {
      alreadyExists = false;
    }
    tec1.text = widget.todo?.name ?? "";
    tec2.text = widget.todo?.note ?? "";
    initialColor = Color(widget.todo?.color ?? getColorInt(Color.fromRGBO(31,48,199,1)));
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateSet = widget.dateSet;
    String dayKR = widget.dayKR;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height*0.75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(30,0,30,0),
            color: Colors.transparent,
            width: width,
            height: 50,
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.cancel, color: Colors.black,),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,  // 바깥 영역 터치시 닫을지 여부
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(
                                  alreadyExists ? "변경사항을 삭제하시겠습니까?" : "일정을 삭제하시겠습니까?",
                                  style: TextStyle(
                                    color: Color.fromRGBO(32,32,32,1),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "NanumGothic",
                                    fontSize: 16
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                contentPadding: EdgeInsets.fromLTRB(0,40,0,10),
                                actions: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: TextButton(
                                          child: const Text(
                                            "삭제",
                                            style: TextStyle(
                                              color: Color.fromRGBO(32,32,32,1),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "NanumGothic",
                                              fontSize: 16
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (alreadyExists) {
                                              helper.delete(widget.todo!.id);
                                            }
                                            Navigator.pop(context);
                                            Navigator.pop(context, await helper.getQueryFromDate(dateSet));
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: TextButton(
                                          child: Text(
                                            alreadyExists ? "계속 수정" : "취소",
                                            style: TextStyle(
                                              color: Color.fromRGBO(26,43,192,1),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "NanumGothic",
                                              fontSize: 16
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          );
                        }
                    )
                ),
                Expanded(
                  flex: 11,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.check_circle_rounded, color: Colors.black,),
                    onPressed: () async { // 저장 버튼
                      if (tec1.text == "") {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(
                                "제목을 입력하세요",
                                style: TextStyle(
                                  color: Color.fromRGBO(32,32,32,1),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "NanumGothic",
                                  fontSize: 16
                                )
                              ),
                            );
                          }
                        );
                      } else {
                        if (alreadyExists) {
                          helper.update(TodolistInfo(
                              widget.todo!.id, dateSet.year.toString() +
                              dateSet.month.toString().padLeft(2, "0") +
                              dateSet.day.toString().padLeft(2, "0"),
                              tec1.text, tec2.text, getColorInt(initialColor)));
                        } else {
                          helper.insert(TodolistInfo(
                              helper.id + 1, dateSet.year.toString() +
                              dateSet.month.toString().padLeft(2, "0") +
                              dateSet.day.toString().padLeft(2, "0"),
                              tec1.text, tec2.text, getColorInt(initialColor)));
                          helper.id += 1;
                        }
                        Navigator.pop(context, await helper.getQueryFromDate(dateSet));
                      }
                    }
                  ),
                )
              ]
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(35,17,0,7),
              width:width,
              height: 67,
              color: Colors.transparent,
              child: Text(
                  DateFormat("MM월 dd일 ").format(dateSet) + dayKR,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 20)
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(35,0,30,0),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    autocorrect: true,
                    style: TextStyle(fontSize: 25),
                    //initialValue: widget.todo?.name ?? "",
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      hintText: "제목",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    controller: tec1,
                  ),
                ),
                Container(
                  width:50, height:50, color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(Icons.circle, color: initialColor,),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Material(
                                          color:Colors.white,
                                          child:IconButton(
                                            icon: Icon(Icons.circle),
                                            color: Colors.red,
                                            onPressed: () async {
                                              setState(() => initialColor = Colors.red);
                                              Navigator.of(context).pop();
                                            },
                                          )),
                                      Material(
                                          color:Colors.white,
                                          child:IconButton(
                                            icon: Icon(Icons.circle),
                                            color: Colors.orange,
                                            onPressed: () async{
                                              setState(() => initialColor = Colors.orange);
                                              Navigator.of(context).pop();
                                            },
                                          )),
                                      Material(
                                          color:Colors.white,
                                          child:IconButton(
                                            icon: Icon(Icons.circle),
                                            color: Colors.yellow,
                                            onPressed: () async{
                                              setState(() => initialColor = Colors.yellow);
                                              Navigator.of(context).pop();
                                            },
                                          )),
                                      Material(
                                          color:Colors.white,
                                          child:IconButton(
                                            icon: Icon(Icons.circle),
                                            color: Colors.green,
                                            onPressed: () async{
                                              setState(() => initialColor = Colors.green);
                                              Navigator.of(context).pop();
                                            },
                                          )),
                                      Material(
                                          color:Colors.white,
                                          child:IconButton(
                                            icon: Icon(Icons.circle),
                                            color: Colors.blue,
                                            onPressed: () async{
                                              setState(() => initialColor = Colors.blue);
                                              Navigator.of(context).pop();
                                            },
                                          )),
                                    ],
                                  ),
                                  //2nd row of color choices
                                  Row(
                                    children: [
                                      Material(
                                        //space after the title entry
                                          color:Colors.white,
                                          child:IconButton(
                                            icon: Icon(Icons.circle),
                                            color: Colors.pink,
                                            onPressed: () async{
                                              setState(() => initialColor = Colors.pink);
                                              Navigator.of(context).pop();
                                            },
                                          )),
                                      Material(
                                          color:Colors.white,
                                          child:IconButton(
                                            icon: Icon(Icons.circle),
                                            color: Colors.purple,
                                            onPressed: () async{
                                              setState(() => initialColor = Colors.purple);
                                              Navigator.of(context).pop();
                                            },
                                          )),
                                      Material(
                                          color:Colors.white,
                                          child:IconButton(
                                            icon: Icon(Icons.circle ),

                                            color: Colors.black,
                                            onPressed: () async{
                                              setState(() => initialColor = Colors.black);
                                              Navigator.of(context).pop();
                                            },
                                          )),

                                      Material(
                                          color:Colors.white,
                                          child:IconButton(
                                            icon: Icon(Icons.circle),
                                            color: Colors.grey,
                                            onPressed: () async{
                                              setState(() => initialColor = Colors.grey);
                                              Navigator.of(context).pop();
                                            },
                                          )),

                                      Material(
                                          color:Colors.white,
                                          child:IconButton(
                                            icon: Icon(Icons.circle),
                                            color: Colors.lightGreen,
                                            onPressed: () async{
                                              setState(() => initialColor = Colors.lightGreen);
                                              Navigator.of(context).pop();
                                            },
                                          )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),
                            );
                          }
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(35,65,35,0),
            width: width,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autocorrect: true,
                  //initialValue: widget.todo?.note ?? '',
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.article),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "노트",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  controller: tec2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
