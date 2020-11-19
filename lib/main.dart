import 'dart:async';
import 'package:flutter/material.dart';
import 'quiz_brain.dart';
// import 'splashscreen.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:easy_alert/easy_alert.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
QuizBrain quizBrain = QuizBrain();

void main() {
  runApp(new AlertProvider(
    child: new SplashScreen(),
    config: new AlertConfig(ok: "OK", cancel: "CANCEL", useIosStyle: true),
  ));
  // runApp(SplashScreen());
}
Timer _timer;
int _start = 60;
int correct=0;
int wrong=0;
var minutes;
var seconds;
List<int> wrong_answers=[];
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
            () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => QuizApp())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image:AssetImage('assets/images/quiz.png')
        )
      ),
    );
  }
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black12,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>  {
  // DateTime alert;

  List<Widget> scoreKeeper = [];
  bool change=false;
  int next_que=-1;
  int working=0;

  List<Widget> _getList(BuildContext context) {
    List<String> options= quizBrain.getoptions();
    // print(options.length);
    List<Widget> temp = [];
    for (var q = 1; q<=options.length; q++) {
      temp.add(
         new Container(
             width: double.infinity,

             child:FlatButton(
               color: Colors.blueGrey,
               textColor: Colors.white,
               child: new Text(options[q-1],style: TextStyle(fontSize: 25),),
               onPressed: () {
                 checkAnswer(q,context);
               },
             )
         )

      );
    }
    return temp;
  }
  void checkAnswer(int userPickedAnswer,BuildContext context) {
    int correctAnswer = quizBrain.getCorrectAnswer();
    setState(() {
      if (quizBrain.isFinished() == true) {
        // Alert.alert(context, title: "Hello", content: "this is a alert")
        //     .then((_) => Alert.toast(context, "You just click ok"));
        // Alert(
        //   context: this.context,
        //   title: 'Finshed',
        //   desc: 'You\'ve reached the end of the quiz.\nTrue Answer: $correct \n Wrong Answer: $wrong',
        // ).show();
        if (userPickedAnswer == correctAnswer) {
          correct+=1;
          scoreKeeper.add(Icon(
            Icons.check,
            color: Colors.amber,
          ));
        } else {
          wrong_answers.add(quizBrain.get_number());
          wrong+=1;
          scoreKeeper.add(Icon(
            Icons.close,
            color: Colors.cyanAccent,
          ));
        }
        // print(wrong);
        // print(correct);
        quizBrain.reset();
        quizBrain.shuffle();
        scoreKeeper = [];

        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondRoute()));
      }
      else {
        if (userPickedAnswer == correctAnswer) {
          correct+=1;
          scoreKeeper.add(Icon(
            Icons.check,
            color: Colors.black,
          ));
        } else {
          wrong_answers.add(quizBrain.get_number());


          scoreKeeper.add(
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {

                  print("Wrong");
                  // setState(() {
                    quizBrain.change_question(quizBrain.get_number());

                    // _volume += 10;
                  // });
                  next_que = quizBrain.get_number();
                  working=wrong;
                  change=true;
                },
              ),

              );
          wrong+=1;
        }
        if (change==true){
          quizBrain.change_question(next_que);
        }
        quizBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

        TweenAnimationBuilder<Duration>(

            duration: Duration(minutes: 1),
            tween: Tween(begin: Duration(minutes: 1), end: Duration.zero),
            onEnd: () {

              print('Timer ended');
              quizBrain.reset();
              quizBrain.shuffle();
              scoreKeeper = [];

              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()));
            },
            builder: (BuildContext context, Duration value, Widget child) {
              minutes = value.inMinutes;
              seconds = value.inSeconds % 60;
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text('$minutes:$seconds',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30)));
            }),
        Container(
          height: 50,
          width: 150,
          child: FlatButton(
          color: Colors.deepPurpleAccent,

          textColor: Colors.black,
          child: new Text("Stop Quiz",style: TextStyle(fontSize: 25),),
          onPressed: () {
            quizBrain.reset();
            quizBrain.shuffle();
            scoreKeeper = [];
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondRoute()));
          },
        ),),

        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Column(
          children: _getList(context),
        ),

        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){ Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizApp()));
            wrong=0;correct=0;
            wrong_answers=[];
            }
        ),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Text('True Answer: $correct'),
          Text('False Answer: $wrong'),
          Column(
            children: quizBrain.getallquestion(wrong_answers),
          )
        ],)

      ),
    );
  }
}