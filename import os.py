import os

# List of all files to create
files_to_create = [
    "main.dart",
    "config/routes.dart",
    "models/user.dart",
    "models/prompt.dart",
    "models/version.dart",
    "screens/auth/login_screen.dart",
    "screens/auth/signup_screen.dart",
    "screens/auth/forgot_password_screen.dart",
    "screens/auth/password_reset_screen.dart",
    "screens/error/error_screen.dart",
    "screens/home/loading_screen.dart",
    "screens/home/catalogue_main_screen.dart",
    "screens/profile/profile_view_screen.dart",
    "screens/prompt/prompt_details_screen.dart",
    "screens/prompt/prompt_main_editing_screen.dart",
    "screens/prompt/prompt_publishing_screen.dart",
    "screens/support/support_main_screen.dart",
    "screens/support/contributors_screen.dart",
    "screens/contact/contact_form_screen.dart",
    "screens/contact/confirmation_screen.dart",
    "screens/about/about_future_plans_screen.dart",
    "screens/about/service_agreement_screen.dart",
    "services/auth_service.dart",
    "services/user_service.dart",
    "services/prompt_service.dart",
    "services/version_service.dart",
    "widgets/reusable_components.dart",
    "providers/user_provider.dart",
    "providers/prompt_provider.dart",
    "providers/version_provider.dart",
]

# Root directory for the files
root_dir = "lib/"

for file_path in files_to_create:
    # Create the directory if it doesn't exist
    os.makedirs(os.path.dirname(root_dir + file_path), exist_ok=True)

    # Create the file
    with open(root_dir + file_path, "w") as f:
        pass
