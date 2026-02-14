<?php
// File: config/database.php
// Koneksi ke database MySQL

$host = "localhost";
$user = "root";
$pass = "";
$dbname = "kpu_pekalongan";

// Membuat koneksi
$koneksi = mysqli_connect($host, $user, $pass, $dbname);

// Cek jika koneksi gagal
if (!$koneksi) {
    die("KONEKSI DATABASE GAGAL! Error: " . mysqli_connect_error());
}

// Set charset ke UTF-8
mysqli_set_charset($koneksi, "utf8mb4");

// Fungsi untuk menjalankan query SELECT
function query($sql) {
    global $koneksi;
    $result = mysqli_query($koneksi, $sql);
    
    if (!$result) {
        die("QUERY ERROR: " . mysqli_error($koneksi));
    }
    
    $rows = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $rows[] = $row;
    }
    
    return $rows;
}

// Fungsi untuk query INSERT, UPDATE, DELETE
function execute($sql) {
    global $koneksi;
    $result = mysqli_query($koneksi, $sql);
    
    if (!$result) {
        die("QUERY ERROR: " . mysqli_error($koneksi));
    }
    
    return mysqli_affected_rows($koneksi);
}

// Fungsi untuk escape string
function escape($data) {
    global $koneksi;
    return mysqli_real_escape_string($koneksi, $data);
}

// Fungsi untuk mengambil satu data saja
function querySingle($sql) {
    global $koneksi;
    $result = mysqli_query($koneksi, $sql);
    
    if (!$result) {
        die("QUERY ERROR: " . mysqli_error($koneksi));
    }
    
    return mysqli_fetch_assoc($result);
}

// Fungsi untuk mendapatkan ID terakhir yang diinsert
function lastInsertId() {
    global $koneksi;
    return mysqli_insert_id($koneksi);
}
?> 