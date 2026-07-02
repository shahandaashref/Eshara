import '../../Domain/entities/add_word_request.dart';
import '../../Domain/repositories/add_word_repository.dart';
import '../datasources/add_word_remote_datasource.dart';

class AddWordRepositoryImpl implements AddWordRepository {
  final AddWordRemoteDataSource remoteDataSource;

  AddWordRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitWordRequest(AddWordRequest request) async {
    return await remoteDataSource.submitWordRequest(request);
  }
}
