import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const TimerApp());
}

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? selectedIndex; // 선택된 카드의 인덱스
  bool isPlaying = false; // 현재 재생 상태
  bool showAlert = false; // 알림 표시를 위한 변수
  Timer? timer; // 타이머
  int secondsRemaining = 0; // 남은 시간
  int cyclesCompleted = 0; // 완료한 사이클 수
  int roundsCompleted = 0; // 완료한 라운드 수
  int cyclesInRound = 4; // 한 라운드의 사이클 수

  void startTimer(int duration) {
    setState(() {
      secondsRemaining = duration * 60; // 선택한 분을 초로 변환
      isPlaying = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          cyclesCompleted++;
          if (cyclesCompleted % cyclesInRound == 0) {
            roundsCompleted++;
            // 5분 후에 다음 사이클 시작
            Future.delayed(const Duration(minutes: 5), () {
              resetTimer();
            });
          } else {
            resetTimer();
          }
        });
      }
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isPlaying = false;
      secondsRemaining = 0;
    });
  }

  List<String> formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return [minutes, secs];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: showAlert
          ? const Color.fromARGB(255, 239, 69, 43).withOpacity(0.8)
          : const Color.fromARGB(255, 255, 63, 34),
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft, // 좌측 정렬
          child: Text(
            'POMOTIMER',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: showAlert
            ? const Color.fromARGB(255, 239, 69, 43).withOpacity(0.8)
            : const Color.fromARGB(255, 255, 63, 34),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center, // 카드들을 중앙에 정렬
                    children: [
                      // 첫 번째 카드
                      Card(
                        elevation: 4, // 그림자 효과
                        child: Opacity(
                          opacity: 0.01,
                          child: Container(
                            width: 130,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(10), // 모서리 둥글기 설정
                            ),
                            padding: const EdgeInsets.all(12), // 내부 여백 추가
                            child: const Text(
                              '00',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 63, 34),
                                fontSize: 74, // 글자 크기 조정
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // 두 번째 카드 (살짝 이동)
                      Positioned(
                        top: 32, // 위쪽으로 이동
                        child: Card(
                          elevation: 4,
                          child: Opacity(
                            opacity: 0.6,
                            child: Container(
                              width: 134,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: const Text(
                                '00',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 63, 34),
                                  fontSize: 74,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // 세 번째 카드 (또 살짝 이동)
                      Positioned(
                        top: 38, // 더 위쪽으로 이동
                        child: Card(
                          elevation: 4,
                          child: Container(
                            width: 138,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(16),
                            alignment: Alignment.center, // 중앙 정렬
                            child: Text(
                              formatTime(secondsRemaining)[0], // secs
                              style: const TextStyle(
                                color: Color.fromARGB(255, 255, 63, 34),
                                fontSize: 74,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Opacity(
                  opacity: 0.6,
                  child: SizedBox(
                    width: 40,
                    child: Align(
                      alignment: Alignment.center, // Align 위젯의 위치 조정
                      child: Text(
                        ':',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 54, // 글자 크기 조정
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center, // 카드들을 중앙에 정렬
                    children: [
                      // 첫 번째 카드
                      Card(
                        elevation: 4, // 그림자 효과
                        child: Opacity(
                          opacity: 0.01,
                          child: Container(
                            width: 130,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(10), // 모서리 둥글기 설정
                            ),
                            padding: const EdgeInsets.all(12), // 내부 여백 추가
                            child: const Text(
                              '00',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 63, 34),
                                fontSize: 74, // 글자 크기 조정
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // 두 번째 카드 (살짝 이동)
                      Positioned(
                        top: 32, // 위쪽으로 이동
                        child: Card(
                          elevation: 4,
                          child: Opacity(
                            opacity: 0.6,
                            child: Container(
                              width: 134,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: const Text(
                                '00',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 63, 34),
                                  fontSize: 74,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // 세 번째 카드 (또 살짝 이동)
                      Positioned(
                        top: 38, // 더 위쪽으로 이동
                        child: Card(
                          elevation: 4,
                          child: Container(
                            width: 138,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(16),
                            alignment: Alignment.center, // 중앙 정렬
                            child: Text(
                              formatTime(secondsRemaining)[1], // secs
                              style: const TextStyle(
                                color: Color.fromARGB(255, 255, 63, 34),
                                fontSize: 74,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12), // 상단 여백 설정
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 13, // 15, 20, 25, 30, 35
              itemBuilder: (context, index) {
                int minutes = 0 + index * 5; // 15, 20, 25, 30, 35
                bool isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    if (isPlaying) {
                      setState(() {
                        showAlert = true; // 알림 표시
                      });
                      // 3초 후 알림 숨기기
                      Future.delayed(const Duration(seconds: 3), () {
                        setState(() {
                          showAlert = false;
                        });
                      });
                    } else {
                      setState(() {
                        selectedIndex = isSelected ? null : index;
                        resetTimer();
                        startTimer(minutes);
                      });
                    }
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white54,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$minutes',
                      style: TextStyle(
                        color: isSelected
                            ? const Color.fromARGB(255, 255, 63, 34)
                            : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // 알림 메시지 표시

          const SizedBox(height: 12), // 상단 여백 설정
          Flexible(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                  // color: Colors.blue,
                  ),
              height: 200,
              child: SizedBox(
                width: 120,
                height: 120,
                child: CircleAvatar(
                  backgroundColor:
                      const Color.fromARGB(255, 32, 17, 15).withOpacity(0.4),
                  child: IconButton(
                    icon: Icon(
                      isPlaying
                          ? Icons.pause
                          : Icons.play_arrow, // 재생 또는 정지 아이콘 선택
                      size: 80, // 아이콘 크기
                      color: Colors.white, // 아이콘 색상
                    ),
                    onPressed: () {
                      setState(() {
                        if (isPlaying) {
                          resetTimer();
                        } else if (selectedIndex != null) {
                          startTimer(15 + selectedIndex! * 5);
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Stack(
              children: [
                Container(),
                if (showAlert)
                  Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.8,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: const Text(
                            '현재 타이머가 실행 중입니다.',
                            style: TextStyle(
                              color: Color.fromARGB(255, 32, 17, 15),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4), // 상단 여백 설정
          const Flexible(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '0/4',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'ROUND',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '0/12',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'GOAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
