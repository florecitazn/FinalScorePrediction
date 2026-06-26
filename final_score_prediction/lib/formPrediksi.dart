import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/tflite_service.dart';

class PredictPage extends StatefulWidget {
  @override
  _PredictPageState createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isModelReady = false;
  String _modelMode = 'Loading...';

  // Controllers
  final ageCtrl = TextEditingController();
  final hoursStudiedCtrl = TextEditingController();
  final attendanceCtrl = TextEditingController();
  final sleepHoursCtrl = TextEditingController();
  final stressLevelCtrl = TextEditingController();
  final screenTimeCtrl = TextEditingController();
  final previousGpaCtrl = TextEditingController();
  final tutoringCtrl = TextEditingController();
  final anxietyCtrl = TextEditingController();

  String gender = 'Male';
  String familyIncome = 'Middle';
  String partTimeJob = 'No';
  String studyMethod = 'Offline';
  String dietQuality = 'Average';
  String internetQuality = 'Average';
  String extracurricular = 'No';

  static const Color kPrimary = Color(0xFF26A69A);
  static const Color kPrimaryLight = Color(0xFFE8F5E9);
  static const Color kBg = Color(0xFFF8FAFA);
  static const Color kSurface = Colors.white;
  static const Color kBorder = Color(0xFFE0E0E0);
  static const Color kTextMain = Color(0xFF1A1A2E);
  static const Color kTextMuted = Color(0xFF7C7A9E);

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      final service = TFLiteService();
      await service.initialize();
      setState(() {
        _isModelReady = true;
        _modelMode = service.isUsingTFLite ? 'TFLite (Mobile)' : 'Simulation (Web)';
      });
      print('✅ Service initialized: $_modelMode');
    } catch (e) {
      setState(() {
        _isModelReady = true; // Tetap ready untuk simulasi
        _modelMode = 'Simulation (Fallback)';
      });
      _showErrorSnackBar('Using simulation mode: $e');
    }
  }

  @override
  void dispose() {
    ageCtrl.dispose();
    hoursStudiedCtrl.dispose();
    attendanceCtrl.dispose();
    sleepHoursCtrl.dispose();
    stressLevelCtrl.dispose();
    screenTimeCtrl.dispose();
    previousGpaCtrl.dispose();
    tutoringCtrl.dispose();
    anxietyCtrl.dispose();
    TFLiteService().dispose();
    super.dispose();
  }

  Future<void> _submitPrediction() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_isModelReady) {
      _showErrorSnackBar('Service is not ready');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final Map<String, dynamic> inputData = {
        "Age": int.parse(ageCtrl.text),
        "Gender": gender,
        "Hours_Studied": double.parse(hoursStudiedCtrl.text),
        "Attendance": double.parse(attendanceCtrl.text),
        "Sleep_Hours": double.parse(sleepHoursCtrl.text),
        "Stress_Level": double.parse(stressLevelCtrl.text),
        "Screen_Time": double.parse(screenTimeCtrl.text),
        "Previous_GPA": double.parse(previousGpaCtrl.text),
        "Part_Time_Job": partTimeJob,
        "Study_Method": studyMethod,
        "Diet_Quality": dietQuality,
        "Internet_Quality": internetQuality,
        "Extracurricular": extracurricular,
        "Tutoring_Sessions_Per_Week": double.parse(tutoringCtrl.text),
        "Family_Income_Level": familyIncome,
        "Exam_Anxiety_Score": double.parse(anxietyCtrl.text)
      };

      final double finalScore = await TFLiteService().predict(inputData);
      
      setState(() => _isLoading = false);

      // Save to Supabase
      try {
        await Supabase.instance.client.from('prediction_history').insert({
          'age': int.parse(ageCtrl.text),
          'gender': gender,
          'hours_studied': double.parse(hoursStudiedCtrl.text),
          'attendance': double.parse(attendanceCtrl.text),
          'sleep_hours': double.parse(sleepHoursCtrl.text),
          'stress_level': double.parse(stressLevelCtrl.text),
          'screen_time': double.parse(screenTimeCtrl.text),
          'previous_gpa': double.parse(previousGpaCtrl.text),
          'part_time_job': partTimeJob,
          'study_method': studyMethod,
          'diet_quality': dietQuality,
          'internet_quality': internetQuality,
          'extracurricular': extracurricular,
          'tutoring_sessions_per_week': double.parse(tutoringCtrl.text),
          'family_income_level': familyIncome,
          'exam_anxiety_score': double.parse(anxietyCtrl.text),
          'final_score_prediction': finalScore,
        });
        print('✅ Data saved to Supabase');
      } on PostgrestException catch (e) {
        print('❌ Supabase Error: ${e.message}');
        if (e.code != '42501') {
          _showErrorSnackBar("Failed to save history: ${e.message}");
        }
      } catch (e) {
        print('❌ Error saving to Supabase: $e');
      }

      _showResultPopup(context, finalScore);
      
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar("Prediction failed: $e");
    }
  }

  void _showResultPopup(BuildContext context, double finalScore) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Final Score Prediction',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey, size: 24),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: Colors.grey[200], height: 1),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF26A69A), Color(0xFF1B8A7A)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '${finalScore.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mode: $_modelMode',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPrimaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: kPrimary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Prediction using AI model simulation.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'New Prediction',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 6),
      ),
    );
  }

  // ── SECTION HEADER ──
  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: kPrimaryLight,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, color: kPrimary, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: kPrimary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // ── TEXT FIELD ──
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    bool isNumeric = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: kTextMuted,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontSize: 14, color: kTextMain, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: kTextMuted.withOpacity(0.6), fontSize: 13),
            fillColor: kSurface,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorder, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE53E3E), width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE53E3E), width: 1.5),
            ),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  // ── DROPDOWN FIELD ──
  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: kTextMuted,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: kTextMuted, size: 20),
          style: const TextStyle(fontSize: 14, color: kTextMain, fontWeight: FontWeight.w500),
          dropdownColor: kSurface,
          borderRadius: BorderRadius.circular(12),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            fillColor: kSurface,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorder, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ── CHIP SELECTOR ──
  Widget _buildChipField({
    required String label,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: kTextMuted,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((option) {
            final isActive = selected == option;
            return GestureDetector(
              onTap: () => onSelect(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  color: isActive ? kPrimary : kSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? kPrimary : kBorder,
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : kTextMuted,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kSurface,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.show_chart_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Prediction of Student Performance Scores',
                style: TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: -0.3,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            // Indikator mode
            Tooltip(
              message: _modelMode,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _modelMode.contains('TFLite') 
                      ? Colors.green.withOpacity(0.1) 
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _modelMode.contains('TFLite') 
                        ? Colors.green 
                        : Colors.orange,
                    width: 1,
                  ),
                ),
                child: Text(
                  _modelMode.contains('TFLite') ? 'AI' : 'SIM',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: _modelMode.contains('TFLite') 
                        ? Colors.green 
                        : Colors.orange,
                  ),
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: kBorder),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── SECTION 1: STUDENT INFORMATION ──
              _buildSectionHeader(Icons.person_outline_rounded, "Student Information"),
              const SizedBox(height: 14),

              Row(children: [
                Expanded(child: _buildTextField(ageCtrl, "Age", "20", isNumeric: true)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(previousGpaCtrl, "Previous GPA", "3.5", isNumeric: true)),
              ]),
              const SizedBox(height: 12),

              _buildDropdownField(
                "Family Income Level",
                familyIncome,
                ['Low', 'Middle', 'High'],
                (val) => setState(() => familyIncome = val!),
              ),
              const SizedBox(height: 16),

              _buildChipField(
                label: "Gender",
                options: ['Male', 'Female', 'Non-Binary'],
                selected: gender,
                onSelect: (val) => setState(() => gender = val),
              ),
              const SizedBox(height: 16),

              _buildChipField(
                label: "Part Time Job",
                options: ['No', 'Yes'],
                selected: partTimeJob,
                onSelect: (val) => setState(() => partTimeJob = val),
              ),

              const SizedBox(height: 28),

              // ── SECTION 2: ACADEMIC ACTIVITY ──
              _buildSectionHeader(Icons.menu_book_outlined, "Academic Activity"),
              const SizedBox(height: 14),

              Row(children: [
                Expanded(child: _buildTextField(hoursStudiedCtrl, "Hours Studied / week", "20", isNumeric: true)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(attendanceCtrl, "Attendance (%)", "85", isNumeric: true)),
              ]),
              const SizedBox(height: 12),

              Row(children: [
                Expanded(child: _buildTextField(tutoringCtrl, "Tutoring Sessions / week", "2", isNumeric: true)),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    "Study Method",
                    studyMethod,
                    ['Offline', 'Online', 'Hybrid'],
                    (val) => setState(() => studyMethod = val!),
                  ),
                ),
              ]),
              const SizedBox(height: 16),

              _buildChipField(
                label: "Extracurricular",
                options: ['No', 'Yes'],
                selected: extracurricular,
                onSelect: (val) => setState(() => extracurricular = val),
              ),

              const SizedBox(height: 28),

              // ── SECTION 3: HEALTH & SUPPORT ──
              _buildSectionHeader(Icons.favorite_border_rounded, "Health & Support"),
              const SizedBox(height: 14),

              Row(children: [
                Expanded(child: _buildTextField(sleepHoursCtrl, "Sleep Hours", "7", isNumeric: true)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(stressLevelCtrl, "Stress Level", "5", isNumeric: true)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(screenTimeCtrl, "Screen Time (hrs)", "3", isNumeric: true)),
              ]),
              const SizedBox(height: 12),

              Row(children: [
                Expanded(child: _buildTextField(anxietyCtrl, "Exam Anxiety Score", "4", isNumeric: true)),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    "Diet Quality",
                    dietQuality,
                    ['Poor', 'Average', 'Good'],
                    (val) => setState(() => dietQuality = val!),
                  ),
                ),
              ]),
              const SizedBox(height: 12),

              _buildDropdownField(
                "Internet Quality",
                internetQuality,
                ['Poor', 'Average', 'Good', 'Excellent'],
                (val) => setState(() => internetQuality = val!),
              ),

              const SizedBox(height: 16),

              // Info mode
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _modelMode.contains('TFLite') 
                      ? Colors.green.withOpacity(0.05) 
                      : Colors.orange.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _modelMode.contains('TFLite') 
                        ? Colors.green.withOpacity(0.2) 
                        : Colors.orange.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _modelMode.contains('TFLite') 
                          ? Icons.memory 
                          : Icons.cloud_queue,
                      size: 14,
                      color: _modelMode.contains('TFLite') 
                          ? Colors.green 
                          : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mode: $_modelMode',
                        style: TextStyle(
                          fontSize: 11,
                          color: _modelMode.contains('TFLite') 
                              ? Colors.green[700] 
                              : Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── PREDICT BUTTON ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: (_isLoading || !_isModelReady) ? null : _submitPrediction,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isModelReady ? Icons.auto_awesome_rounded : Icons.warning_rounded,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isModelReady ? 'Predict Final Score' : 'Loading Model...',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.2),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}