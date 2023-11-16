import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<List<String>> get_link(title) async {
    try {
      var result = await _storage.ref().child(title).listAll();

      List<String> urls = await Future.wait(
        result.items.map((Reference ref) => ref.getDownloadURL()),
      );
      return urls;
    } catch (e) {
      print('Error listing files: $e');
      return [];
    }
  }
}
