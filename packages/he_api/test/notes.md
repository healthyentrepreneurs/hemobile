# Dio Test Samples

[mock_dio_flutter](https://github.com/shan-shaji/mock_dio_flutter/blob/main/test/unit-test)

[http-mock-adapter example](https://github.com/lomsa-dev/http-mock-adapter/blob/main/example)

[Good Constant Example](https://dhruvnakum.xyz/networking-in-flutter-dio)

[Sample Mock 1](https://github.com/cahyofendhi/Flutter-Cinema/blob/develop/lib/services/service.dart)

[Sample Mock 2](https://github.com/cahyofendhi/Flutter-Cinema)

`void main(List<String> args) async {
// final client = DataCodeApiClient();
final client = DataCodeApiClient(
dio: DataCodeApiClient.dioInit(),
);
var testNa = await client.userLogin('', '');
}`
