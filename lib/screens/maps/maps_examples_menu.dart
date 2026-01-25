import 'package:taxify_driver_ui/config.dart';

import 'ofm_example_screen.dart';

/// Maps Examples Menu Screen - OpenFreeMap with CartoDB Voyager
class MapsExamplesMenuScreen extends StatelessWidget {
  const MapsExamplesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const OpenFreeMapExampleScreen(),
    );
  }
}
