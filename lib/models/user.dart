import 'package:cloud_firestore/cloud_firestore.dart';

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

  UserModel({
    required this.userId,
    required this.username,
    required this.profilePic,
    required this.description,
    required this.isRestricted,
    required this.favPrompts,
    required this.createdPrompts,
    required this.upvotedPrompts,
    required this.downvotedPrompts,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'],
      username: map['username'],
      profilePic: map['profile_pic'],
      description: map['description'],
      isRestricted: map['is_restricted'],
      favPrompts: List<String>.from(map['fav_prompts']),
      createdPrompts: List<String>.from(map['created_prompts']),
      upvotedPrompts: Map<String, Timestamp>.from(map['upvoted_prompts']),
      downvotedPrompts: Map<String, Timestamp>.from(map['downvoted_prompts']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'username': username,
      'profile_pic': profilePic,
      'description': description,
      'is_restricted': isRestricted,
      'fav_prompts': favPrompts,
      'created_prompts': createdPrompts,
      'upvoted_prompts': upvotedPrompts,
      'downvoted_prompts': downvotedPrompts,
    };
  }
}
