import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF26A69A);
    const primaryLight = Color(0xFFE8F5E9);
    const bgColor = Color(0xFFF8FAFA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: primaryTeal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Model & Dataset Information',
              style: TextStyle(
                color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── CARD 1: PREPROCESSING PIPELINE ──
            Card(
              color: Colors.white,
              elevation: 0,
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
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: primaryLight,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(Icons.transform, color: primaryTeal, size: 16),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Preprocessing Pipeline',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF26A69A),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildInfoRow('Preprocessor', 'ColumnTransformer (SKLearn)'),
                    _buildInfoRow('Numerical Scaler', 'StandardScaler (Mean=0, Std=1)'),
                    _buildInfoRow('Categorical Encoder', 'OneHotEncoder (drop=None)'),
                    _buildInfoRow('Total Input Features', '29 Nodes'),
                    const SizedBox(height: 12),
                    const Text(
                      '─ Numerical Features (9) ─',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    _buildChipRow([
                      'Age',
                      'Hours Studied',
                      'Attendance',
                      'Sleep Hours',
                      'Stress Level',
                      'Screen Time',
                      'Previous GPA',
                      'Tutoring',
                      'Exam Anxiety'
                    ]),
                    const SizedBox(height: 8),
                    const Text(
                      '─ Categorical Features (7) ─',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    _buildChipRow([
                      'Gender',
                      'Part Time Job',
                      'Study Method',
                      'Diet Quality',
                      'Internet Quality',
                      'Extracurricular',
                      'Family Income'
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── CARD 2: UNIQUE CATEGORIES ──
            Card(
              color: Colors.white,
              elevation: 0,
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
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: primaryLight,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(Icons.category, color: primaryTeal, size: 16),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Unique Categories per Feature',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF26A69A),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildCategoryRow('Gender', ['Female', 'Male', 'Non-Binary'], primaryTeal),
                    _buildCategoryRow('Part Time Job', ['No', 'Yes'], primaryTeal),
                    _buildCategoryRow('Study Method', ['Hybrid', 'Offline', 'Online'], primaryTeal),
                    _buildCategoryRow('Diet Quality', ['Average', 'Good', 'Poor'], primaryTeal),
                    _buildCategoryRow('Internet Quality', ['Average', 'Excellent', 'Good', 'Poor'], primaryTeal),
                    _buildCategoryRow('Extracurricular', ['No', 'Yes'], primaryTeal),
                    _buildCategoryRow('Family Income', ['High', 'Low', 'Middle'], primaryTeal),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── CARD 3: DATASET OVERVIEW ──
            Card(
              color: Colors.white,
              elevation: 0,
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
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: primaryLight,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(Icons.analytics, color: primaryTeal, size: 16),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Dataset Overview',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF26A69A),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildInfoRow('Target Variable', 'Final_Score (Regression)'),
                    _buildInfoRow('Total Features (Original)', '16 Features'),
                    _buildInfoRow('Total Features (Encoded)', '29 Features'),
                    _buildInfoRow('Numerical Features', '9 Columns'),
                    _buildInfoRow('Categorical Features', '7 Columns'),
                    _buildInfoRow('Split Ratio', '60% Train, 20% Val, 20% Test'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── CARD 4: MODEL ARCHITECTURE ──
            Card(
              color: Colors.white,
              elevation: 0,
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
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: primaryLight,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(Icons.memory, color: primaryTeal, size: 16),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Model Architecture',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF26A69A),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildInfoRow('Model Type', 'Deep Neural Network (DNN)'),
                    _buildInfoRow('Input Shape', '29 Nodes (After Encoding)'),
                    _buildInfoRow('Output Layer', '1 Node (Linear Activation)'),
                    _buildInfoRow('Format File', '.keras / .h5'),
                    _buildInfoRow('Preprocessor File', 'preprocessor.pkl'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── CARD 5: MODEL EVALUATION METRICS (COMING SOON) ──
            Card(
              color: Colors.white,
              elevation: 0,
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
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: primaryLight,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(Icons.assessment, color: primaryTeal, size: 16),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Model Evaluation Metrics',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF26A69A),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildComingSoonRow('MAE (Mean Absolute Error)'),
                    _buildComingSoonRow('MSE (Mean Squared Error)'),
                    _buildComingSoonRow('RMSE (Root Mean Squared Error)'),
                    _buildComingSoonRow('R² (Coefficient of Determination)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── CARD 6: TRAINING GRAPH (COMING SOON) ──
            Card(
              color: Colors.white,
              elevation: 0,
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
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: primaryLight,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(Icons.show_chart, color: primaryTeal, size: 16),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Training Graph',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF26A69A),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildComingSoonCenter('Loss & MAE visualization will be displayed here.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── CARD 7: CONFUSION MATRIX (COMING SOON) ──
            Card(
              color: Colors.white,
              elevation: 0,
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
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: primaryLight,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(Icons.grid_on, color: primaryTeal, size: 16),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Confusion Matrix',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF26A69A),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildComingSoonCenter('Confusion matrix visualization will be displayed here.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── CARD 8: TESTING GRAPH (COMING SOON) ──
            Card(
              color: Colors.white,
              elevation: 0,
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
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: primaryLight,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(Icons.timeline, color: primaryTeal, size: 16),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Testing Graph',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF26A69A),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildComingSoonCenter('Testing results visualization will be displayed here.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 13,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonRow(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF26A69A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF26A69A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonCenter(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF26A69A).withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF26A69A).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.construction,
            size: 40,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF26A69A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF26A69A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(String label, List<String> categories, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 4,
              runSpacing: 2,
              children: categories.map((cat) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 11,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipRow(List<String> items) {
    return Wrap(
      spacing: 4,
      runSpacing: 2,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            item,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[700],
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }).toList(),
    );
  }
}