import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  void _scrollToToday() {
    final today = DateTime.now();
    final todayDay = today.day; // 오늘 날짜의 숫자
    final offset = (todayDay - 1) * 40.0; // 날짜에 따라 스크롤 위치 조정
    _scrollController.jumpTo(offset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayDay = today.day; // 오늘 날짜의 숫자
    final todayWeekday =
        DateFormat('EEEE').format(today).toUpperCase(); // 오늘 요일 대문자

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Column(
        children: [
          const SizedBox(height: 60), // 상단 여백 설정
          // 상단 바
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage('lib/image/profile.jpeg'),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.white70,
                  iconSize: 32,
                  onPressed: () {
                    // 플러스 버튼 클릭 시 동작
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12), // 상단 여백 설정
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$todayWeekday $todayDay', // 요일과 날짜 함께 표시
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start, // 좌측 정렬
                      children: List.generate(
                        31,
                        (index) {
                          final date = index + 1; // 1부터 31까지의 날짜
                          return DateWidget(
                            date: date,
                            isToday: date == todayDay, // 오늘 날짜와 비교
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // 카드 스크롤 뷰와의 여백
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // 세로 스크롤 설정
              child: Column(
                children: List.generate(10, (index) {
                  String taskName = 'Task ${index + 1}'; // 예시 Task 이름
                  String dueDate = '2024-09-${index + 1}'; // 예시 Due 날짜
                  String dueTime = _generateRandomTime(); // 임의의 시간 생성
                  List<String> friends = [
                    'ALEX',
                    'HELENA',
                    'NAMA',
                    'JOHN',
                    'EMMA'
                  ];

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      color: Colors.primaries[
                          index % Colors.primaries.length], // 랜덤 배경 색상
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0), // 카드 간의 세로 여백
                      child: Container(
                        width: double.infinity, // 카드 너비를 전체로 설정
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          '09', // 예시 시간
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Text(
                                          '00', // 예시 분
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        // SizedBox(height: 22), // 상단 여백 설정
                                        Container(
                                          width: 1, // 세로 줄의 너비
                                          height: 20, // 세로 줄의 높이
                                          color: Colors.white, // 세로 줄의 색상
                                        ),
                                        const Text(
                                          '09', // 예시 시간
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Text(
                                          '00', // 예시 분
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      taskName, // Task 제목
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 46,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 42),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      friends[
                                          index % friends.length], // 임의의 친구 이름
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 215, 215, 215),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      friends[(index + 1) %
                                          friends.length], // 다음 친구 이름
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 215, 215, 215),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      friends[(index + 2) %
                                          friends.length], // 또 다른 친구 이름
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 215, 215, 215),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 20), // 상단 여백 설정
        ],
      ),
    );
  }

  // 임의의 시간을 생성하는 메서드
  String _generateRandomTime() {
    Random random = Random();
    int hour = random.nextInt(24); // 0부터 23까지의 시간
    int minute = random.nextInt(60); // 0부터 59까지의 분
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}'; // 'HH:MM' 형식
  }
}

class DateWidget extends StatelessWidget {
  final int date;
  final bool isToday;

  const DateWidget({super.key, required this.date, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        isToday ? 'TODAY' : date.toString(), // 오늘 날짜일 경우 'TODAY' 표시
        style: TextStyle(
          color: isToday ? Colors.white : Colors.grey.shade700,
          fontSize: isToday ? 22 : 20,
          fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    );
  }
}
