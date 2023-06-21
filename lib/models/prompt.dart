import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class PromptModel {
  final String promptId;
  final String title;
  final List<String> tags;
  final bool isPublished;
  final String createdBy;
  final List<String> versions;
  final int upvotesCnt;
  final int downvotesCnt;
  final int favoritesCnt;
  final Timestamp createdAt;

  PromptModel copyWith({
    String? promptId,
    String? title,
    List<String>? tags,
    bool? isPublished,
    String? createdBy,
    List<String>? versions,
    int? upvotesCnt,
    int? downvotesCnt,
    int? favoritesCnt,
    Timestamp? createdAt,
  }) {
    return PromptModel(
      promptId: promptId ?? this.promptId,
      title: title ?? this.title,
      tags: tags ?? this.tags,
      isPublished: isPublished ?? this.isPublished,
      createdBy: createdBy ?? this.createdBy,
      versions: versions ?? this.versions,
      upvotesCnt: upvotesCnt ?? this.upvotesCnt,
      downvotesCnt: downvotesCnt ?? this.downvotesCnt,
      favoritesCnt: favoritesCnt ?? this.favoritesCnt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  PromptModel({
    required this.promptId,
    required this.title,
    required this.tags,
    required this.isPublished,
    required this.createdBy,
    required this.versions,
    required this.upvotesCnt,
    required this.downvotesCnt,
    required this.favoritesCnt,
    required this.createdAt,
  });

  factory PromptModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PromptModel(
      promptId: doc.id,
      title: data['title'],
      tags: List<String>.from(data['tags']),
      isPublished: data['is_published'],
      createdBy: data['created_by'],
      versions: List<String>.from(data['versions']),
      upvotesCnt: data['upvotes_cnt'],
      downvotesCnt: data['downvotes_cnt'],
      favoritesCnt: data['favorites_cnt'],
      createdAt: data['created_at'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'tags': tags,
      'is_published': isPublished,
      'created_by': createdBy,
      'versions': versions,
      'upvotes_cnt': upvotesCnt,
      'downvotes_cnt': downvotesCnt,
      'favorites_cnt': favoritesCnt,
      'created_at': createdAt,
    };
  }
}
