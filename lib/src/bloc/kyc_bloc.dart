import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../api/api_service.dart';
import '../models/kyc_user_model.dart';

// Events
abstract class KYCEvent extends Equatable {
  const KYCEvent();

  @override
  List<Object?> get props => [];
}

class InitializeKYC extends KYCEvent {
  final String region;

  const InitializeKYC(this.region);

  @override
  List<Object?> get props => [region];
}

class SubmitUserDetails extends KYCEvent {
  final String firstName;
  final String lastName;
  final String email;

  const SubmitUserDetails({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  List<Object?> get props => [firstName, lastName, email];
}

class UploadDocument extends KYCEvent {
  final String documentType;
  final List<int> fileBytes;

  const UploadDocument({
    required this.documentType,
    required this.fileBytes,
  });

  @override
  List<Object?> get props => [documentType, fileBytes];
}

// States
abstract class KYCState extends Equatable {
  const KYCState();

  @override
  List<Object?> get props => [];
}

class KYCInitial extends KYCState {}

class KYCLoading extends KYCState {}

class KYCError extends KYCState {
  final String message;

  const KYCError(this.message);

  @override
  List<Object?> get props => [message];
}

class KYCUserCreated extends KYCState {
  final KYCUser user;

  const KYCUserCreated(this.user);

  @override
  List<Object?> get props => [user];
}

class DocumentUploaded extends KYCState {
  final String documentId;
  final String documentType;

  const DocumentUploaded({
    required this.documentId,
    required this.documentType,
  });

  @override
  List<Object?> get props => [documentId, documentType];
}

// BLoC
class KYCBloc extends Bloc<KYCEvent, KYCState> {
  final KYCApiService _apiService;
  String? _userId;

  KYCBloc({required String region})
      : _apiService = KYCApiService(region: region),
        super(KYCInitial()) {
    on<InitializeKYC>(_onInitializeKYC);
    on<SubmitUserDetails>(_onSubmitUserDetails);
    on<UploadDocument>(_onUploadDocument);
  }

  Future<void> _onInitializeKYC(
    InitializeKYC event,
    Emitter<KYCState> emit,
  ) async {
    emit(KYCLoading());
    // Initialize any region-specific configurations
    emit(KYCInitial());
  }

  Future<void> _onSubmitUserDetails(
    SubmitUserDetails event,
    Emitter<KYCState> emit,
  ) async {
    emit(KYCLoading());
    try {
      final user = KYCUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        region: _apiService.region,
        status: KYCStatus.pending,
        documents: [],
      );

      final createdUser = await _apiService.createKYCUser(user);
      _userId = createdUser.id;
      emit(KYCUserCreated(createdUser));
    } catch (e) {
      emit(KYCError(e.toString()));
    }
  }

  Future<void> _onUploadDocument(
    UploadDocument event,
    Emitter<KYCState> emit,
  ) async {
    if (_userId == null) {
      emit(const KYCError('User not initialized'));
      return;
    }

    emit(KYCLoading());
    try {
      final documentId = await _apiService.uploadDocument(
        _userId!,
        event.documentType,
        event.fileBytes,
      );

      emit(DocumentUploaded(
        documentId: documentId,
        documentType: event.documentType,
      ));
    } catch (e) {
      emit(KYCError(e.toString()));
    }
  }
}
