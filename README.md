# My-Test-Flutter-Submission

Repository ini merupakan starter project submission kelas Flutter Expert Dicoding Indonesia.

![CI status](https://github.com/andika-andriana/My-Test-Flutter-Submission/actions/workflows/ci.yaml/badge.svg)

---

# CI & Firebase Evidence

- `screenshots/github-actions-success.png` — Hasil build sukses dari GitHub Actions (kriteria CI).
- `screenshots/firebase-analytics-dashboard.png` — Ringkasan Analytics.
- `screenshots/firebase-crashlytics-dashboard.png` — Ringkasan Crashlytics menujukan beberapa test crash.

---

## Continuous Integration

Pipeline GitHub Actions berada di `.github/workflows/ci.yaml`. Workflow ini menjalankan `flutter pub get`, `flutter analyze`, serta `flutter test --coverage`, dan menyimpan laporan cakupan (`coverage/lcov.info`) sebagai artefak. 

## SSL Pinning

Klien HTTP kini menggunakan SSL Pinning. Tambahkan sertifikat TMDB ke folder `assets/certificates/` dengan nama `themoviedb.pem`, kemudian jalankan `flutter pub get`. Sertifikat dapat diekspor menggunakan perintah berikut.

## Firebase Analytics & Crashlytics

Proyek telah menyiapkan integrasi Firebase di `lib/main.dart`. Jalankan `flutterfire configure` dan ganti nilai placeholder pada `lib/firebase_options.dart` agar inisialisasi Firebase berhasil. Setelah itu, tambahkan `google-services.json` (Android) dan `GoogleService-Info.plist` (iOS/MacOS) pada platform masing-masing.

## Modularization

Struktur kode kini dipisahkan menjadi package terdedikasi agar pengembangan dan pengujian tiap fitur dapat dilakukan secara terisolasi:

- `packages/ditonton_core` berisi utilitas lintas fitur seperti konstanta, theme, helper database, failure/exception, serta helper SSL pinning.
- `packages/ditonton_movie` memuat seluruh lapisan domain & data untuk fitur film (entities, use case, repository, data source, dan model DTO).
- `packages/ditonton_tv_series` menampung domain & data untuk fitur serial TV.
- Modul aplikasi utama (`lib/`) hanya menyimpan lapisan presentasi, konfigurasi DI, dan penghubung antar package.

Dengan pemisahan ini, batas dependensi antar fitur menjadi lebih jelas. Setiap package dapat dibangun atau diuji secara mandiri, sementara aplikasi utama cukup merangkai dependency melalui path dependency pada `pubspec.yaml`.