// aid_program.dart
class AidProgram {
  final int programId;
  final String programName;
  final String programDescription;
  final String programType;
  final String programContact;

  AidProgram({
    required this.programId,
    required this.programName,
    required this.programDescription,
    required this.programType,
    required this.programContact,
  });

  factory AidProgram.fromJson(Map<String, dynamic> json) {
    return AidProgram(
      programId: json['programId'],
      programName: json['programName'],
      programDescription: json['programDescription'],
      programType: json['programType'],
      programContact: json['programContact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'programId': programId,
      'programName': programName,
      'programDescription': programDescription,
      'programType': programType,
      'programContact': programContact,
    };
  }
}
