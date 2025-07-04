/// A interface that represents all [Hive] boxes.
///
/// This abstraction ensures a consistent API for interacting with Hive boxes, providing methods to open, close, and clear the box.
/// Classes implementing this interface should adhere to these responsibilities and follow Hive's best practices.
abstract interface class IBox {

  /// Clear all data in the box.
  ///
  /// This operation deletes all entries stored in the box, effectively resetting its state.
  /// Use this with caution, as all data will be permanently lost.
  void clear();

  /// Close the Hive box and clear its memory.
  ///
  /// This method releases the resources associated with the box.
  /// However, it is important to follow Hive's guidelines and avoid closing boxes that may still be used later in the application lifecycle.
  void close();
}