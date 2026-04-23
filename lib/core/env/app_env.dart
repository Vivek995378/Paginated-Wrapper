enum Environment { dev, staging, prod }

class AppEnv {
  static Environment _current = Environment.dev;

  static Environment get current => _current;

  static void init(Environment env) {
    _current = env;
  }

  static String get baseUrl {
    switch (_current) {
      case Environment.dev:
        return 'https://jsonplaceholder.typicode.com/';
      case Environment.staging:
        return 'https://jsonplaceholder.typicode.com/';
      case Environment.prod:
        return 'https://jsonplaceholder.typicode.com/';
    }
  }
}
