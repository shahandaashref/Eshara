

import 'package:eshara/features/addword/Data/datasources/add_word_remote_datasource.dart';
import 'package:eshara/features/addword/domain/entities/add_word_request.dart';
import 'package:eshara/features/addword/domain/repositories/add_word_repository.dart';

class AddWordRepositoryImpl implements AddWordRepository {
  final AddWordRemoteDataSource remoteDataSource;

  AddWordRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitWordRequest(AddWordRequest request) async {
    return await remoteDataSource.submitWordRequest(request);
  }
}
