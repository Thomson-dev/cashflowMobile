class UserModel {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String currency;
  final bool whatsappEnabled;
  final bool isSetupComplete;
  
  // Business Information
  final String? businessName;
  final String? businessType;
  final String? location;
  final double? startingCapital;
  final double? monthlyRevenue;
  final double? monthlyExpenses;
  
  // Goals and Preferences
  final String? primaryGoal;
  final double? targetGrowth;
  final bool whatsappAlerts;
  final bool emailReports;
  
  // Financial Data
  final double currentBalance;
  
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.currency = 'USD',
    this.whatsappEnabled = false,
    this.isSetupComplete = false,
    this.businessName,
    this.businessType,
    this.location,
    this.startingCapital,
    this.monthlyRevenue,
    this.monthlyExpenses,
    this.primaryGoal,
    this.targetGrowth,
    this.whatsappAlerts = false,
    this.emailReports = false,
    this.currentBalance = 0.0,
    this.createdAt,
    this.updatedAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'currency': currency,
      'whatsappEnabled': whatsappEnabled,
      'isSetupComplete': isSetupComplete,
      'businessName': businessName,
      'businessType': businessType,
      'location': location,
      'startingCapital': startingCapital,
      'monthlyRevenue': monthlyRevenue,
      'monthlyExpenses': monthlyExpenses,
      'primaryGoal': primaryGoal,
      'targetGrowth': targetGrowth,
      'whatsappAlerts': whatsappAlerts,
      'emailReports': emailReports,
      'currentBalance': currentBalance,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      currency: json['currency'] ?? 'USD',
      whatsappEnabled: json['whatsappEnabled'] ?? false,
      isSetupComplete: json['isSetupComplete'] ?? false,
      businessName: json['businessName'],
      businessType: json['businessType'],
      location: json['location'],
      startingCapital: json['startingCapital']?.toDouble(),
      monthlyRevenue: json['monthlyRevenue']?.toDouble(),
      monthlyExpenses: json['monthlyExpenses']?.toDouble(),
      primaryGoal: json['primaryGoal'],
      targetGrowth: json['targetGrowth']?.toDouble(),
      whatsappAlerts: json['whatsappAlerts'] ?? false,
      emailReports: json['emailReports'] ?? false,
      currentBalance: json['currentBalance']?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  // CopyWith method for updating specific fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    String? currency,
    bool? whatsappEnabled,
    bool? isSetupComplete,
    String? businessName,
    String? businessType,
    String? location,
    double? startingCapital,
    double? monthlyRevenue,
    double? monthlyExpenses,
    String? primaryGoal,
    double? targetGrowth,
    bool? whatsappAlerts,
    bool? emailReports,
    double? currentBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      currency: currency ?? this.currency,
      whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
      isSetupComplete: isSetupComplete ?? this.isSetupComplete,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      location: location ?? this.location,
      startingCapital: startingCapital ?? this.startingCapital,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      targetGrowth: targetGrowth ?? this.targetGrowth,
      whatsappAlerts: whatsappAlerts ?? this.whatsappAlerts,
      emailReports: emailReports ?? this.emailReports,
      currentBalance: currentBalance ?? this.currentBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
