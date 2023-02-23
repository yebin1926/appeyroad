import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class write extends StatefulWidget {
  const write({Key? key}) : super(key: key);

  @override
  State<write> createState() => _writeState();
}

class _writeState extends State<write> {
  bool isSwitched = false;
  DateTime dateTime1 = DateTime.now();
  DateTime dateTime2 = DateTime.now();
  TimeOfDay time1 = TimeOfDay.now();
  TimeOfDay time2 = TimeOfDay.now();
  Color initialColor = Colors.blue;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body:

      Column(
        children: [

          //empty part
          Container(width:430, height: 270, color: Colors.grey,),
          //blue rounded edge
          new Container(
            height: 25.0,
            color: Colors.grey,
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0),
                    )
                ),
                child: new Center(

                )
            ),
          ),
          Row(
            children: [
              //space before exit button
              Container(width:10, height: 50, color:Colors.white),

              Material(
                color:Colors.white,
                //save button
                child:IconButton(
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
                                Text(
                                  '일정을 삭제하시겠습니까?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  children: [
                                    //space before the delete button
                                    Container(height: 1,width: 30,color: Colors.white,),
                                    TextButton(
                                      child: const Text('삭제'),
                                      onPressed: () {

                                      },
                                    ),
                                    Container(height: 1, width: 50,color: Colors.white,),
                                    TextButton(
                                      child: const Text('취소'),
                                      onPressed: () {Navigator.pop(context);

                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }

                    );
                  },
                  //color of exit button
                  icon: Icon(Icons.cancel, color: Colors.black,),
                ),),

              //container in between exit & save button
              Container(width:315, height: 50, color:Colors.white),
              Material(
                  color:Colors.white,
                  //save button
                  child:IconButton(
                    icon: Icon(Icons.check_circle_rounded),
                    color: Colors.black,
                    onPressed: () {},
                  )),
              //space after save button
              Container(width:9, height: 48, color:Colors.white)
            ],
          ),
          //row of white after exit/save button
          Container(width:430, height: 20, color: Colors.white),

          //text: date
          Row(
            children: [
              //space before title entry
              Container(width:40, height: 70,color: Colors.white,),

              const SizedBox(
                  height: 70,
                  width: 320,
                  child: TextField(
                      autocorrect: true,
                      style: TextStyle(fontSize: 25),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '제목',

                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      )
                  )
              ),
              //space after title entry
              Column(
                children: [


                  Container(
                    width:50, height:50, color:Colors.white,


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
                                            )),


                                      ],
                                    ),
                                  ],
                                ),


                                insetPadding: const  EdgeInsets.fromLTRB(0,80,0, 80),

                              );
                            }
                        );
                      },
                      //current color choice button
                    ),
                  ),

                  Container(width: 50, height: 20, color: Colors.white),
                ],
              ),
              Container(width:20, height: 70,color: Colors.white,)
            ],
          ),
          //empty space after colour choice button
          Row(
            children: [
              Container(width:45, height: 50, color:Colors.white),
              Icon(Icons.access_time_outlined),

              Container(width:230, height:50, color: Colors.white),
              Center(
                  child: Container(
                    height: 50,
                    child: Text(' \n하루종일'),
                    color: Colors.white,
                  )
              ),
              Center(
                  child: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        print(isSwitched);
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  )
              ),
            ],
          ),
          Row(
            children: [
              //space before date1
              Container(width: 50, height: 60, color:Colors.white),
              Column(
                children: [
                  Container(
                    width:140, height: 42, color:Colors.white,
                    child: TextButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                      child: Text(
                        '${dateTime1.year}\.${dateTime1.month}\.${dateTime1.day}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () async {
                        final date = await pickDate();
                        if(date==null){return;};
                        setState(() => dateTime1 = date);
                      },
                    ),
                  ),
                  Container(
                    width:140, height: 40, color:Colors.white,
                    child: TextButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                      child: Text(
                        '${Timeprint(time1)}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () async {
                        final time = await pickTime();
                        if(time==null){return;};
                        setState(() => time1 = time);
                      },
                    ),
                  )
                ],
              ),
              //space between date1 & arrow
              Container(width: 10, height: 50, color: Colors.white),
              Column(
                children: [
                  //space above arrow
                  Container(width: 10, height: 10, color: Colors.white),
                  Row(
                      children:[
                        Center(
                          child: const SizedBox(
                              height: 60,
                              width: 10,
                              child: Icon(Icons.arrow_forward_ios_rounded)
                          ),
                        )
                      ]
                  ),
                ],
              ),
              //space between arrow and date2
              Container(width: 30, height: 60, color: Colors.transparent),
              Column(
                children: [
                  Container(
                    width:140, height:40, color:Colors.white,
                    child: TextButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                      child: Text(
                        '${dateTime2.year}\.${dateTime2.month}\.${dateTime2.day}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () async {
                        final date = await pickDate();
                        if(date==null){return;};
                        setState(() => dateTime2 = date);
                      },
                    ),
                  ),
                  Container(
                    width:140, height: 40, color:Colors.white,
                    child: TextButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                      child: Text(
                        '${Timeprint(time2)}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () async {
                        final time = await pickTime();
                        if(time==null){return;};
                        setState(() => time2 = time);
                      },
                    ),
                  )
                ],
              )
            ],
          ),

          Row(
            children: [
              //space before note entry
              Container(width:25, height: 90,color: Colors.white,),
              const SizedBox(
                  height: 30,
                  width: 365.0,
                  child: TextField(
                      autocorrect: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.article),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '노트',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      )
                  )
              ),
              //space after note entry
              Container(width:40, height: 30,color: Colors.white,),
            ],
          ),

        ],
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
    context: context,
    initialDate: dateTime1,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  Timeprint(TimeOfDay Time){
    if (Time.minute < 10) {
      return '${Time.hour}:0${Time.minute}';}
    else
      return '${Time.hour}:${Time.minute}';
  }
  Future<TimeOfDay?> pickTime() => showTimePicker(
    context: context,
    initialTime: time1,
  );

}