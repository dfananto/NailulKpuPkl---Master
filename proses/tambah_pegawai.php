<?php
// File: proses/tambah_pegawai.php
require_once '../config/database.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nama = isset($_POST['nama']) ? strtoupper(escape($_POST['nama'])) : '';
    $nip = isset($_POST['nip']) ? escape($_POST['nip']) : '';
    $jabatan = isset($_POST['jabatan']) ? escape($_POST['jabatan']) : 'Staf Pelaksana';
    $bagian = isset($_POST['bagian']) ? escape($_POST['bagian']) : '';
    
    if (empty($nama) || empty($jabatan)) {
        echo json_encode([
            'success' => false,
            'message' => 'Nama dan jabatan harus diisi!'
        ]);
        exit;
    }
    
    // Cek apakah pegawai sudah ada
    $check_sql = "SELECT id FROM pegawai WHERE nama = '$nama' AND jabatan = '$jabatan'";
    $existing = querySingle($check_sql);
    
    if ($existing) {
        echo json_encode([
            'success' => false,
            'message' => 'Pegawai dengan nama dan jabatan yang sama sudah terdaftar!'
        ]);
        exit;
    }
    
    // Insert pegawai baru
    $sql = "INSERT INTO pegawai (nama, nip, jabatan, bagian, status, created_at) 
            VALUES ('$nama', '$nip', '$jabatan', '$bagian', 'aktif', NOW())";
    
    if (execute($sql)) {
        $id = lastInsertId();
        echo json_encode([
            'success' => true,
            'message' => 'Pegawai berhasil ditambahkan!',
            'id' => $id,
            'nama' => $nama,
            'nip' => $nip,
            'jabatan' => $jabatan,
            'bagian' => $bagian
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Gagal menambahkan pegawai. Silakan coba lagi.'
        ]);
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Metode request tidak valid!'
    ]);
}
?>