# Data Warehouse & Mart Build (DuckDB Analytics Engineering Pipeline)

## 📌 Project Overview

Proyek ini dirancang sebagai sarana pembelajaran dan latihan praktis untuk membangun pipeline data (ELT/ETL) secara end-to-end menggunakan SQL. Pipeline ini mensimulasikan proses ekstraksi data lowongan kerja dari penyimpanan cloud (Google Cloud Storage), pemuatan data langsung ke area staging database lokal menggunakan DuckDB, pembentukan skema (_Star Schema_) pada layer Data Warehouse, hingga transformasi data menjadi beberapa Data Mart yang siap dikonsumsi untuk analisis bisnis.

![Data Pipeline Architecture](../images/1_2_Project2_Data_Pipeline.png)

## 🚀 Key Highlights & Portfolio Skills

- **ELT (Extract, Load, Transform) Architecture**: Mengimpor dataset mentah berformat CSV secara langsung dari Google Cloud Storage ke dalam database lokal menggunakan fungsi native `read_csv` dari DuckDB, mendemonstrasikan proses integrasi data cloud secara efisien tanpa memerlukan tahapan penyimpanan lokal manual.
- **Dimensional Modeling**: Merancang skema (_Star Schema_) dengan memisahkan tabel fakta (`job_postings_fact`) dan tabel dimensi (`company_dim`, `skills_dim`, `skills_job_dim`) untuk optimalisasi query analitik dan menjaga integritas relasional data.
- **Advanced SQL & Analytics Engineering**: Memanfaatkan kemampuan DuckDB untuk mengolah tipe data terstruktur kompleks seperti `ARRAY_AGG` dan `STRUCT_PACK` di Data Mart, serta merancang mekanisme sinkronisasi data inkremental (upsert/delete) menggunakan statement `MERGE INTO`.
- **Embedded OLAP Database**: Memilih DuckDB sebagai _columnar analytical engine_ yang ringan, in-process, dan sangat cepat untuk melakukan transformasi data berskala besar langsung di mesin lokal.

## 📐 Data Architecture & Schema Design

![Data Warehouse Schema](../images/1_2_Data_Warehouse.png)

### 1. Data Warehouse (DWH) Layer (Star Schema)

Layer ini memodelkan data mentah ke dalam bentuk skema (_Star Schema_) untuk mengoptimasi relasi tabel dan penyimpanan analitik.

- **Fact Table**: `job_postings_fact` Menyimpan entitas utama data posting pekerjaan analitik termasuk detail gaji dan informasi posting.
- **Dimension Tables**: `company_dim`, `skills_dim`, `skills_job_dim` Menyimpan informasi detail perusahaan dan klasifikasi jenis keterampilan (_skills_).

### 2. Data Mart Layer

Layer ini menyajikan data yang siap dikonsumsi oleh tim Data Analyst atau dashboard visualisasi tanpa perlu melakukan operasi JOIN yang kompleks di sisi pengguna akhir.

- **Flat Mart (`flat_mart.job_postings`)**: Menyatukan data lowongan pekerjaan dengan list skill-nya ke dalam satu tabel terdenormalisasi. Keunikan mart ini adalah pemanfaatan kolom semi-terstruktur (`ARRAY_AGG` dari objek `STRUCT_PACK`) untuk mengelompokkan keterampilan dan tipenya per pekerjaan tanpa memicu duplikasi baris data.
- **Skills Mart (`skills_mart.fact_skill_demand_monthly`)**: Menyajikan data tren permintaan keterampilan per bulan secara kumulatif untuk melacak tren industri, seperti persentase lowongan remote, asuransi kesehatan, dan persyaratan minimal gelar akademik.
- **Priority Mart (`priority_mart.priority_jobs_snapshot`)**: Menyimpan snapshot lowongan pekerjaan yang difilter khusus berdasarkan daftar prioritas posisi (misal: _Data Engineer_, _Senior Data Engineer_) yang dikelola secara dinamis.

## 📁 Pipeline Workflow & Scripts Directory

Berikut adalah urutan eksekusi script SQL untuk membangun pipeline dari awal hingga akhir:

1. **[01_Create_Tables_DW.sql](01_Create_Tables_DW.sql)**: Inisialisasi skema tabel Data Warehouse.
2. **[02_load_schema_dw.sql](02_load_schema_dw.sql)**: Ingest data mentah dari Google Cloud Storage langsung ke DuckDB.
3. **[03_create_flat_mart.sql](03_create_flat_mart.sql)**: Pembuatan Mart denormalisasi (Flat Mart) menggunakan nested aggregation.
4. **[04_create_skills_mart.sql](04_create_skills_mart.sql)**: Pembuatan dimensional model bulanan untuk skill analytics.
5. **[05_create_priority_mart.sql](05_create_priority_mart.sql)**: Pembuatan snapshot mart awal berdasarkan prioritas role pekerjaan.
6. **[06_update_priority_mart.sql](06_update_priority_mart.sql)**: Implementasi pembaruan data secara efisien menggunakan statement `MERGE` (upsert/delete).
7. **[build_dw_marts.sql](build_dw_marts.sql)**: Master script untuk menjalankan seluruh urutan ETL di atas.

## 🛠️ Tech Stack & Tools

- **SQL (DuckDB Dialect)**: Bahasa pemrograman utama untuk transformasi data.
- **DuckDB**: DBMS analitis (OLAP) in-process yang efisien dan cepat.
- **Google Cloud Storage (GCS)**: Host untuk dataset CSV publik yang di-ingest.

## 💡 SQL Showcases

### 1. Complex Array Aggregation & Structs

Untuk men-denormalisasi data lowongan kerja dengan daftar keterampilan tanpa memicu multiplikasi baris (duplikasi data posting untuk setiap _skill_), proyek ini memanfaatkan fitur tipe data semi-terstruktur pada DuckDB menggunakan `ARRAY_AGG` dan `STRUCT_PACK`. Ini membuat data tersimpan sebagai objek array of structs yang ringkas dan sangat efisien untuk di-query.

```sql
CREATE OR REPLACE TABLE flat_mart.job_postings AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    cd.name AS company_name,
    ARRAY_AGG(
        STRUCT_PACK(
            type := sd.type,
            name := sd.skills
        )
    ) AS skills_and_types
FROM
    job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
GROUP BY ALL;
```

### 2. Incremental Update using MERGE

Untuk mensimulasikan pemeliharaan tabel dimensi/mart secara berkala tanpa melakukan kueri penuh yang mahal (_full-refresh_), digunakan statement `MERGE INTO`. Pendekatan ini secara efisien menangani sinkronisasi data (upsert & delete) dalam satu transaksi tunggal berdasarkan sumber data terbaru.

```sql
MERGE INTO priority_mart.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE SET
        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at

WHEN NOT MATCHED THEN
    INSERT (
        job_id,
        job_title_short,
        company_name,
        job_posted_date,
        salary_year_avg,
        priority_lvl,
        updated_at
    )
    VALUES(
        src.job_id,
        src.job_title_short,
        src.company_name,
        src.job_posted_date,
        src.salary_year_avg,
        src.priority_lvl,
        src.updated_at
    )

WHEN NOT MATCHED BY SOURCE THEN DELETE;
```

## 📈 Analytical Business Questions Answered

Beberapa contoh pertanyaan bisnis penting yang dapat dijawab secara efisien dengan rancangan skema Data Mart ini antara lain:

1. Skill apa yang paling banyak dicari untuk posisi Data Engineer yang menawarkan skema kerja WFH?
2. Bagaimana tren bulanan kebutuhan skill tertentu (misal: Python, SQL) sepanjang tahun?
3. Berapa rata-rata gaji untuk lowongan kerja prioritas tingkat 1 (misalnya: Senior Data Engineer)?

## ⚙️ How to Run

1. Pastikan Anda sudah menginstal [DuckDB](https://duckdb.org/).
2. Jalankan perintah berikut di terminal Anda untuk menjalankan seluruh pipeline dan membangun database `dw_marts.duckdb`:
    ```bash
    duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"
    ```
