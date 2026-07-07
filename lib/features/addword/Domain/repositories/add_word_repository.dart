

import 'package:eshara/features/addword/domain/entities/add_word_request.dart';

abstract class AddWordRepository {
  Future<void> submitWordRequest(AddWordRequest request);
}
