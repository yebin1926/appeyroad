//import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:team2todolist/todolist.dart';
import 'package:team2todolist/Event.dart';
import 'package:team2todolist/write.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  Map<DateTime, List<Event>> selectedEvents = new Map<DateTime, List<Event>>();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<String> dayKRList = ["월","화","수","목","금","토","일"];

  List<Event> _getEventsfromDay(DateTime date){
    return selectedEvents[date]??[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    _focusedDay = toPrevMonth(_focusedDay);
                  });
                },
              ),
              Text(
                  DateFormat("yyyy년 MM월").format(_focusedDay),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 26)
              ),
              IconButton(
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                icon: Icon(Icons.arrow_right, color: Color.fromRGBO(224,224,224,1), size: 30),
                onPressed: () {
                  setState(() {
                    _focusedDay = toNextMonth(_focusedDay); // 월 이동 (매달 첫날로)
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
        margin: EdgeInsets.fromLTRB(32,20,32,20),
        child: TableCalendar(
          firstDay: DateTime(1990),
          lastDay: DateTime(2025),
          daysOfWeekHeight: 30,
          locale: 'ko-KR',
          shouldFillViewport: true,
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (DateTime date){
            return isSameDay(_focusedDay, date);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              // Call `setState()` when updating the selected day
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            } else {
              showDialog( // 날짜 터치 시 팝업창 출력
                context: context,
                barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(
                      children:[
                        Row(
                          children:[
                            Container(width:190, height: 10,color: Colors.white,),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
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
                                    return write();
                                  },
                                );
                              },
                              icon: Icon(Icons.add_circle, color: Colors.black,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              );
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              // Call `setState()` when updating calendar format
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = focusedDay;
          },

          eventLoader: _getEventsfromDay,

          calendarBuilders: CalendarBuilders(
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
            selectedBuilder: (context, datetime, focusedDay){
              return /*GestureDetector(
                onTap: () { // 날짜 터치 시 팝업창 출력
                  showDialog(
                    context: context,
                    barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          children:[
                            Row(
                              children:[
                                Container(width:190, height: 10,color: Colors.white,),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet<void>(
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
                                        return write();
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.add_circle, color: Colors.black,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  );
                },
                child:*/ Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(32,32,32,1),
                    shape: BoxShape.circle
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    datetime.day.toString(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 12),
                  )
                //)
              );
            },
            todayBuilder: (context, datetime, focusedDay){
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(32,32,32,0.5),
                    shape: BoxShape.circle
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    datetime.day.toString(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: "NanumGothic", fontSize: 12),
                  )
                ),
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

          headerVisible: false,
          headerStyle: const HeaderStyle(
            titleCentered: true,
            titleTextStyle: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold
            ),
            formatButtonVisible: false,
            headerPadding: const EdgeInsets.symmetric(vertical: 50.0),

            leftChevronIcon: const Icon(
              Icons.arrow_left,
              size: 30.0,
              color: Colors.grey,
            ),
            leftChevronMargin: const EdgeInsets.only(left: 70),
            rightChevronMargin: const EdgeInsets.only (right: 70),
            rightChevronIcon: const Icon(
              Icons.arrow_right,
              size: 30.0,
              color: Colors.grey,
            ),
          ),

          calendarStyle: CalendarStyle(
            outsideDaysVisible: true,
            //weekendTextStyle: TextStyle().copyWith(color: Colors.red),
            cellAlignment: Alignment.topCenter,
            markersAlignment: Alignment.topCenter,
            markerSizeScale: 5.0,
            tableBorder: TableBorder(
              horizontalInside: BorderSide(
                color: Colors.black12,
                width: 1.5,
              ),
            ),
          ),

          /*daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle(color: Colors.red), // 요일
          ),*/
        ),
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
                      Icon(Icons.calendar_month),
                      Text("스케줄"),
                    ],
                  ),
                  onPressed: () {},
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Icon(Icons.check_box, color: Color.fromRGBO(224,224,224,1)),
                      Text("할 일", style: TextStyle(color: Color.fromRGBO(224,224,224,1))),
                    ],
                  ),
                  onPressed: () async {
                    final dateSet = await Navigator.push(context, PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) => Todolist(_focusedDay),
                        transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        }
                    ));
                    if (dateSet != null) {
                      setState(() {
                        _focusedDay = dateSet;
                        _selectedDay = _focusedDay;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

 class MyStatelessWidget extends StatelessWidget{
   const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context){
    return Table(
      border: TableBorder(
      horizontalInside: BorderSide(
        color: Colors.black
        ),
      )
    );

  }
}

