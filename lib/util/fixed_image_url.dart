import 'app_constants.dart';

String? fixImageUrl(dynamic value) {
  if (value == null || value.toString().trim().isEmpty) {
    return null;
  }

  final image = value.toString().trim();

  if (image.startsWith('https://') ||
      image.startsWith('http://')) {
    return image;
  }

  return '${AppConstants.Image_URL}$image';
}