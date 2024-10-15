class ApiMethods {
  static String login = '/v1/staff/login';
  static String diningZones = '/v1/staff/dining-zones';
  static String diningTables(zoneId) => '/v1/staff/dining-zones/$zoneId';
  static String menus = '/v1/staff/menus';
  static String menuCourses = '/v1/staff/menu-courses';
  static String menu(id) => '/v1/staff/menus/$id';
  static String addOrderItem(tableId) => '/v1/staff/dining-tables/$tableId/orders/items';
  static String orderItem(tableId, itemId) => '/v1/staff/dining-tables/$tableId/orders/items/$itemId';
  static String tableOrders(tableId) => '/v1/staff/dining-tables/$tableId/orders';
}
