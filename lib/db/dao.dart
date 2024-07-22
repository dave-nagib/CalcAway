import 'database_connection.dart';

abstract class DAO<T> {
  // Databse connection singleton
  DatabaseConnection databaseConnection = DatabaseConnection();

  /// Fetches an instance from the database given its key. Returns object representation of instance on success and null on failure.
  Future<T?> get(Object id);

  /// Returns a list of multiple instances in the database with filtering options. Returns null on error.
  Future<List<T>?> getMultiple(String? where, List<String>? whereArgs);

  /// Creates an instance in the database. Returns instance with generated id on success and null on failure.
  Future<T?> add(T t);

  /// Updates an instance that already exists in the database with the given object representation. Returns number of affected rows on success and -1 on error.
  Future<int> update(T t);

  /// Deletes an instance that already exists in the database with the given object representation. Returns number of affected rows on success and -1 on error.
  Future<int> delete(T t);

}