import 'package:quizzler/question.dart';
import 'package:flutter/material.dart';
class QuizBrain {
  int _questionNumber = 0;

  List<Question> _questionBank = [
    Question('_____ country is called the Buffer state of Asia',["Pakistan","Afghanistan"," Bhutan"," Myanmar"], 2),
    Question('The highest mountain of the Earth is ____',["Mount Everest","K2","Norway","North Poler"], 1),
    Question('The largest democratic country in the world is _____',["United States","United Kingdom","China","India"], 4),
    Question('The world’s Largest continent by area is _____',["Asia","Europe","Africa","North America"], 1),
    Question('The largest planet of the solar system is ___',["Earth","Mars","Jupiter","Saturn"], 3),
    Question('The Israel currency is _____',["Euro","Shekel","Forint","Krone"], 2),
    Question('The NATO was signed in ____',["1945","1947","1949","1951"], 3),
    Question('Which is the 2nd largest city of Pakistan?',["Rawalpindi","Lahore","Multan","Quetta"], 2),
    Question('TCS stands for ____',["Transport Courier Service","Transm Courier Service","Time Courier service"," None of these"], 2),
    Question('Which country is called the land of lilies?',["Canada","USA","Mexico","UK"], 1),
  ];
  //Create Next Question Function
  void shuffle(){
  _questionBank..shuffle();
  }
  void nextQuestion() {
    if (_questionNumber < _questionBank.length - 1) {
      _questionNumber++;
    }
  }
void change_question(int index){
  _questionNumber=index;
}
  String getQuestionText() {
    return _questionBank[_questionNumber].questionText;
  }
  int get_number(){
    return _questionNumber;
  }
  int getCorrectAnswer() {
    return _questionBank[_questionNumber].index;
  }
  List<String> getoptions(){
    return _questionBank[_questionNumber].data;
  }

  bool isFinished() {
    if (_questionNumber >= _questionBank.length - 1) {
      return true;
    } else {
      return false;
    }
  }
  List<Widget> getallquestion(List<int> wrongans){
    List<Widget> temp = [];
    for(int i=0; i<wrongans.length;i++){
      int t=wrongans[i];
      temp.add(new Text( _questionBank[t].questionText+": "+_questionBank[t].data[_questionBank[t].index-1],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.0, height: 3,color: Colors.black),));
    }
    return temp;
  }
  void reset() {
    _questionNumber = 0;
  }
}


//TODO: Step 3 Part A - Create a method called isFinished() here that checks to see if we have reached the last question. It should return (have an output) true if we've reached the last question and it should return false if we're not there yet.

//TODO: Step 3 Part B - Use a print statement to check that isFinished is returning true when you are indeed at the end of the quiz and when a restart should happen.

//TODO: Step 4 Part B - Create a reset() method here that sets the questionNumber back to 0.
//}
