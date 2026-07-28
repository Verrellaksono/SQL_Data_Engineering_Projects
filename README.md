# SQL Data Engineering Projects

Ini adalah repositori **SQL Data Engineering Projects**. Repositori ini berisi latihan-latihan terstruktur dan proyek akhir analisis data menggunakan SQL untuk kebutuhan _Data Engineering_ dan _Analytics Engineering_.

---

![Data Warehouse Architecture](./images/1_2_Data_Warehouse.png)

## 📁 Struktur Repositori

Repositiori ini diorganisasikan ke dalam beberapa folder utama sebagai berikut:

### 1. [Lessons](Lessons)

Folder ini berisi modul pembelajaran terstruktur untuk menguasai konsep-konsep SQL dasar hingga tingkat lanjut yang relevan untuk kebutuhan _Data Engineering_:

- **Dasar-Dasar & Pemodelan Data**
    - [**1.9_vscode_intro.sql**](Lessons/1.9/1.9_vscode_intro.sql) - Pengenalan lingkungan kerja menggunakan VS Code.
    - [**1.10_Data_Modeling.sql**](Lessons/1.10/1.10_Data_Modeling.sql) - Latihan pemodelan data (_Data Modeling_).
    - [**1.11_Joins.sql**](Lessons/1.11/1.11_Joins.sql) - Latihan penggabungan tabel (_Joins_).
    - [**1.12_Order.sql**](Lessons/1.12/1.12_Order.sql) - Latihan pengurutan data (_Sorting/Ordering_).
    - [**1.13_Project1_Intro.sql**](Lessons/1.13/1.13_Project1_Intro.sql) - Pendahuluan untuk Proyek 1.
- **Struktur & Manipulasi Data**
    - [**1.20_Data_Types.sql**](Lessons/1.20/1.20_Data_Types.sql) - Pemahaman tipe data dasar di SQL.
    - [**1.21_DDL_DML_Pt1.sql**](Lessons/1.21/1.21_DDL_DML_Pt1.sql) - Latihan DDL (Data Definition Language) bagian 1.
    - [**1.22_DDL_DML_Pt2.sql**](Lessons/1.22/1.22_DDL_DML_Pt2.sql) - Latihan DDL & DML (Data Manipulation Language) bagian 2.
- **Transformasi Lanjutan & Query Kompleks**
    - [**1.23_Subquery_CTE.sql**](Lessons/1.23/1.23_Subquery_CTE.sql) - Latihan penggunaan Subquery dan Common Table Expressions (CTE).
    - **1.24_Priority_Marts_Prep** - Persiapan dataset prioritas kerja & snapshot untuk implementasi incremental loading ([`priority_roles.sql`](Lessons/1.24/priority_roles.sql), [`priority_jobs_snapshot.sql`](Lessons/1.24/priority_jobs_snapshot.sql), [`priority_jobs_snapshot-INITIAL.sql`](Lessons/1.24/priority_jobs_snapshot-INITIAL.sql)).
    - [**1.25_Case_Expression.sql**](Lessons/1.25/1.25_Case_Expression.sql) - Penggunaan ekspresi kondisional `CASE WHEN`.
- **Fungsi SQL Bawaan & Pemrosesan Data**
    - [**1.26_Date_Functions.sql**](Lessons/1.26/1.26_Date_Functions.sql) - Fungsi manipulasi tanggal dan waktu (_Date & Time Functions_).
    - [**1.27_Set_Operators.sql**](Lessons/1.27/1.27_Set_Operators.sql) - Penggunaan operator himpunan (`UNION`, `INTERSECT`, `EXCEPT`).
    - [**1.28_Text_NULL_Functions.sql**](Lessons/1.28/1.28_Text_NULL_Functions.sql) - Fungsi manipulasi teks dan penanganan nilai `NULL`.
- **Analitik Lanjut (Advanced Analytics)**
    - [**1.30_Windows_Functions.sql**](Lessons/1.30/1.30_Windows_Functions.sql) - Window functions analitis (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `PARTITION BY`, dll).
    - [**1.31_Nested_Functions.sql**](Lessons/1.31/1.31_Nested_Functions.sql) - Pengolahan tipe data semi-terstruktur/nested (`ARRAY`, `STRUCT`, `JSON`).

---

### 2. [EDA (Exploratory Data Analysis)](1_EDA)

Proyek Analisis Data Eksploratif mengenai pasar kerja (_Job Market Analysis_) untuk posisi _Data Engineer_. Proyek ini bertujuan untuk mengidentifikasi keterampilan yang paling dicari dan menawarkan kompensasi terbaik. Fokus analisis meliputi:

- [**01_top_demand_skills.sql**](1_EDA/01_top_demand_skills.sql) - Mencari keterampilan (_skills_) yang paling banyak dicari oleh pemberi kerja remote.
- [**02_top_paying_skills.sql**](1_EDA/02_top_paying_skills.sql) - Menganalisis keterampilan dengan penawaran gaji tertinggi.
- [**03_optimal_skills.sql**](1_EDA/03_optimal_skills.sql) - Mengidentifikasi keterampilan paling optimal (titik temu antara permintaan tinggi dan gaji tinggi).
- Detail analisis lengkap dan visualisasi hasil dapat dibaca pada [README Proyek EDA](1_EDA/README.md).

---

### 3. [DW_Mart_Build (Data Warehouse & Mart Build)](2_DW_Mart_Build)

Proyek pembangunan Data Warehouse & Data Mart (Analytics Engineering Pipeline) berbasis Star Schema menggunakan DuckDB. Pipeline data dirancang secara end-to-end dengan alur kerja sebagai berikut:

- **Ingestion (ELT)**: Memuat dataset mentah secara langsung dari Google Cloud Storage ke staging area lokal di DuckDB.
- **Dimensional Modeling**: Membagi data ke dalam tabel fakta (`job_postings_fact`) dan tabel dimensi (`company_dim`, `skills_dim`, `skills_job_dim`) berbasis _Star Schema_.
- **Data Transformation (Data Marts)**:
    - **Flat Mart (`flat_mart.job_postings`)**: Menyatukan posting lowongan kerja dengan daftar skill ke dalam format semi-terstruktur (Array of Structs) tanpa menyebabkan duplikasi baris.
    - **Skills Mart (`skills_mart.fact_skill_demand_monthly`)**: Menganalisis metrik tren kebutuhan skill bulanan.
    - **Priority Mart (`priority_mart.priority_jobs_snapshot`)**: Menyimpan snapshot pekerjaan prioritas secara dinamis.
- **Incremental Loading (`MERGE INTO`)**: Mekanisme sinkronisasi data (upsert & delete) untuk efisiensi pembaruan data berkala.
- Detail implementasi lengkap dan panduan menjalankan pipeline dapat dibaca pada [README Proyek DW Mart Build](2_DW_Mart_Build/README.md).
