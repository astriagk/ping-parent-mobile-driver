import 'package:skolo_driver/api/enums/trip_status_enum.dart';
import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/screens/bottom_navigation_bar/layouts/drop_student_selection_screen/layout/student_card.dart';
import 'package:skolo_driver/core/utils/auto_refresh_mixin.dart';

class DropStudentSelectionScreen extends StatefulWidget {
  const DropStudentSelectionScreen({super.key});

  @override
  State<DropStudentSelectionScreen> createState() =>
      _DropStudentSelectionScreenState();
}

class _DropStudentSelectionScreenState extends State<DropStudentSelectionScreen>
    with AutoRefreshMixin {
  late DropStudentSelectionProvider _provider;
  bool _isStartingDrop = false;
  String? _currentSchoolId;

  // Multi-school tracking
  List<String> _schoolIds = [];
  int _currentSchoolIndex = 0;
  bool get _isMultiSchool => _schoolIds.length > 1;

  @override
  void initState() {
    super.initState();
    _provider = context.read<DropStudentSelectionProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _extractCurrentSchoolId();
  }

  @override
  void refreshData() {
    _fetchStudents();
  }

  /// Extract current school_id and build multi-school list
  /// This supports multi-school drop routes
  void _extractCurrentSchoolId() {
    // Build ordered list of unique school IDs from students
    if (_provider.parentsWithStudents.isNotEmpty && _schoolIds.isEmpty) {
      _schoolIds = _provider.getUniqueSchoolIds();
      if (_schoolIds.isNotEmpty) {
        _currentSchoolIndex = 0;
        _currentSchoolId = _schoolIds[0];
        return;
      }
    }

    // Fallback: check route arguments
    if (_currentSchoolId == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['schoolId'] != null) {
        _currentSchoolId = args['schoolId'].toString();
      }
    }
  }

  /// Fetch students from API
  Future<void> _fetchStudents() async {
    final tripId = _provider.currentTripId;
    if (tripId != null) {
      await _provider.fetchTripStudentsGroupedByParent(tripId);
      // Build school list after students are loaded
      if (_schoolIds.isEmpty) {
        _extractCurrentSchoolId();
        if (mounted) setState(() {});
      }
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

  /// Get school name for given school_id from students data
  String _getSchoolNameForId(
      String? schoolId, DropStudentSelectionProvider provider) {
    if (schoolId == null) return 'Multiple Schools';

    for (var parent in provider.parentsWithStudents) {
      for (var student in parent.students) {
        if (student.schoolId == schoolId && student.schoolName != null) {
          return student.schoolName!;
        }
      }
    }
    return schoolId;
  }

  /// Count total students filtered by school
  int _getFilteredTotalCount(
      DropStudentSelectionProvider provider, String? schoolId) {
    if (schoolId == null) return provider.totalStudentCount;
    return provider.getStudentsForSchool(schoolId).length;
  }

  /// Count selected students filtered by school
  int _getFilteredStudentCount(
      DropStudentSelectionProvider provider, String? schoolId) {
    if (schoolId == null) return provider.selectedStudentCount;

    int count = 0;
    for (var parent in provider.parentsWithStudents) {
      for (var student in parent.students) {
        if (student.schoolId == schoolId && student.isMarkedPresent) {
          count++;
        }
      }
    }
    return count;
  }

  /// Check if current school has any selected students
  bool _hasSelectedStudentsForCurrentSchool() {
    if (_currentSchoolId == null) return _provider.hasSelectedStudents();
    return _provider.getSelectedStudentIdsForSchool(_currentSchoolId!).isNotEmpty;
  }

  Future<void> _onStartDropTap() async {
    if (!_hasSelectedStudentsForCurrentSchool()) {
      _showSnackBar('Please select at least one student', isError: true);
      return;
    }

    setState(() => _isStartingDrop = true);

    try {
      // Call school point API to mark students as picked from this school
      final response =
          await _provider.markSchoolPoint(schoolId: _currentSchoolId);

      if (!mounted) return;

      if (response.success) {
        // Check if there are more schools to process
        if (_isMultiSchool && _currentSchoolIndex < _schoolIds.length - 1) {
          // Advance to the next school
          setState(() {
            _currentSchoolIndex++;
            _currentSchoolId = _schoolIds[_currentSchoolIndex];
            _isStartingDrop = false;
          });
          return;
        }

        // All schools processed — update trip status and navigate to map
        if (_provider.currentTripId != null) {
          await _provider.updateTripStatus(
            tripId: _provider.currentTripId!,
            tripStatus: TripStatus.started.value,
          );
        }

        route.pushNamed(
          context,
          AppRoute.pickupCustomer.path,
          arg: {
            'tripId': _provider.currentTripId,
            'isDropTrip': true,
            'tripStatus': TripStatus.started.value,
            'schoolId': _currentSchoolId,
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
        // School context header (if school_id is known)
        if (_currentSchoolId != null)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Insets.i20,
              vertical: Insets.i12,
            ),
            color: appTheme.primary.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.school, color: appTheme.primary, size: Insets.i20),
                HSpace(Insets.i8),
                Expanded(
                  child: Text(
                    _isMultiSchool
                        ? 'School ${_currentSchoolIndex + 1} of ${_schoolIds.length}: ${_getSchoolNameForId(_currentSchoolId, _provider)}'
                        : 'Picking from: ${_getSchoolNameForId(_currentSchoolId, _provider)}',
                    style: AppCss.lexendMedium13.textColor(appTheme.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
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
                '${_getFilteredStudentCount(_provider, _currentSchoolId)}/${_getFilteredTotalCount(_provider, _currentSchoolId)} Selected',
                style: AppCss.lexendMedium14.textColor(appTheme.primary),
              ),
            ],
          ),
        ),
        // Student list grouped by parent (filtered by school if applicable)
        Expanded(
          child: ListView.builder(
            itemCount: provider.parentsWithStudents.length,
            itemBuilder: (context, parentIndex) {
              final parent = provider.parentsWithStudents[parentIndex];

              // Filter students by current school if school_id is known
              final filteredStudents = _currentSchoolId != null
                  ? parent.students
                      .where((s) => s.schoolId == _currentSchoolId)
                      .toList()
                  : parent.students;

              // Skip parent if no students after filtering
              if (filteredStudents.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student cards for this parent
                  ...filteredStudents.map((student) {
                    final isSelected =
                        provider.isStudentPresent(student.studentId);

                    return StudentCard(
                      student: student,
                      parentName: parent.parentName,
                      parentPhoneNumber: parent.parentPhoneNumber,
                      parentPhotoUrl: parent.parentPhotoUrl,
                      isSelected: isSelected,
                      onTap: () {
                        provider.toggleStudentAttendance(student.studentId);
                      },
                    );
                  }),
                ],
              );
            },
          ),
        ),
        // Start Drop / Pick from School button
        Padding(
          padding: EdgeInsets.all(Insets.i20),
          child: CommonButton(
            text: _isMultiSchool
                ? 'Pick from School (${_currentSchoolIndex + 1}/${_schoolIds.length})'
                : language(context, appFonts.startDrop),
            onTap: _onStartDropTap,
            isLoading: _isStartingDrop,
            color: _hasSelectedStudentsForCurrentSchool()
                ? appTheme.primary
                : appTheme.borderColor,
          ),
        ),
      ],
    );
  }
}
