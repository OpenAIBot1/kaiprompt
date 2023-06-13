import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class UserModel {
  final String userId;
  final String username;
  final String profilePic;
  final String description;
  final bool isRestricted;
  final List<String> favPrompts;
  final List<String> createdPrompts;
  final Map<String, Timestamp> upvotedPrompts;
  final Map<String, Timestamp> downvotedPrompts;
  final Timestamp createdAt; // new field

  UserModel copyWith({
    String? userId,
    String? username,
    String? profilePic,
    String? description,
    bool? isRestricted,
    List<String>? favPrompts,
    List<String>? createdPrompts,
    Map<String, Timestamp>? upvotedPrompts,
    Map<String, Timestamp>? downvotedPrompts,
    Timestamp? createdAt, // new parameter
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      description: description ?? this.description,
      isRestricted: isRestricted ?? this.isRestricted,
      favPrompts: favPrompts ?? this.favPrompts,
      createdPrompts: createdPrompts ?? this.createdPrompts,
      upvotedPrompts: upvotedPrompts ?? this.upvotedPrompts,
      downvotedPrompts: downvotedPrompts ?? this.downvotedPrompts,
      createdAt: createdAt ?? this.createdAt, // new field assignment
    );
  }

  const UserModel({
    required this.userId,
    required this.username,
    required this.profilePic,
    required this.description,
    required this.isRestricted,
    required this.favPrompts,
    required this.createdPrompts,
    required this.upvotedPrompts,
    required this.downvotedPrompts,
    required this.createdAt, // new field
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      username: data['username'],
      profilePic: data['profile_pic'],
      description: data['description'],
      isRestricted: data['is_restricted'],
      favPrompts: List<String>.from(data['fav_prompts']),
      createdPrompts: List<String>.from(data['created_prompts']),
      upvotedPrompts: Map<String, Timestamp>.from(data['upvoted_prompts']),
      downvotedPrompts: Map<String, Timestamp>.from(data['downvoted_prompts']),
      createdAt: data['created_at'], // new field assignment
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'username': username,
      'profile_pic': profilePic,
      'description': description,
      'is_restricted': isRestricted,
      'fav_prompts': favPrompts,
      'created_prompts': createdPrompts,
      'upvoted_prompts': upvotedPrompts,
      'downvoted_prompts': downvotedPrompts,
      'created_at': createdAt, // new field
    };
  }
}

class UserState {
  final UserModel? user;
  final String? errorMessage;

  UserState copyWith({
    String? userId,
    String? username,
    String? profilePic,
    String? description,
    bool? isRestricted,
    List<String>? favPrompts,
    List<String>? createdPrompts,
    Map<String, Timestamp>? upvotedPrompts,
    Map<String, Timestamp>? downvotedPrompts,
    String? errorMessage,
    Timestamp? createdAt,
  }) {
    return UserState(
      user: user == null
          ? user
          : user!.copyWith(
              userId: userId,
              username: username,
              profilePic: profilePic,
              description: description,
              isRestricted: isRestricted,
              favPrompts: favPrompts,
              createdPrompts: createdPrompts,
              upvotedPrompts: upvotedPrompts,
              downvotedPrompts: downvotedPrompts,
              createdAt: createdAt,
            ),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  UserState({this.user, this.errorMessage});
}
