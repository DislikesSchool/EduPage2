import 'dart:async';

import 'package:eduapge2/api.dart';
import 'package:eduapge2/home.dart';
import 'package:eduapge2/main.dart';
import 'package:flutter/material.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({super.key});

  @override
  BaseState<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends BaseState<TimerDisplay> {
  String _remainingTimeString = "00:00";
  Timer? _timer;
  LessonStatus _lessonStatus = LessonStatus(
      hasLesson: false, hasLessonsToday: false, nextLessonTime: DateTime.now());

  @override
  void initState() {
    super.initState();
    _updateTimeString();
    _startTimer();
  }

  Future<void> _updateTimeString() async {
    TimeTableData t = await EP2Data.getInstance().timetable.today();

    _lessonStatus = getLessonStatus(t.classes, TimeOfDay.now());
    final remainingTime =
        _lessonStatus.nextLessonTime.difference(DateTime.now());
    final minutes =
        remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    setState(() {
      _remainingTimeString = '$minutes:$seconds';
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_lessonStatus.hasLessonsToday) {
        _timer?.cancel();
        return;
      }
      _updateTimeString();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _lessonStatus.hasLessonsToday
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color.fromARGB(70, _lessonStatus.hasLesson ? 255 : 0,
                  _lessonStatus.hasLesson ? 0 : 255, 0),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(
              _remainingTimeString,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Container();
  }
}
