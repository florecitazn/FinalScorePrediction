import pandas as pd
import numpy as np

print("\n[1] MEMUAT DATASET ...")
df = pd.read_csv("student_performance_finalscore.csv")
print(f"    Jumlah baris  : {len(df):,}")
print(f"    Jumlah kolom  : {df.shape[1]}")
print(f"\n    Pratinjau 5 baris:")
print(df.head().to_string(index=False))
print(f"\n    Info Tipe Data:")
print(df.dtypes)
print(f"\n    Statistik Deskriptif:")
print(df.describe())
print(df.info())

# REVISI: Mengubah df.null().sum() menjadi df.isnull().sum() agar tidak error
print("\n    Pengecekan Missing Value:")
print(df.isnull().sum())


# =====================================================================
# [2] MENGHITUNG OUTLIER MENGGUNAKAN METODE IQR (INTERQUARTILE RANGE)
# =====================================================================
print("\n[2] MENGHITUNG OUTLIER (METODE IQR) ...")

# REVISI: Memastikan kolom dikonversi ke numerik jika memungkinkan, 
# dan abaikan Student_ID secara eksplisit.
kolom_numerik = df.select_dtypes(include=['int64', 'float64']).columns
if 'Student_ID' in kolom_numerik:
    kolom_numerik = kolom_numerik.drop('Student_ID')

print(f"{'Kolom':<30} | {'Jumlah Outlier':<15} | {'Persentase':<10}")
print("-" * 65)

total_baris = len(df)

for col in kolom_numerik:
    # REVISI: Memastikan tidak ada nilai NaN saat menghitung kuartil
    valid_data = df[col].dropna()
    
    if len(valid_data) == 0:
        continue
        
    # Hitung Kuartil 1 (Q1) dan Kuartil 3 (Q3)
    Q1 = valid_data.quantile(0.25)
    Q3 = valid_data.quantile(0.75)
    
    # Hitung Rentang Jarak Kuartil (IQR)
    IQR = Q3 - Q1
    
    # Tentukan Batas Bawah dan Batas Atas
    batas_bawah = Q1 - 1.5 * IQR
    batas_atas = Q3 + 1.5 * IQR
    
    # Cari data yang berada di luar batas tersebut
    outlier = df[(df[col] < batas_bawah) | (df[col] > batas_atas)]
    jumlah_outlier = len(outlier)
    persentase_outlier = (jumlah_outlier / total_baris) * 100
    
    print(f"{col:<30} | {jumlah_outlier:<15,} | {persentase_outlier:.2f}%")

print("-" * 65)