import 'package:test/test.dart';
import 'package:web3libdart/web3libdart.dart';

import '../mock_client.dart';

void main() {
  test('getClientVersion', () async {
    final client = MockClient(expectAsync2((method, data) {
      expect(method, 'web3_clientVersion');
      return 'dart-web3libdart-test';
    }));
    final web3 = Web3Client('', client);
    addTearDown(web3.dispose);

    expect(web3.getClientVersion(), completion('dart-web3libdart-test'));
  });
}
