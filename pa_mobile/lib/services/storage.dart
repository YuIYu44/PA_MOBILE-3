import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<List<List<String>>> get_link(title) async {
    try {
      var result = await _storage.ref().child(title).listAll();

      List<String> urls = await Future.wait(
        result.items.map((Reference ref) => ref.getDownloadURL()),
      );
      List<String> name = result.items
          .map(((Reference ref) =>
              ref.fullPath.split("/")[1].replaceAll(".jpg", "")))
          .toList();
      return [urls, name];
    } catch (e) {
      print('Error listing files: $e');
      return [];
    }
  }

  Future<String> getImage(photoPath) async {
    final ref = await _storage.ref().child(photoPath);
    String url = await ref.getDownloadURL();
    return url;
  }

  deleteImage(photoPath) async {
    await _storage.ref().child(photoPath).delete();
  }
}
