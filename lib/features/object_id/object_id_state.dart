import 'package:image_picker/image_picker.dart';

enum ObjectIdStatus { idle, confirmingImage, processing, success, error }

class ObjectIdState {
  final ObjectIdStatus status;
  final XFile? imageFile;
  final String? resultText;
  final String? errorMessage;

  const ObjectIdState({
    this.status = ObjectIdStatus.idle,
    this.imageFile,
    this.resultText,
    this.errorMessage,
  });

  // Helper for copying state safely
  ObjectIdState copyWith({
    ObjectIdStatus? status,
    XFile? imageFile,
    String? resultText,
    String? errorMessage,
  }) {
    return ObjectIdState(
      status: status ?? this.status,
      imageFile: imageFile ?? this.imageFile,
      resultText: resultText ?? this.resultText,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
