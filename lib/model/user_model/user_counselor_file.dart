import 'user_counselor_optional_file.dart';

class UserCounselorFile {
  List<UserCounselorOptionalFile>? userCounselorOptionalFiles;

  UserCounselorFile({this.userCounselorOptionalFiles});

  factory UserCounselorFile.fromJson(Map<String, dynamic> json) {
    return UserCounselorFile(
      userCounselorOptionalFiles:
          (json['user_counselor_optional_files'] as List<dynamic>?)
              ?.map((e) =>
                  UserCounselorOptionalFile.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_counselor_optional_files':
            userCounselorOptionalFiles?.map((e) => e.toJson()).toList(),
      };
}
