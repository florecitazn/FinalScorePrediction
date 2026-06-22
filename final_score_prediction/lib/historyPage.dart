import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> _history = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchHistoryFromSupabase();
  }

  Future<void> _fetchHistoryFromSupabase() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final data = await Supabase.instance.client
          .from('prediction_history')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _history = data;
        _isLoading = false;
      });
    } on PostgrestException catch (error) {
      setState(() {
        _errorMessage = 'Error Supabase (${error.code}): ${error.message}\nDetail: ${error.details}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to connect to Supabase: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDate(String rawDate) {
    if (rawDate.isEmpty) return '-';
    try {
      final date = DateTime.parse(rawDate);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return rawDate.length > 16 ? rawDate.substring(0, 16).replaceAll('T', ' ') : rawDate;
    }
  }

  void _showDetailPopup(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Prediction Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF26A69A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatDate(item['created_at'] ?? ''),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF26A69A),
                          Color(0xFF1B8A7A),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Final Score',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item['final_score_prediction']?.toStringAsFixed(2) ?? '-'}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Student Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Age',
                    item['age']?.toString() ?? '-',
                    Icons.calendar_today,
                  ),
                  _buildDetailRow(
                    'Gender',
                    item['gender'] ?? '-',
                    Icons.person_outline,
                  ),
                  _buildDetailRow(
                    'Previous GPA',
                    item['previous_gpa']?.toStringAsFixed(2) ?? '-',
                    Icons.grade_outlined,
                  ),
                  _buildDetailRow(
                    'Attendance',
                    '${item['attendance']?.toString() ?? '-'}%',
                    Icons.check_circle_outline,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Academic Activity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Hours Studied',
                    '${item['hours_studied']?.toString() ?? '-'} hrs/week',
                    Icons.menu_book_outlined,
                  ),
                  _buildDetailRow(
                    'Study Method',
                    item['study_method'] ?? '-',
                    Icons.school_outlined,
                  ),
                  _buildDetailRow(
                    'Tutoring Sessions',
                    '${item['tutoring_sessions_per_week']?.toString() ?? '-'} /week',
                    Icons.people_outline,
                  ),
                  _buildDetailRow(
                    'Extracurricular',
                    item['extracurricular'] ?? '-',
                    Icons.sports_outlined,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Health & Support',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Sleep Hours',
                    '${item['sleep_hours']?.toString() ?? '-'} hrs',
                    Icons.bedtime_outlined,
                  ),
                  _buildDetailRow(
                    'Stress Level',
                    item['stress_level']?.toString() ?? '-',
                    Icons.psychology_outlined,
                  ),
                  _buildDetailRow(
                    'Screen Time',
                    '${item['screen_time']?.toString() ?? '-'} hrs',
                    Icons.phone_android_outlined,
                  ),
                  _buildDetailRow(
                    'Exam Anxiety',
                    item['exam_anxiety_score']?.toString() ?? '-',
                    Icons.warning_outlined,
                  ),
                  _buildDetailRow(
                    'Diet Quality',
                    item['diet_quality'] ?? '-',
                    Icons.restaurant_outlined,
                  ),
                  _buildDetailRow(
                    'Internet Quality',
                    item['internet_quality'] ?? '-',
                    Icons.wifi_outlined,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Work & Family',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Part Time Job',
                    item['part_time_job'] ?? '-',
                    Icons.work_outline,
                  ),
                  _buildDetailRow(
                    'Family Income',
                    item['family_income_level'] ?? '-',
                    Icons.attach_money_outlined,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF26A69A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF26A69A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFF26A69A),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF26A69A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.history,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Prediction History',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: _fetchHistoryFromSupabase,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF26A69A)))
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchHistoryFromSupabase,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF26A69A),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _history.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.history, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'No prediction history found.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Make a prediction first in the Form tab',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchHistoryFromSupabase,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final item = _history[index];
                          return GestureDetector(
                            onTap: () => _showDetailPopup(context, item),
                            child: Card(
                              color: Colors.white,
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.withOpacity(0.15)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatDate(item['created_at'] ?? ''),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF26A69A).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            'Final Score',
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Color(0xFF26A69A),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${item['gender'] ?? '-'} | ${item['age'] ?? '-'} years old',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'GPA: ${item['previous_gpa']?.toStringAsFixed(2) ?? '-'} | Attendance: ${item['attendance'] ?? '-'}%',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Studied: ${item['hours_studied'] ?? '-'} hrs/week',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Method: ${item['study_method'] ?? '-'}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${item['final_score_prediction']?.toStringAsFixed(2) ?? '-'}',
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF26A69A),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Icon(
                                              Icons.chevron_right,
                                              size: 16,
                                              color: Colors.grey[400],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}