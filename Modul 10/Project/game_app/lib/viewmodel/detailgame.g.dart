// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/detailgame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MinimumSystemRequirements _$MinimumSystemRequirementsFromJson(
  Map<String, dynamic> json,
) => MinimumSystemRequirements(
  os: json['os'] as String,
  processor: json['processor'] as String,
  memory: json['memory'] as String,
  graphics: json['graphics'] as String,
  storage: json['storage'] as String,
);

Map<String, dynamic> _$MinimumSystemRequirementsToJson(
  MinimumSystemRequirements instance,
) => <String, dynamic>{
  'os': instance.os,
  'processor': instance.processor,
  'memory': instance.memory,
  'graphics': instance.graphics,
  'storage': instance.storage,
};

Screenshot _$ScreenshotFromJson(Map<String, dynamic> json) =>
    Screenshot(id: (json['id'] as num).toInt(), image: json['image'] as String);

Map<String, dynamic> _$ScreenshotToJson(Screenshot instance) =>
    <String, dynamic>{'id': instance.id, 'image': instance.image};

DetailGame _$DetailGameFromJson(Map<String, dynamic> json) => DetailGame(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  thumbnail: json['thumbnail'] as String,
  status: json['status'] as String,
  short_description: json['short_description'] as String,
  description: json['description'] as String,
  game_url: json['game_url'] as String,
  genre: json['genre'] as String,
  platform: json['platform'] as String,
  publisher: json['publisher'] as String,
  developer: json['developer'] as String,
  release_date: json['release_date'] as String,
  freetogame_profile_url: json['freetogame_profile_url'] as String,
  minimum_system_requirements: MinimumSystemRequirements.fromJson(
    json['minimum_system_requirements'] as Map<String, dynamic>,
  ),
  screenshots: (json['screenshots'] as List<dynamic>)
      .map((e) => Screenshot.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DetailGameToJson(DetailGame instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'status': instance.status,
      'short_description': instance.short_description,
      'description': instance.description,
      'game_url': instance.game_url,
      'genre': instance.genre,
      'platform': instance.platform,
      'publisher': instance.publisher,
      'developer': instance.developer,
      'release_date': instance.release_date,
      'freetogame_profile_url': instance.freetogame_profile_url,
      'minimum_system_requirements': instance.minimum_system_requirements,
      'screenshots': instance.screenshots,
    };
