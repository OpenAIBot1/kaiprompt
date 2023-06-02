import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaiprompt/models/user.dart';
import 'package:kaiprompt/services/auth_service.dart';
import 'package:kaiprompt/services/user_service.dart';

final userProvider = StateNotifierProvider<UserProvider, UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider.notifier);
  final userId = authService.getCurrentUser()?.uid ?? '';
  return UserProvider(userId: userId);
});

class UserProvider extends StateNotifier<UserModel?> {
  final String userId;
  final UserService _userService = UserService();

  UserProvider({required this.userId}) : super(null) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (userId.isNotEmpty) {
      final user = await _userService.getUser(userId);
      state = user;
    }
  }

  void upvotePrompt(String promptId) {
    if (state != null) {
      state = state!.copyWith(
        upvotedPrompts: {
          ...state!.upvotedPrompts,
          promptId: Timestamp.now(),
        },
      );
    }
  }

  void downvotePrompt(String promptId) {
    if (state != null) {
      state = state!.copyWith(
        downvotedPrompts: {
          ...state!.downvotedPrompts,
          promptId: Timestamp.now(),
        },
      );
    }
  }

  void removeUpvote(String promptId) {
    if (state != null) {
      Map<String, Timestamp> updatedUpvotes = Map.of(state!.upvotedPrompts);
      updatedUpvotes.remove(promptId);
      state = state!.copyWith(
        upvotedPrompts: updatedUpvotes,
      );
    }
  }

  void removeDownvote(String promptId) {
    if (state != null) {
      Map<String, Timestamp> updatedDownvotes = Map.of(state!.downvotedPrompts);
      updatedDownvotes.remove(promptId);
      state = state!.copyWith(
        downvotedPrompts: updatedDownvotes,
      );
    }
  }

  void addFavouritePrompt(String promptId) {
    if (state != null) {
      List<String> updatedFavPrompts = List.of(state!.favPrompts);
      updatedFavPrompts.add(promptId);
      state = state!.copyWith(
        favPrompts: updatedFavPrompts,
      );
    }
  }

  void removeFavouritePrompt(String promptId) {
    if (state != null) {
      List<String> updatedFavPrompts = List.of(state!.favPrompts);
      updatedFavPrompts.remove(promptId);
      state = state!.copyWith(
        favPrompts: updatedFavPrompts,
      );
    }
  }

  Future<void> saveChanges() async {
    if (state != null) {
      await _userService.updateUser(state!);
    }
  }
}
