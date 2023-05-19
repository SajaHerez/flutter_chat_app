import 'package:file_picker/file_picker.dart';

class MediaService {
  
  Future<PlatformFile?> pickImageFromlibrary() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      return result.files[0];
    }
    return null;
  }
}
