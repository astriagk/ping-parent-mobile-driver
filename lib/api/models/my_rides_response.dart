class MyRidesResponse {
  final bool success;
  final List<DriverStudentAssignment> data;
  final String message;

  MyRidesResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory MyRidesResponse.fromJson(Map<String, dynamic> json) {
    return MyRidesResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<DriverStudentAssignment>.from(
              (json['data'] as List).map(
                (x) => DriverStudentAssignment.fromJson(x),
              ),
            )
          : [],
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((x) => x.toJson()).toList(),
      'message': message,
    };
  }
}

/// Driver-Student Assignment model
class DriverStudentAssignment {
  final String id;
  final String driverId;
  final String studentId;
  final String driverUniqueId;
  final String assignmentStatus;
  final DateTime assignedDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Driver driver;
  final Student student;
  final School school;
  final ParentAddress parentAddress;

  DriverStudentAssignment({
    required this.id,
    required this.driverId,
    required this.studentId,
    required this.driverUniqueId,
    required this.assignmentStatus,
    required this.assignedDate,
    required this.createdAt,
    required this.updatedAt,
    required this.driver,
    required this.student,
    required this.school,
    required this.parentAddress,
  });

  factory DriverStudentAssignment.fromJson(Map<String, dynamic> json) {
    return DriverStudentAssignment(
      id: json['_id'] ?? '',
      driverId: json['driver_id'] ?? '',
      studentId: json['student_id'] ?? '',
      driverUniqueId: json['driver_unique_id'] ?? '',
      assignmentStatus: json['assignment_status'] ?? '',
      assignedDate:
          DateTime.tryParse(json['assigned_date'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      driver: Driver.fromJson(json['driver'] ?? {}),
      student: Student.fromJson(json['student'] ?? {}),
      school: School.fromJson(json['school'] ?? {}),
      parentAddress: ParentAddress.fromJson(json['parent_address'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'driver_id': driverId,
      'student_id': studentId,
      'driver_unique_id': driverUniqueId,
      'assignment_status': assignmentStatus,
      'assigned_date': assignedDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'driver': driver.toJson(),
      'student': student.toJson(),
      'school': school.toJson(),
      'parent_address': parentAddress.toJson(),
    };
  }
}

/// Driver model
class Driver {
  final String id;
  final String userId;
  final String driverUniqueId;
  final String name;
  final String email;
  final String photoUrl;
  final String vehicleType;
  final String vehicleNumber;
  final int vehicleCapacity;
  final int currentStudentCount;
  final String approvalStatus;
  final bool isAvailable;
  final int rating;
  final int totalTrips;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? approvedAt;
  final String? approvedBy;
  final String? rejectionReason;

  Driver({
    required this.id,
    required this.userId,
    required this.driverUniqueId,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleCapacity,
    required this.currentStudentCount,
    required this.approvalStatus,
    required this.isAvailable,
    required this.rating,
    required this.totalTrips,
    required this.createdAt,
    required this.updatedAt,
    this.approvedAt,
    this.approvedBy,
    this.rejectionReason,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      driverUniqueId: json['driver_unique_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      vehicleCapacity: json['vehicle_capacity'] ?? 0,
      currentStudentCount: json['current_student_count'] ?? 0,
      approvalStatus: json['approval_status'] ?? '',
      isAvailable: json['is_available'] ?? false,
      rating: json['rating'] ?? 0,
      totalTrips: json['total_trips'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      approvedAt: json['approved_at'] != null
          ? DateTime.tryParse(json['approved_at'])
          : null,
      approvedBy: json['approved_by'],
      rejectionReason: json['rejection_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'driver_unique_id': driverUniqueId,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'vehicle_capacity': vehicleCapacity,
      'current_student_count': currentStudentCount,
      'approval_status': approvalStatus,
      'is_available': isAvailable,
      'rating': rating,
      'total_trips': totalTrips,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
      'approved_by': approvedBy,
      'rejection_reason': rejectionReason,
    };
  }
}

/// Student model
class Student {
  final String id;
  final String parentId;
  final String schoolId;
  final String studentName;
  final String pickupAddressId;
  final String classLevel;
  final String section;
  final String rollNumber;
  final String gender;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String photoUrl;

  Student({
    required this.id,
    required this.parentId,
    required this.schoolId,
    required this.studentName,
    required this.pickupAddressId,
    required this.classLevel,
    required this.section,
    required this.rollNumber,
    required this.gender,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.photoUrl,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] ?? '',
      parentId: json['parent_id'] ?? '',
      schoolId: json['school_id'] ?? '',
      studentName: json['student_name'] ?? '',
      pickupAddressId: json['pickup_address_id'] ?? '',
      classLevel: json['class'] ?? '',
      section: json['section'] ?? '',
      rollNumber: json['roll_number'] ?? '',
      gender: json['gender'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      photoUrl: json['photo_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'parent_id': parentId,
      'school_id': schoolId,
      'student_name': studentName,
      'pickup_address_id': pickupAddressId,
      'class': classLevel,
      'section': section,
      'roll_number': rollNumber,
      'gender': gender,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'photo_url': photoUrl,
    };
  }
}

/// School model
class School {
  final String id;
  final String schoolName;
  final String address;
  final String state;
  final String city;
  final double latitude;
  final double longitude;
  final String contactNumber;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  School({
    required this.id,
    required this.schoolName,
    required this.address,
    required this.state,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.contactNumber,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['_id'] ?? '',
      schoolName: json['school_name'] ?? '',
      address: json['address'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      contactNumber: json['contact_number'] ?? '',
      email: json['email'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'school_name': schoolName,
      'address': address,
      'state': state,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'contact_number': contactNumber,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Parent Address model
class ParentAddress {
  final String id;
  final String parentId;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final double latitude;
  final double longitude;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;

  ParentAddress({
    required this.id,
    required this.parentId,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParentAddress.fromJson(Map<String, dynamic> json) {
    return ParentAddress(
      id: json['_id'] ?? '',
      parentId: json['parent_id'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isPrimary: json['is_primary'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'parent_id': parentId,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'is_primary': isPrimary,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
