/// The enumeration of all progress states.
/// 
/// Used in controllers to handle ephemeral views via state notifier+ 
enum Progress {

  /// The [loading] state is the first state given to a view.
  /// 
  /// Means that the view is currently fetching, downloading or manipulating some data to be used.
  loading,

  /// The [error] state is thown when the tank could not be finished.
  /// 
  /// It means that the controller could not complete its task.
  error,

  loginRequest,

  /// The state that represents everything is finished and ready to be used.
  /// 
  /// It means the the view is ready to be shown.
  finished;
}