import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../../commons/common_providers/global_providers.dart';
import '../../../../../../core/constants/firebase_constants.dart';
import '../../../../../../models/note_model.dart';

final noteDatabaseApiProvider = Provider<NotesDatabaseApi>((ref) {
  final firebase = ref.watch(firebaseDatabaseProvider);
  return NotesDatabaseApi(firebase: firebase);
});

class NotesDatabaseApi {
  final FirebaseFirestore _firestore;

//
  NotesDatabaseApi({required FirebaseFirestore firebase})
      : _firestore = firebase;

  FutureEitherVoid addNote({required NoteModel noteModel}) async {
    try {
      CollectionReference noteRef =
          _firestore.collection(FirebaseConstants.noteCollection);
      await noteRef.doc(noteModel.id).set(noteModel.toMap());
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occure', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  Stream<List<NoteModel>> getAllNotes(String userId) {
    try {
      CollectionReference noteRef = _firestore
          .collection(FirebaseConstants.noteCollection);

      return noteRef.where('userId', isEqualTo: userId).snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return NoteModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (error) {
      return const Stream.empty();
    }
  }

  FutureEitherVoid updateNote({
    required NoteModel noteModel,
  }) async {
    try {
      CollectionReference noteRef = _firestore
          .collection(FirebaseConstants.noteCollection);

      // Update existing company
      await noteRef.doc(noteModel.id).update(noteModel.toMap());

      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occure', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }

  FutureEitherVoid deleteNote(String userId, String noteId) async {
    try {
      final CollectionReference productRef = _firestore
          .collection(FirebaseConstants.noteCollection);
      await productRef.doc(noteId).delete();

      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Firebase error occure', stackTrace));
    } catch (e, stackTrace) {
      return Left(Failure(e.toString(), stackTrace));
    }
  }
}
