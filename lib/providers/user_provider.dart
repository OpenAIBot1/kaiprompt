import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kaiprompt/models/user.dart';
import 'package:kaiprompt/services/auth_service.dart';
import 'package:kaiprompt/services/user_service.dart';

final userProvider = StateNotifierProvider<UserProvider, UserState>((ref) {
  final authService = ref.read(authServiceProvider.notifier);
  final userId = authService.getCurrentUser()?.uid ?? '';
  return UserProvider(userId: userId);
});

class UserProvider extends StateNotifier<UserState> {
  final String userId;
  final UserService _userService = UserService();

  UserProvider({required this.userId}) : super(UserState()) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (userId.isNotEmpty) {
      final response = await _userService.getUser(userId);
      if (response.error != null) {
        state = UserState(errorMessage: response.error);
      } else {
        state = UserState(user: response.data);
      }
    }
  }

  void upvotePrompt(String promptId) {
    if (state.errorMessage == null) {
      state = state.copyWith(
        upvotedPrompts: {
          ...state.user!.upvotedPrompts,
          promptId: Timestamp.now(),
        },
      );
      saveChanges();
    }
  }

  void downvotePrompt(String promptId) {
    if (state.errorMessage == null) {
      state = state.copyWith(
        downvotedPrompts: {
          ...state.user!.downvotedPrompts,
          promptId: Timestamp.now(),
        },
      );
    }
  }

  void removeUpvote(String promptId) {
    if (state.errorMessage == null) {
      Map<String, Timestamp> updatedUpvotes =
          Map.of(state.user!.upvotedPrompts);
      updatedUpvotes.remove(promptId);
      state = state.copyWith(
        upvotedPrompts: updatedUpvotes,
      );
    }
  }

  void removeDownvote(String promptId) {
    if (state.errorMessage == null) {
      Map<String, Timestamp> updatedDownvotes =
          Map.of(state.user!.downvotedPrompts);
      updatedDownvotes.remove(promptId);
      state = state.copyWith(
        downvotedPrompts: updatedDownvotes,
      );
    }
  }

  void addFavouritePrompt(String promptId) {
    if (state.errorMessage == null) {
      List<String> updatedFavPrompts = List.of(state.user!.favPrompts);
      updatedFavPrompts.add(promptId);
      state = state.copyWith(
        favPrompts: updatedFavPrompts,
      );
    }
  }

  void removeFavouritePrompt(String promptId) {
    if (state.errorMessage == null) {
      List<String> updatedFavPrompts = List.of(state.user!.favPrompts);
      updatedFavPrompts.remove(promptId);
      state = state.copyWith(
        favPrompts: updatedFavPrompts,
      );
    }
  }

  Future<void> saveChanges() async {
    if (state.errorMessage == null) {
      final response = await _userService.updateUser(state.user!);
      if (response.error != null) {
        // Handle the error
        logger.e('Error while saving changes: ${response.error}');
      }
    }
  }
}
