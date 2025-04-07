import 'package:provider/provider.dart';
import '../data/services/user_service.dart';
void setup() {
  ProviderContainer().read(Provider((ref) => UserService()));
}