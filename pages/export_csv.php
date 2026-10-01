<?php
require_once "../config/db.php";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // 1. Ambil kolom pilihan checkbox dari user, jika kosong berikan opsi default dasar
    $selectedColumns = $_POST['columns'] ?? ['f.fish_name', 'i.island_name', 'r.region_name', 'f.conservation_status', 'g.population'];
    
    // Kamus translasi nama kolom database menjadi nama header yang bersih dan rapi di Excel/CSV
    $headerMapping = [
        'f.fish_name'           => 'Nama Ikan',
        'i.island_name'         => 'Pulau',
        'r.region_name'         => 'Wilayah (Region)',
        'g.population'          => 'Jumlah Populasi',
        'f.phylum'              => 'Phylum',
        'f.class_name'          => 'Class Name',
        'f.order_name'          => 'Order Name',
        'f.family'              => 'Family',
        'f.genus'               => 'Genus',
        'f.habitat'             => 'Habitat',
        'f.size_info'           => 'Informasi Ukuran',
        'f.food'                => 'Makanan',
        'f.conservation_status' => 'Status Konservasi',
        'f.fish_image'          => 'Nama File Gambar'
    ];

    // Bangun potongan perintah kueri SELECT dari array pilihan checkbox
    $selectString = implode(", ", $selectedColumns);

    // 2. Ambil nilai filter dari form dropdown
    $fishId = $_POST['fish_id'] ?? 'all';
    $islandId = $_POST['island_id'] ?? 'all';
    $regionId = $_POST['region_id'] ?? 'all';

    // 3. Bangun struktur query SQL JOIN yang terfokus pada data geografi persebaran ikan
    $sql = "SELECT $selectString 
            FROM MsFishGeo g
            INNER JOIN MsFishDetail f ON g.fish_id = f.fish_id
            INNER JOIN MsRegion r ON g.region_id = r.region_id
            INNER JOIN MsIsland i ON g.island_id = i.island_id
            WHERE 1=1";

    // Gabungkan filter dinamis jika nilainya spesifik (bukan 'all')
    if ($fishId !== 'all') {
        $sql .= " AND g.fish_id = " . intval($fishId);
    }
    if ($islandId !== 'all') {
        $sql .= " AND g.island_id = " . intval($islandId);
    }
    if ($regionId !== 'all') {
        $sql .= " AND g.region_id = " . intval($regionId);
    }

    // Urutkan data secara alfabetis berdasarkan nama ikan dan wilayah pulau
    $sql .= " ORDER BY f.fish_name ASC, i.island_name ASC, r.region_name ASC";

    $result = mysqli_query($conn, $sql);

    // Proteksi error handling: Jika query bermasalah, tampilkan teks debug alih-alih file kosong
    if (!$result) {
        die("Gagal mengeksekusi data ke database: " . mysqli_error($conn));
    }

    // 4. Pengaturan Header HTTP untuk mengunduh dokumen CSV langsung
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename=FindFins_Data_Export_' . date('Ymd_His') . '.csv');

    // Buka berkas output pointer stream PHP
    $output = fopen('php://output', 'w');

    // Tulis baris pertama sebagai Header kolom di dokumen CSV
    $csvHeaders = [];
    foreach ($selectedColumns as $col) {
        $csvHeaders[] = $headerMapping[$col] ?? $col;
    }
    fputcsv($output, $csvHeaders);

    // Masukkan baris data record dari database satu demi satu ke dalam file CSV
    while ($row = mysqli_fetch_assoc($result)) {
        fputcsv($output, $row);
    }
    
    fclose($output);
    exit();
}
?>