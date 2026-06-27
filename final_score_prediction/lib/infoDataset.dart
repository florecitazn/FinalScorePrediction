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

            // ── CARD 5: MODEL EVALUATION METRICS (UPDATED) ──
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
                    _buildInfoRow('R² (Coefficient of Determination)', '0.7566'),
                    _buildInfoRow('MAE (Mean Absolute Error)', '4.8983'),
                    _buildInfoRow('MSE (Mean Squared Error)', '39.3036'),
                    _buildInfoRow('RMSE (Root Mean Squared Error)', '6.2693'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: primaryTeal, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'R² = 0.7566 means the model explains 75.66% of the variance in the data.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── CARD 6: TRAINING GRAPH ──
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
                          'Training History',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF26A69A),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildResponsiveImage('assets/images/training_model.png'),
                    const SizedBox(height: 12),
                    Text(
                      'Training Loss and MAE visualization over epochs',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── CARD 7: CORRELATION HEATMAP ──
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
                          child: Icon(Icons.bubble_chart, color: primaryTeal, size: 16),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Feature Correlation Heatmap',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF26A69A),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildResponsiveImage('assets/images/heatmap.png'),
                    const SizedBox(height: 12),
                    Text(
                      'Shows correlation between numerical features and target variable (Final Score)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
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

  // ── HELPER: BUILD INFO ROW ──
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

  // ── HELPER: BUILD RESPONSIVE IMAGE ──
  Widget _buildResponsiveImage(String assetPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        assetPath,
        width: double.infinity,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'Image not found',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  assetPath,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── HELPER: BUILD CATEGORY ROW ──
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

  // ── HELPER: BUILD CHIP ROW ──
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