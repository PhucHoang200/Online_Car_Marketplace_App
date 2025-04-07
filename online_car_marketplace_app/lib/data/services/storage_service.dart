import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final cloudinary = CloudinaryPublic('doohwusyf', 'car_image', cache: false);

  Future<String> uploadImage(XFile image) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl; // URL của ảnh trên Cloudinary
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}