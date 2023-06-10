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
  final Map<String, Timestamp> upvotes;
  final Map<String, Timestamp> downvotes;
  final Map<String, Timestamp> favs;

  PromptModel copyWith({
    String? promptId,
    String? title,
    List<String>? tags,
    bool? isPublished,
    String? createdBy,
    List<String>? versions,
    Map<String, Timestamp>? upvotes,
    Map<String, Timestamp>? downvotes,
    Map<String, Timestamp>? favs,
  }) {
    return PromptModel(
      promptId: promptId ?? this.promptId,
      title: title ?? this.title,
      tags: tags ?? this.tags,
      isPublished: isPublished ?? this.isPublished,
      createdBy: createdBy ?? this.createdBy,
      versions: versions ?? this.versions,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      favs: favs ?? this.favs,
    );
  }

  PromptModel({
    required this.promptId,
    required this.title,
    required this.tags,
    required this.isPublished,
    required this.createdBy,
    required this.versions,
    required this.upvotes,
    required this.downvotes,
    required this.favs,
  });

  factory PromptModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PromptModel(
      promptId: doc.id,
      title: data['title'],
      tags: List<String>.from(data['tags']),
      isPublished: data['is_published'],
      createdBy: data['created_by'],
      versions: List<String>.from(data['versions']),
      upvotes: Map<String, Timestamp>.from(data['upvotes']),
      downvotes: Map<String, Timestamp>.from(data['downvotes']),
      favs: Map<String, Timestamp>.from(data['favs']),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'tags': tags,
      'is_published': isPublished,
      'created_by': createdBy,
      'versions': versions,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'favs': favs,
    };
  }
}
