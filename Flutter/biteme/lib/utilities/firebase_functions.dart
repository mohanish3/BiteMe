import 'package:firebase_database/firebase_database.dart';

class FirebaseFunctions {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  static DatabaseReference getTraversedChild(List<String> pathList) {
    DatabaseReference dbRef = _database.reference();
    for (String path in pathList) {
      dbRef = dbRef.child(path);
    }
    return dbRef;
  }
}