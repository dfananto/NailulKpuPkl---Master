-- Update database untuk sistem yang lebih baik

-- 1. Tambahkan kolom status di tabel pegawai jika belum ada
ALTER TABLE `pegawai` 
ADD COLUMN IF NOT EXISTS `status` VARCHAR(20) DEFAULT 'aktif',
ADD COLUMN IF NOT EXISTS `bagian` VARCHAR(100) DEFAULT '';

-- 2. Update semua pegawai yang ada menjadi aktif
UPDATE `pegawai` SET `status` = 'aktif' WHERE `status` IS NULL;

-- 3. Tambahkan index untuk performa query yang lebih baik
ALTER TABLE `laporan_kinerja` 
ADD INDEX `idx_tanggal` (`tanggal`),
ADD INDEX `idx_id_pegawai` (`id_pegawai`),
ADD INDEX `idx_jenis_penugasan` (`jenis_penugasan`);

ALTER TABLE `pegawai` 
ADD INDEX `idx_status` (`status`),
ADD INDEX `idx_jabatan` (`jabatan`);

-- 4. Tambahkan constraint foreign key jika belum ada
ALTER TABLE `laporan_kinerja`
ADD CONSTRAINT `fk_pegawai` 
FOREIGN KEY (`id_pegawai`) 
REFERENCES `pegawai`(`id`) 
ON DELETE RESTRICT 
ON UPDATE CASCADE;

-- 5. Buat view untuk laporan bulanan
CREATE OR REPLACE VIEW `vw_laporan_bulanan` AS
SELECT 
    DATE_FORMAT(l.tanggal, '%Y-%m') AS bulan,
    p.nama,
    p.jabatan,
    COUNT(l.id) AS total_laporan,
    SUM(CASE WHEN l.jenis_penugasan = 'WFO' THEN 1 ELSE 0 END) AS wfo,
    SUM(CASE WHEN l.jenis_penugasan = 'WFH' THEN 1 ELSE 0 END) AS wfh,
    SUM(CASE WHEN l.jenis_penugasan = 'DL' THEN 1 ELSE 0 END) AS dl
FROM laporan_kinerja l
JOIN pegawai p ON l.id_pegawai = p.id
WHERE p.status = 'aktif'
GROUP BY DATE_FORMAT(l.tanggal, '%Y-%m'), l.id_pegawai
ORDER BY bulan DESC, p.nama ASC;

-- 6. Tambahkan data contoh jika diperlukan
INSERT INTO `pegawai` (`nama`, `nip`, `jabatan`, `bagian`, `status`) VALUES
('ISTADI, S.H', '197001011234567890', 'Sekretaris', 'Sekretariat', 'aktif'),
('FAJAR RANDI YOGANANDA', '197502021234567891', 'Ketua', 'Pimpinan', 'aktif'),
('SITI AMINAH', '198003031234567892', 'Staf Administrasi', 'Bidang Tata Usaha', 'aktif'),
('BUDI SANTOSO', '198104041234567893', 'Staf Teknis', 'Bidang Teknis', 'aktif'),
('DEWI LESTARI', '198205051234567894', 'Staf IT', 'Bidang Teknologi Informasi', 'aktif');

-- 7. Contoh data laporan
INSERT INTO `laporan_kinerja` (`id_pegawai`, `tanggal`, `uraian_tugas`, `hasil_output`, `jenis_penugasan`) VALUES
(1, CURDATE(), 'Menyusun laporan bulanan kinerja pegawai', 'Laporan bulanan selesai 100%', 'WFO'),
(2, CURDATE(), 'Rapat koordinasi persiapan Pilkada', 'Materi rapat telah disiapkan', 'WFO'),
(3, CURDATE(), 'Input data pemilih tetap', '500 data berhasil diinput', 'WFO'),
(4, CURDATE(), 'Pengecekan logistik pemilu', 'Logistik dalam kondisi baik', 'DL'),
(5, CURDATE(), 'Maintenance server aplikasi', 'Server berjalan optimal', 'WFH');