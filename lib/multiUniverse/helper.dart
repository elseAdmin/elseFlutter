import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/utils/Contants.dart';

class UniverseHelper {
  isUniverseKnown(String UUID) {
    if (DatabaseManager.universeUUIDmap.containsKey(UUID)) return true;
    return false;
  }

  determineUniverse(String UUID) {
    if (isUniverseKnown(UUID)) {
      return DatabaseManager.universeUUIDmap[UUID];
    }
    return "else";
  }

  hasUniverseChanged(String UUID) {
    String currentUniverse = determineUniverse(UUID);
    if (currentUniverse.compareTo(Constants.universe) != 0) {
      Constants.universe = currentUniverse;
      return true;
    }
  }
}
