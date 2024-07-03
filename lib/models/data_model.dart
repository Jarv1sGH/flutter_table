import 'dart:convert';
import 'package:http/http.dart' as http;

class ShootingScene {
  final int qty;
  final String shootingSceneId;
  final DateTime? start;

  ShootingScene({
    required this.qty,
    required this.shootingSceneId,
    this.start,
  });

  factory ShootingScene.fromJson(Map<String, dynamic> json) {
    return ShootingScene(
      qty: json['qty'] ?? 0,
      shootingSceneId: json['shootingSceneId'] ?? '',
      start: json['start'] != null ? DateTime.parse(json['start']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qty': qty,
      'shootingSceneId': shootingSceneId,
      'start': start?.toIso8601String(),
    };
  }
}

class DataItem {
  final String id;
  final String name;
  final String projectId;
  final List<ShootingScene> shootingScenes;
  final String tagkey;
  final int offsetX;
  final int offsetY;
  final int age;
  final String description;
  final String image;

  DataItem({
    required this.id,
    required this.name,
    required this.projectId,
    required this.shootingScenes,
    required this.tagkey,
    required this.offsetX,
    required this.offsetY,
    required this.age,
    required this.description,
    required this.image,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) {
    var shootingScenesFromJson = json['shootingScenes'] as List? ?? [];
    List<ShootingScene> shootingScenesList = shootingScenesFromJson
        .map((sceneJson) => ShootingScene.fromJson(sceneJson))
        .toList();

    return DataItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      projectId: json['projectId'] ?? '',
      shootingScenes: shootingScenesList,
      tagkey: json['tagkey'] ?? '',
      offsetX: json['offsetX'] ?? 0,
      offsetY: json['offsetY'] ?? 0,
      age: json['age'] ?? 0,
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'projectId': projectId,
      'shootingScenes': shootingScenes.map((scene) => scene.toJson()).toList(),
      'tagkey': tagkey,
      'offsetX': offsetX,
      'offsetY': offsetY,
      'age': age,
      'description': description,
      'image': image,
    };
  }
}

class ApiResponse {
  final List<DataItem> data;
  final List<DateTime?> startDates; // Nullable start dates

  ApiResponse({
    required this.data,
    required this.startDates,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var dataFromJson = json['data'] as List? ?? [];
    List<DataItem> dataList =
        dataFromJson.map((dataJson) => DataItem.fromJson(dataJson)).toList();

    var startDatesFromJson = json['startdates'] as List? ?? [];
    List<DateTime?> startDatesList = startDatesFromJson
        .map((dateString) =>
            dateString != null ? DateTime.parse(dateString) : null)
        .toList();

    return ApiResponse(
      data: dataList,
      startDates: startDatesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'startdates': startDates.map((date) => date?.toIso8601String()).toList(),
    };
  }
}
