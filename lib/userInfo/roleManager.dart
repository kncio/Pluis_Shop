import 'dart:developer';

import 'roleNames.dart';



class RolePermssionManager {
  //
  static List<String> _userRights = [];
  static List<String> _userRoles = [];
  static List<String> get userRights => _userRights.toList(); //make a copy
  static List<String> get roleTitles => _userRoles.toList(); //make a copy
  //
  static bool get inBadState => _userRights == null || _userRoles == null;

  static void updateRightAndRoles({
    List<String> roleTitles,
    List<String> userRights,
  }) {
    assert(roleTitles != null || userRights != null);
    if (userRights != null) {
      _userRights.clear();
      _userRights.addAll(userRights);
    }
    if (roleTitles != null) {
      _userRoles.clear();
      _userRoles.addAll(roleTitles);
    }
  }

  //< #region User Rights
  static bool havePermissionFor(String permission) {
    assert(permission != null);
    if (RolePermssionManager.inBadState) {
      log('havePermissionFor: Requesting roleName($permission) but bad state encontered ');
      return false;
    }

    if (_userRights.contains(permission) ||
        _userRights.contains(USER_ADMIN_RIGHT)) return true;
    return false;
  }
  //> #endregion

  //< #region User Roles

  static bool isInRoleOf(String roleName) {
    assert(roleName != null);
    if (RolePermssionManager.inBadState) {
      log('isInRoleOf: Requesting roleName($roleName) but bad state encontered ');
      return false;
    }
    if (_userRoles.contains(roleName) ||
        _userRoles.contains(GLOBAL_ADMIN_ROLE_NAME)) return true;
    return false;
  }
//> #endregion
}
