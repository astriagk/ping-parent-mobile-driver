import '../config.dart';

/// Mixin that automatically refreshes data when a pushed route screen
/// is first displayed or when the user navigates back to it.
///
/// Usage:
/// ```dart
/// class _MyScreenState extends State<MyScreen> with AutoRefreshMixin {
///   @override
///   void refreshData() {
///     context.read<MyProvider>().fetchData();
///   }
/// }
/// ```
mixin AutoRefreshMixin<T extends StatefulWidget> on State<T>
    implements RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modal = ModalRoute.of(context);
    if (modal != null) {
      routeObserver.subscribe(this, modal as ModalRoute<void>);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// Override this to fetch fresh data from the API.
  void refreshData();

  @override
  void didPush() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) refreshData();
    });
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) refreshData();
    });
  }

  @override
  void didPop() {}

  @override
  void didPushNext() {}
}
