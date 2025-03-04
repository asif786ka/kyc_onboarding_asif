import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_user_model.freezed.dart';
part 'kyc_user_model.g.dart';

@freezed
class KYCUser with _$KYCUser {
  const factory KYCUser({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String region,
    required KYCStatus status,
    required List<KYCDocument> documents,
    DateTime? verificationDate,
  }) = _KYCUser;

  factory KYCUser.fromJson(Map<String, dynamic> json) =>
      _$KYCUserFromJson(json);
}

@freezed
class KYCDocument with _$KYCDocument {
  const factory KYCDocument({
    required String id,
    required String type,
    required String url,
    required DocumentStatus status,
    required DateTime uploadDate,
    String? rejectionReason,
  }) = _KYCDocument;

  factory KYCDocument.fromJson(Map<String, dynamic> json) =>
      _$KYCDocumentFromJson(json);
}

enum KYCStatus { pending, inProgress, verified, rejected }

enum DocumentStatus { pending, approved, rejected }
