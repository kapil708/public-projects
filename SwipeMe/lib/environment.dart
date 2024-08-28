enum ServerType { develop, production }

// Development Server Config
var developConfig = {
  'API_URL': 'https://fakestoreapi.com',
  'BASE_URL': 'https://fakestoreapi.com',
};

// Production Server Config
var productionConfig = {
  'API_URL': 'https://fakestoreapi.com',
  'BASE_URL': 'https://fakestoreapi.com',
};

class Environment {
  /// Before create a production build change server type
  static ServerType defaultServer = ServerType.production;

  static String getEnvData(key) {
    //printLog("storage : ${getStorage(Session.serverConfig)}");
    //printLog("local : ${(defaultServer == ServerType.develop) ? developConfig : productionConfig}");
    //var serverConfig = getStorage(Session.serverConfig) ?? ((defaultServer == ServerType.develop) ? developConfig : productionConfig);

    var serverConfig = (defaultServer == ServerType.develop) ? developConfig : productionConfig;
    return serverConfig[key].toString();
  }

  /// Static links
  static String get playStoreUrl => '';
  static String get appStoreUrl => '';

  /// For server config
  static String get apiUrl => getEnvData('API_URL');
  static String get baseUrl => getEnvData('BASE_URL');
}
