import 'package:dio/dio.dart';
import '../models/experience_model.dart';

class ExperienceRepository {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'),
  );

  // GET (Read all)
  Future<List<Experience>> fetchExperiences() async {
    try {
      final response = await _dio.get('/posts');
      return (response.data as List)
          .map((json) => Experience.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load experiences: $e');
    }
  }

  // POST (Create)
  Future<Experience> createExperience(String title, String details) async {
    try {
      final response = await _dio.post(
        '/posts',
        data: {'title': title, 'body': details, 'userId': 1},
      );
      return Experience.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create experience: $e');
    }
  }

  // PUT (Update)
  Future<Experience> updateExperience(
    int id,
    String title,
    String details,
  ) async {
    try {
      final response = await _dio.put(
        '/posts/$id',
        data: {'id': id, 'title': title, 'body': details, 'userId': 1},
      );
      return Experience.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update experience: $e');
    }
  }

  // DELETE (Delete)
  Future<void> deleteExperience(int id) async {
    try {
      await _dio.delete('/posts/$id');
    } catch (e) {
      throw Exception('Failed to delete experience: $e');
    }
  }
}
