import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 80),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              MovieSection(
                  title: 'Popular Movies',
                  endpoint:
                      'https://movies-api.nomadcoders.workers.dev/popular'),
              MovieSection(
                  title: 'Now in Cinemas',
                  endpoint:
                      'https://movies-api.nomadcoders.workers.dev/now-playing'),
              MovieSection(
                  title: 'Comming soon',
                  endpoint:
                      'https://movies-api.nomadcoders.workers.dev/coming-soon'),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieSection extends StatelessWidget {
  final String title;
  final String endpoint;

  const MovieSection({super.key, required this.title, required this.endpoint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        FutureBuilder<List<Movie>>(
          future: fetchMovies(endpoint),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else {
              return MovieList(movies: snapshot.data!);
            }
          },
        ),
      ],
    );
  }

  Future<List<Movie>> fetchMovies(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['results'];
      return jsonData.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('영화 목록을 가져오는 데 실패했습니다.');
    }
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(movieId: movie.id),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // 원하는 반경으로 설정
                    child: Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(movie.title, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final int movieId;

  const DetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MovieDetails>(
        future: fetchMovieDetails(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else {
            final movie = snapshot.data!;

            return Stack(
              children: [
                // 배경 이미지와 그라데이션
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(movie.posterUrl), // 영화 포스터를 배경으로 사용
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black], // 그라데이션 색상
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: Container()), // 여백을 추가하기 위해 Expanded 사용
                      Container(
                        decoration: const BoxDecoration(),
                        margin: const EdgeInsets.only(bottom: 0),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              '등급: ${movie.rating}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              '장르: ${movie.genre}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(movie.overview,
                                  style: const TextStyle(color: Colors.white)),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 40), // 버튼 위쪽 여백
                              child: TextButton(
                                onPressed: () {
                                  // 예매 버튼 클릭 시 처리할 코드
                                  print('예매 버튼 클릭됨'); // 예시로 콘솔에 출력
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red, // 버튼 텍스트 색상
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14.0,
                                    horizontal: 84.0,
                                  ), // 패딩
                                ),
                                child: const Text(
                                  '예매하기',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
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
                Positioned(
                  top: 60, // 위치 조정
                  left: 16, // 위치 조정
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // 이전 화면으로 돌아가기
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<MovieDetails> fetchMovieDetails(int id) async {
    final response = await http.get(
        Uri.parse('https://movies-api.nomadcoders.workers.dev/movie?id=$id'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return MovieDetails.fromJson(jsonData);
    } else {
      throw Exception('영화 세부정보를 가져오는 데 실패했습니다.');
    }
  }
}

class Movie {
  final int id;
  final String title;
  final String posterUrl;

  Movie({required this.id, required this.title, required this.posterUrl});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterUrl: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : '',
    );
  }
}

class MovieDetails {
  final String title;
  final String overview;
  final String rating;
  final String genre;
  final String posterUrl;

  MovieDetails(
      {required this.title,
      required this.overview,
      required this.rating,
      required this.genre,
      required this.posterUrl});

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      title: json['title'],
      overview: json['overview'],
      rating: json['vote_average'].toString(),
      genre: json['genres'].map((g) => g['name']).join(', '),
      posterUrl: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : '',
    );
  }
}
