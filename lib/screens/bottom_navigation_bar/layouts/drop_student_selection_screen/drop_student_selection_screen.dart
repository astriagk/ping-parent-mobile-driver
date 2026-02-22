import 'package:taxify_driver_ui/api/enums/trip_status_enum.dart';
import 'package:taxify_driver_ui/config.dart';
import 'package:taxify_driver_ui/screens/bottom_navigation_bar/layouts/drop_student_selection_screen/layout/student_card.dart';

class DropStudentSelectionScreen extends StatefulWidget {
  const DropStudentSelectionScreen({super.key});

  @override
  State<DropStudentSelectionScreen> createState() =>
      _DropStudentSelectionScreenState();
}

class _DropStudentSelectionScreenState
    extends State<DropStudentSelectionScreen> {
  late DropStudentSelectionProvider _provider;
  bool _isStartingDrop = false;

  @override
  void initState() {
    super.initState();
    _provider = context.read<DropStudentSelectionProvider>();
    // Defer loading data until after build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStudents();
    });
  }

  /// Fetch students from API
  Future<void> _fetchStudents() async {
    final tripId = _provider.currentTripId;
    if (tripId != null) {
      await _provider.fetchTripStudentsGroupedByParent(tripId);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidgetCommon(text: message),
        duration: const Duration(seconds: 2),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _onStartDropTap() async {
    if (!_provider.hasSelectedStudents()) {
      _showSnackBar('Please select at least one student', isError: true);
      return;
    }

    setState(() => _isStartingDrop = true);

    try {
      // Call school point API to mark students as picked from school
      final response = await _provider.markSchoolPoint();

      if (!mounted) return;

      if (response.success) {
        // Update trip status to started
        if (_provider.currentTripId != null) {
          await _provider.updateTripStatus(
            tripId: _provider.currentTripId!,
            tripStatus: TripStatus.started.value,
          );
        }

        // Navigate to pickup/drop screen with selected students
        // Pass tripId and isDropTrip flag as route arguments
        route.pushNamed(
          context,
          routeName.pickupCustomerScreen,
          arg: {
            'tripId': _provider.currentTripId,
            'isDropTrip': true,
            'tripStatus': TripStatus.started.value,
          },
        );
      } else {
        _showSnackBar(response.message ?? 'Failed to start drop',
            isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isStartingDrop = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DropStudentSelectionProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: CommonAppBarLayout(
            title: language(context, appFonts.selectStudents),
            icon: false,
            onTap: () => route.pop(context),
          ),
          body: _buildBody(provider),
        );
      },
    );
  }

  Widget _buildBody(DropStudentSelectionProvider provider) {
    // Show loading state
    if (provider.isLoading) {
      return const DropStudentSelectionSkeleton();
    }

    // Show error state
    if (provider.errorMessage != null && provider.parentsWithStudents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidgetCommon(
              text: provider.errorMessage!,
              textAlign: TextAlign.center,
            ),
            VSpace(Insets.i20),
            CommonButton(
              text: 'Retry',
              onTap: _fetchStudents,
            ).paddingSymmetric(horizontal: Insets.i40),
          ],
        ),
      );
    }

    // Show empty state
    if (provider.parentsWithStudents.isEmpty) {
      return Center(
        child: TextWidgetCommon(
          text: language(context, appFonts.noStudentsAssigned),
        ),
      );
    }

    // Show student list
    return Column(
      children: [
        // Selection count indicator
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Insets.i20,
            vertical: Insets.i10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mark Attendance',
                style: AppCss.lexendMedium14.textColor(appTheme.lightText),
              ),
              Text(
                '${provider.selectedStudentCount}/${provider.totalStudentCount} Selected',
                style: AppCss.lexendMedium14.textColor(appTheme.primary),
              ),
            ],
          ),
        ),
        // Student list grouped by parent
        Expanded(
          child: ListView.builder(
            itemCount: provider.parentsWithStudents.length,
            itemBuilder: (context, parentIndex) {
              final parent = provider.parentsWithStudents[parentIndex];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student cards for this parent
                  ...parent.students.map((student) {
                    final isSelected =
                        provider.isStudentPresent(student.id);

                    return StudentCard(
                      student: student,
                      parentName: parent.parentName,
                      parentPhoneNumber: parent.parentPhoneNumber,
                      parentPhotoUrl: parent.parentPhotoUrl,
                      isSelected: isSelected,
                      onTap: () {
                        provider.toggleStudentAttendance(student.id);
                      },
                    );
                  }),
                ],
              );
            },
          ),
        ),
        // Start Drop button
        Padding(
          padding: EdgeInsets.all(Insets.i20),
          child: CommonButton(
            text: language(context, appFonts.startDrop),
            onTap: _onStartDropTap,
            isLoading: _isStartingDrop,
            color: provider.hasSelectedStudents()
                ? appTheme.primary
                : appTheme.borderColor,
          ),
        ),
      ],
    );
  }
}
