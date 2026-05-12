import 'package:eshara/features/Dictionary/Domin/entities/sign_entity.dart';


abstract class DictionaryRepository {
  Future<List<SignEntity>> getSignsByCategory(String category);
  Future<List<SignEntity>> searchSigns(String query);
}