import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/kyc_bloc.dart';
import '../models/kyc_user_model.dart';

class KYCScreen extends StatefulWidget {
  final String region;

  const KYCScreen({Key? key, required this.region}) : super(key: key);

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  int _currentStep = 0;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          KYCBloc(region: widget.region)..add(InitializeKYC(widget.region)),
      child: BlocConsumer<KYCBloc, KYCState>(
        listener: (context, state) {
          if (state is KYCError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is KYCUserCreated) {
            setState(() => _currentStep = 1);
          } else if (state is DocumentUploaded) {
            setState(() => _currentStep = 2);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('KYC Verification'),
            ),
            body: Stepper(
              currentStep: _currentStep,
              onStepContinue: () => _handleStepContinue(context),
              onStepCancel: () => setState(() {
                if (_currentStep > 0) _currentStep--;
              }),
              steps: [
                _buildPersonalInfoStep(),
                _buildDocumentUploadStep(),
                _buildVerificationStep(),
              ],
            ),
          );
        },
      ),
    );
  }

  Step _buildPersonalInfoStep() {
    return Step(
      title: const Text('Personal Information'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value!)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
    );
  }

  Step _buildDocumentUploadStep() {
    return Step(
      title: const Text('Document Upload'),
      content: Column(
        children: [
          ElevatedButton.icon(
            onPressed:
                _currentStep == 1 ? () => _uploadDocument(context) : null,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload ID Document'),
          ),
        ],
      ),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
    );
  }

  Step _buildVerificationStep() {
    return Step(
      title: const Text('Verification'),
      content: const Center(
        child: Text(
          'Your documents are being verified. We will notify you once the verification is complete.',
          textAlign: TextAlign.center,
        ),
      ),
      isActive: _currentStep >= 2,
      state: StepState.indexed,
    );
  }

  void _handleStepContinue(BuildContext context) {
    switch (_currentStep) {
      case 0:
        if (_formKey.currentState?.validate() ?? false) {
          context.read<KYCBloc>().add(
                SubmitUserDetails(
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  email: _emailController.text,
                ),
              );
        }
        break;
      case 1:
        _uploadDocument(context);
        break;
      case 2:
        // Final step - nothing to do
        break;
    }
  }

  Future<void> _uploadDocument(BuildContext context) async {
    // In a real app, you would use a proper file picker here
    // This is just a placeholder implementation
    final dummyFileBytes = List<int>.filled(100, 0);
    context.read<KYCBloc>().add(
          UploadDocument(
            documentType: 'passport',
            fileBytes: dummyFileBytes,
          ),
        );
  }
}
