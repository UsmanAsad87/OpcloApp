import 'package:opclo/features/user/profile/profile_extended/add_note/api/notes_api.dart';
import 'package:opclo/models/note_model.dart';

import '../../../../../../commons/common_imports/apis_commons.dart';
import '../../../../../../commons/common_imports/common_libs.dart';
import '../../../../../../commons/common_widgets/show_toast.dart';

import '../../../../../auth/data/auth_apis/auth_apis.dart';

final noteControllerProvider =
    StateNotifierProvider<NoteController, bool>((ref) {
  return NoteController(
    authApis: ref.watch(authApisProvider),
    databaseApis: ref.watch(noteDatabaseApiProvider),
  );
});

final getAllNotesProvider = StreamProvider.family((ref, BuildContext context) {
  final customerCtr = ref.watch(noteControllerProvider.notifier);
  return customerCtr.getAllNotes(context);
});

class NoteController extends StateNotifier<bool> {
  final AuthApis _authApis;
  final NotesDatabaseApi _databaseApis;

  NoteController({
    required AuthApis authApis,
    required NotesDatabaseApi databaseApis,
  })  : _authApis = authApis,
        _databaseApis = databaseApis,
        super(false);

  Future<void> addNote(
    BuildContext context,
    NoteModel noteModel,
  ) async {
    state = true;
    final userId = _authApis.getCurrentUserId();

    final updateNote = noteModel.copyWith(userId: userId);

    final result = await _databaseApis.addNote(noteModel: updateNote);

    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) async {
      state = false;
      showSnackBar(context, 'Note added successfully');
      Navigator.of(context).pop();
    });
  }

  Stream<List<NoteModel>> getAllNotes(
    BuildContext context,
  ) {
    try {
      final userId = _authApis.getCurrentUserId();
      Stream<List<NoteModel>> notes = _databaseApis.getAllNotes(userId ?? '');
      return notes;
    } catch (error) {
      showSnackBar(context, 'Error getting items: $error');
      return const Stream.empty();
      // Handle the error as needed
    }
  }

  Future<void> updateNotes(
    BuildContext context,
    NoteModel noteModel,
  ) async {
    state = true;
    final result = await _databaseApis.updateNote(noteModel: noteModel);
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) {
      state = false;
      showSnackBar(context, 'Note update successfully');
      Navigator.of(context).pop();
    });
  }

  Future<void> deleteNote(context, String noteId) async {
    state = true;
    final userId = _authApis.getCurrentUserId();
    final result = await _databaseApis.deleteNote(userId!, noteId);
    result.fold((l) {
      state = false;
      showSnackBar(context, l.message);
    }, (r) {
      state = false;
      showSnackBar(context, 'Note deleted successfully');
      Navigator.of(context).pop();
    });
  }
}
