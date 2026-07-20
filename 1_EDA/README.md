# Exploratory Data Analysis w/ SQL: Job Market Analysis

![Project 1 EDA Overview](../images/1_1_Project1_EDA.png)

Proyek ini menganalisis data lowongan kerja remote untuk menentukan keterampilan (_skills_) Data Engineer yang paling dicari, memiliki gaji tertinggi, dan paling optimal untuk dipelajari.

## Database

![Database Data Warehouse](../images/1_2_Data_Warehouse.png)

## Masalah dan Konteks

Banyak teknologi baru yang bermunculan, membuat kita bingung harus belajar apa dulu. Analisis ini menjawab:

- _Skills_ apa yang paling banyak dicari?
- _Skills_ apa yang gajinya paling tinggi?
- _Skills_ apa yang paling seimbang (optimal) antara permintaan pasar dan gaji?

## Tech
- **SQL**: Alat utama untuk mengolah (*query*), memfilter, dan menganalisis dataset lowongan kerja (menghitung median gaji, menghitung total loker, dan join tabel).

## Analisis

### 1. Keterampilan Paling Dicari (Top In-Demand Skills)

Mencari 10 _skills_ dengan lowongan kerja remote terbanyak.

- **SQL Query:** [01_top_demand_skills.sql](01_top_demand_skills.sql)
- **Hasil:**
    - **SQL** dan **Python** tetap menjadi syarat wajib dan paling dicari.
    - Kebutuhan cloud (**AWS** & **Azure**) menyusul di bawahnya.

---

### 2. Keterampilan dengan Gaji Tertinggi (Top Paying Skills)

Mencari median gaji tahunan untuk _skills_ yang memiliki lebih dari 100 lowongan.

- **SQL Query:** [02_top_paying_skills.sql](02_top_paying_skills.sql)
- **Hasil:**
    - **Rust** dan **Golang** memberikan gaji tertinggi karena jarang yang menguasai.
    - Keterampilan infrastruktur modern seperti **Terraform** dan **Kubernetes** juga dibayar sangat mahal.

---

### 3. Keterampilan Paling Optimal (Optimal Skills to Learn)

Mencari titik temu terbaik antara tingginya permintaan pasar dan besarnya gaji yang ditawarkan.

- **SQL Query:** [03_optimal_skills.sql](03_optimal_skills.sql)
- **Hasil:**
    - **Terraform** dan **Python** adalah pilihan belajar terbaik (gaji tinggi + loker banyak).
    - **Airflow** dan **AWS** menyusul sebagai pendukung utama yang paling direkomendasikan.
