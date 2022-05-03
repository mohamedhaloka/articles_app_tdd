import 'package:articles_app_tdd/core/platform/network_info.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  MockDataConnectionChecker? mockDataConnectionChecker;
  NetworkInfoImpl? networkInfo;
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker!);
  });

  group('hasConnection', () {
    test('should return value when call hasConnection', () async {
      //append
      const tHasConnection = false;
      when(()=>networkInfo!.isConnected).thenAnswer((_) async=> tHasConnection);
      //act
      final result = await networkInfo!.isConnected;
      //assert
      expect(result, tHasConnection);
      verify(()=>networkInfo!.isConnected);
      verifyNoMoreInteractions(mockDataConnectionChecker);
    });
  });
}
