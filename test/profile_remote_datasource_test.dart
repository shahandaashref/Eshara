import 'package:eshara/Core/Helper/current_user_store.dart';
import 'package:eshara/features/Profile/Data/datasources/profile_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileRemoteDataSource', () {
    test(
      'returns the current registered name and email from the shared user store',
      () async {
        final store = CurrentUserStore.instance;
        store.clear();
        store.setUser(name: 'أميرة عبدالوهاب', email: 'amira@example.com');

        final datasource = ProfileRemoteDataSourceImpl();
        final user = await datasource.getUser();

        expect(user.name, 'أميرة عبدالوهاب');
        expect(user.email, 'amira@example.com');
      },
    );
  });
}
