-- ============================================
--  FindFins Database
--  Import file ini ke phpMyAdmin
-- ============================================

USE if0_42252420_finfish;

-- ============================================
-- 1. TABEL ACCOUNTS (Login & Register)
-- ============================================
CREATE TABLE accounts (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(100) NOT NULL UNIQUE,
    email       VARCHAR(150) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 2. TABEL MsIsland (Master Pulau)
-- ============================================
CREATE TABLE MsIsland (
    island_id   INT AUTO_INCREMENT PRIMARY KEY,
    island_name VARCHAR(100) NOT NULL
);

INSERT INTO MsIsland (island_name) VALUES
('Sumatera'),
('Jawa'),
('Kalimantan'),
('Sulawesi'),
('Papua'),
('Bali & Nusa Tenggara'),
('Maluku');

-- ============================================
-- 3. TABEL MsRegion (Master Wilayah/Provinsi)
-- ============================================
CREATE TABLE MsRegion (
    region_id   INT AUTO_INCREMENT PRIMARY KEY,
    island_id   INT NOT NULL,
    region_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (island_id) REFERENCES MsIsland(island_id)
);

INSERT INTO MsRegion (island_id, region_name) VALUES
-- Sumatera (island_id=1)
(1, 'Aceh'),
(1, 'Sumatera Utara'),
(1, 'Riau'),
(1, 'Kepulauan Riau'),
(1, 'Sumatera Barat'),
(1, 'Jambi'),
(1, 'Bengkulu'),
(1, 'Sumatera Selatan'),
(1, 'Lampung'),
(1, 'Bangka Belitung'),
-- Jawa (island_id=2)
(2, 'DKI Jakarta'),
(2, 'Jawa Barat'),
(2, 'Jawa Tengah'),
(2, 'DI Yogyakarta'),
(2, 'Jawa Timur'),
(2, 'Banten'),
-- Kalimantan (island_id=3)
(3, 'Kalimantan Barat'),
(3, 'Kalimantan Tengah'),
(3, 'Kalimantan Selatan'),
(3, 'Kalimantan Timur'),
(3, 'Kalimantan Utara'),
-- Sulawesi (island_id=4)
(4, 'Sulawesi Utara'),
(4, 'Sulawesi Tengah'),
(4, 'Sulawesi Selatan'),
(4, 'Sulawesi Tenggara'),
(4, 'Gorontalo'),
(4, 'Sulawesi Barat'),
-- Papua (island_id=5)
(5, 'Papua'),
(5, 'Papua Barat'),
(5, 'Papua Selatan'),
(5, 'Papua Tengah'),
(5, 'Papua Pegunungan'),
-- Bali & Nusa Tenggara (island_id=6)
(6, 'Bali'),
(6, 'Nusa Tenggara Barat'),
(6, 'Nusa Tenggara Timur'),
-- Maluku (island_id=7)
(7, 'Maluku'),
(7, 'Maluku Utara');

-- ============================================
-- 4. TABEL MsFishDetail (Master Data Ikan)
-- ============================================
CREATE TABLE MsFishDetail (
    fish_id             INT AUTO_INCREMENT PRIMARY KEY,
    fish_name           VARCHAR(100) NOT NULL,
    phylum              VARCHAR(100) DEFAULT NULL,
    class_name          VARCHAR(100) DEFAULT NULL,
    order_name          VARCHAR(100) DEFAULT NULL,
    family              VARCHAR(100) DEFAULT NULL,
    genus               VARCHAR(100) DEFAULT NULL,
    habitat             VARCHAR(100) DEFAULT NULL,
    size_info           VARCHAR(150) DEFAULT NULL,
    food                VARCHAR(150) DEFAULT NULL,
    conservation_status enum('Aman','Rentan','Terancam','Kritis') DEFAULT 'Aman',
    fish_image          VARCHAR(255) DEFAULT NULL
);

INSERT INTO MsFishDetail (fish_name, phylum, class_name, order_name, family, genus, habitat, size_info, food, conservation_status, fish_image) VALUES
('Arwana Papua',       'Chordata', 'Actinopterygii', 'Osteoglossiformes', 'Osteoglossidae', 'Scleropages',  'Air Tawar',    'Hingga 90 cm',    'Serangga, Katak',         'Aman',       'assets/img/fishes/arwana-papua.png'),
('Arwana Super Red',   'Chordata', 'Actinopterygii', 'Osteoglossiformes', 'Osteoglossidae', 'Scleropages',  'Air Tawar',    'Hingga 90 cm',    'Serangga, Ikan Kecil',    'Aman',       'assets/img/fishes/arwana-super-red.png'),
('Bandeng',            'Chordata', 'Actinopterygii', 'Gonorynchiformes',  'Chanidae',       'Chanos',       'Air Payau',    '30-180 cm',       'Alga, Plankton',          'Rentan',    'assets/img/fishes/bandeng.png'),
('Cakalang',           'Chordata', 'Actinopterygii', 'Scombriformes',     'Scombridae',     'Katsuwonus',   'Laut',         'Hingga 100 cm',   'Ikan Kecil, Cumi',        'Rentan',    'assets/img/fishes/cakalang.png'),
('Gurame',             'Chordata', 'Actinopterygii', 'Perciformes',       'Osphronemidae',  'Osphronemus',  'Air Tawar',    '20-70 cm',        'Tumbuhan, Serangga',      'Rentan',    'assets/img/fishes/gurame.png'),
('Hiu Paus',           'Chordata', 'Chondrichthyes', 'Orectolobiformes',  'Rhincodontidae', 'Rhincodon',    'Laut',         'Hingga 1200 cm',  'Plankton, Ikan Kecil',    'Terancam',       'assets/img/fishes/hiu-paus.png'),
('Kakap Merah',        'Chordata', 'Actinopterygii', 'Perciformes',       'Lutjanidae',     'Lutjanus',     'Laut',         '30-100 cm',       'Ikan Kecil, Udang',       'Aman',    'assets/img/fishes/kakap-merah.png'),
('Kakap Putih',        'Chordata', 'Actinopterygii', 'Perciformes',       'Latidae',        'Lates',        'Air Payau',    '30-200 cm',       'Ikan Kecil, Udang',       'Aman',    'assets/img/fishes/kakap-putih.png'),
('Kerapu Bebek',       'Chordata', 'Actinopterygii', 'Perciformes',       'Serranidae',     'Cromileptes',  'Laut',         '20-70 cm',        'Ikan Kecil, Crustacea',   'Terancam',       'assets/img/fishes/kerapu-bebek.png'),
('Kerapu Macan',       'Chordata', 'Actinopterygii', 'Perciformes',       'Serranidae',     'Epinephelus',  'Laut',         '30-120 cm',       'Ikan Kecil, Udang',       'Terancam',    'assets/img/fishes/kerapu-macan.png'),
('Lele',               'Chordata', 'Actinopterygii', 'Siluriformes',      'Clariidae',      'Clarias',      'Air Tawar',    '15-60 cm',        'Omnivora',                'Terancam',    'assets/img/fishes/lele.png'),
('Mujair',             'Chordata', 'Actinopterygii', 'Perciformes',       'Cichlidae',      'Oreochromis',  'Air Tawar',    '10-40 cm',        'Alga, Plankton',          'Terancam',    'assets/img/fishes/mujair.png'),
('Napoleon',           'Chordata', 'Actinopterygii', 'Perciformes',       'Labridae',       'Cheilinus',    'Laut',         'Hingga 230 cm',   'Moluska, Crustacea',      'Terancam',       'assets/img/fishes/napoleon.png'),
('Nila',               'Chordata', 'Actinopterygii', 'Perciformes',       'Cichlidae',      'Oreochromis',  'Air Tawar',    '15-50 cm',        'Alga, Plankton',          'Terancam',    'assets/img/fishes/nila.png'),
('Pari Manta',         'Chordata', 'Chondrichthyes', 'Myliobatiformes',   'Mobulidae',      'Mobula',       'Laut',         'Hingga 700 cm',   'Plankton, Zooplankton',   'Rentan',       'assets/img/fishes/pari-manta.png'),
('Patin',              'Chordata', 'Actinopterygii', 'Siluriformes',      'Pangasiidae',    'Pangasius',    'Air Tawar',    '30-150 cm',       'Buah, Serangga, Ikan',    'Terancam',    'assets/img/fishes/patin.png'),
('Sarden',             'Chordata', 'Actinopterygii', 'Clupeiformes',      'Clupeidae',      'Sardinella',   'Laut',         '10-25 cm',        'Plankton, Fitoplankton',  'Terancam',    'assets/img/fishes/sarden.png'),
('Teri',               'Chordata', 'Actinopterygii', 'Clupeiformes',      'Engraulidae',    'Stolephorus',  'Laut',         '5-15 cm',         'Zooplankton',             'Rentan',    'assets/img/fishes/teri.png'),
('Tongkol',            'Chordata', 'Actinopterygii', 'Scombriformes',     'Scombridae',     'Euthynnus',    'Laut',         '30-100 cm',       'Ikan Kecil, Cumi',        'Rentan',    'assets/img/fishes/tongkol.png'),
('Tuna Sirip Kuning',  'Chordata', 'Actinopterygii', 'Scombriformes',     'Scombridae',     'Thunnus',      'Laut',         'Hingga 200 cm',   'Ikan Kecil, Cumi',        'Rentan',  'assets/img/fishes/tuna-sirip-kuning.png');

-- ============================================
-- 5. TABEL MsFishGeo (Persebaran Ikan per Wilayah)
-- ============================================
CREATE TABLE MsFishGeo (
    geo_id      INT AUTO_INCREMENT PRIMARY KEY,
    fish_id     INT NOT NULL,
    island_id   INT NOT NULL,
    region_id   INT NOT NULL,
    population  INT DEFAULT 0,
    FOREIGN KEY (fish_id)   REFERENCES MsFishDetail(fish_id),
    FOREIGN KEY (island_id) REFERENCES MsIsland(island_id),
    FOREIGN KEY (region_id) REFERENCES MsRegion(region_id)
);

INSERT INTO MsFishGeo (fish_id, island_id, region_id, population) VALUES
-- Bandeng (id=3) - tersebar luas
(3, 1, 3,  85000),  -- Riau
(3, 2, 11, 120000), -- DKI Jakarta
(3, 2, 15, 95000),  -- Jawa Timur
(3, 4, 24, 72000),  -- Sulawesi Selatan
(3, 6, 32, 60000),  -- Bali
-- Cakalang (id=4)
(4, 4, 22, 150000), -- Sulawesi Utara
(4, 7, 35, 130000), -- Maluku
(4, 5, 28, 110000), -- Papua
(4, 6, 33, 90000),  -- NTT
-- Gurame (id=5)
(5, 2, 12, 200000), -- Jawa Barat
(5, 2, 13, 180000), -- Jawa Tengah
(5, 2, 15, 170000), -- Jawa Timur
(5, 1, 9,  95000),  -- Lampung
-- Hiu Paus (id=6)
(6, 5, 28, 1200),   -- Papua
(6, 7, 35, 800),    -- Maluku
(6, 6, 33, 600),    -- NTT
-- Kakap Merah (id=7)
(7, 1, 1,  45000),  -- Aceh
(7, 4, 23, 52000),  -- Sulawesi Tengah
(7, 7, 36, 48000),  -- Maluku Utara
(7, 5, 28, 40000),  -- Papua
-- Kakap Putih (id=8)
(8, 2, 11, 75000),  -- DKI Jakarta
(8, 1, 9,  68000),  -- Lampung
(8, 4, 24, 60000),  -- Sulawesi Selatan
-- Kerapu Bebek (id=9)
(9, 7, 35, 15000),  -- Maluku
(9, 5, 28, 12000),  -- Papua
(9, 6, 32, 18000),  -- Bali
-- Kerapu Macan (id=10)
(10, 4, 22, 35000), -- Sulawesi Utara
(10, 7, 35, 40000), -- Maluku
(10, 6, 33, 28000), -- NTT
-- Lele (id=11)
(11, 2, 12, 500000),-- Jawa Barat
(11, 2, 13, 480000),-- Jawa Tengah
(11, 1, 9,  250000),-- Lampung
(11, 3, 17, 180000),-- Kalimantan Barat
-- Mujair (id=12)
(12, 2, 13, 350000),-- Jawa Tengah
(12, 2, 14, 200000),-- DI Yogyakarta
(12, 4, 24, 150000),-- Sulawesi Selatan
-- Napoleon (id=13)
(13, 7, 35, 5000),  -- Maluku
(13, 5, 28, 4000),  -- Papua
(13, 6, 33, 3500),  -- NTT
-- Nila (id=14)
(14, 2, 12, 600000),-- Jawa Barat
(14, 2, 15, 550000),-- Jawa Timur
(14, 4, 24, 300000),-- Sulawesi Selatan
(14, 1, 9,  280000),-- Lampung
-- Pari Manta (id=15)
(15, 6, 33, 2500),  -- NTT
(15, 7, 35, 2000),  -- Maluku
(15, 5, 28, 1800),  -- Papua
-- Patin (id=16)
(16, 1, 8,  180000),-- Sumatera Selatan
(16, 3, 18, 160000),-- Kalimantan Tengah
(16, 2, 15, 140000),-- Jawa Timur
-- Sarden (id=17)
(17, 4, 22, 200000),-- Sulawesi Utara
(17, 7, 35, 180000),-- Maluku
(17, 1, 1,  150000),-- Aceh
-- Teri (id=18)
(18, 4, 22, 300000),-- Sulawesi Utara
(18, 7, 35, 280000),-- Maluku
(18, 1, 3,  220000),-- Riau
-- Tongkol (id=19)
(19, 4, 22, 170000),-- Sulawesi Utara
(19, 1, 1,  150000),-- Aceh
(19, 7, 36, 140000),-- Maluku Utara
-- Tuna Sirip Kuning (id=20)
(20, 7, 35, 80000), -- Maluku
(20, 5, 28, 75000), -- Papua
(20, 4, 22, 70000), -- Sulawesi Utara
-- Arwana Papua (id=1)
(1, 5, 28, 8000),   -- Papua
(1, 5, 29, 6000),   -- Papua Barat
-- Arwana Super Red (id=2)
(2, 3, 17, 7000),   -- Kalimantan Barat
(2, 3, 20, 5500);   -- Kalimantan Timur

-- ============================================
-- 6. TABEL FishPopulationHistory (Statistik Historis)
-- ============================================
CREATE TABLE FishPopulationHistory (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    fish_id     INT NOT NULL,
    island_id   INT NOT NULL,
    year_record INT NOT NULL,
    population  INT DEFAULT 0,
    FOREIGN KEY (fish_id)   REFERENCES MsFishDetail(fish_id),
    FOREIGN KEY (island_id) REFERENCES MsIsland(island_id)
);

INSERT INTO FishPopulationHistory (fish_id, island_id, year_record, population) VALUES
-- Bandeng - Jawa
(3, 2, 2019, 280000),
(3, 2, 2020, 305000),
(3, 2, 2021, 320000),
(3, 2, 2022, 340000),
(3, 2, 2023, 360000),
-- Bandeng - Sulawesi
(3, 4, 2019, 60000),
(3, 4, 2020, 65000),
(3, 4, 2021, 68000),
(3, 4, 2022, 70000),
(3, 4, 2023, 72000),
-- Nila - Jawa
(14, 2, 2019, 900000),
(14, 2, 2020, 980000),
(14, 2, 2021, 1050000),
(14, 2, 2022, 1100000),
(14, 2, 2023, 1150000),
-- Lele - Jawa
(11, 2, 2019, 800000),
(11, 2, 2020, 850000),
(11, 2, 2021, 900000),
(11, 2, 2022, 960000),
(11, 2, 2023, 980000),
-- Tuna Sirip Kuning - Maluku
(20, 7, 2019, 95000),
(20, 7, 2020, 92000),
(20, 7, 2021, 88000),
(20, 7, 2022, 83000),
(20, 7, 2023, 80000),
-- Hiu Paus - Papua
(6, 5, 2019, 1800),
(6, 5, 2020, 1600),
(6, 5, 2021, 1450),
(6, 5, 2022, 1300),
(6, 5, 2023, 1200),
-- Napoleon - Maluku
(13, 7, 2019, 8000),
(13, 7, 2020, 7200),
(13, 7, 2021, 6500),
(13, 7, 2022, 5800),
(13, 7, 2023, 5000),
-- Cakalang - Sulawesi
(4, 4, 2019, 120000),
(4, 4, 2020, 130000),
(4, 4, 2021, 138000),
(4, 4, 2022, 145000),
(4, 4, 2023, 150000);

-- ============================================
-- 7. TABEL fish_collections (Koleksi User)
-- ============================================
CREATE TABLE fish_collections (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    account_id   INT NOT NULL,
    fish_id      INT NOT NULL,
    location     INT NOT NULL COMMENT 'island_id',
    specific_area VARCHAR(150) DEFAULT NULL,
    weight       VARCHAR(50)  DEFAULT NULL,
    description  TEXT         DEFAULT NULL,
    created_at   TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (fish_id)    REFERENCES MsFishDetail(fish_id),
    FOREIGN KEY (location)   REFERENCES MsIsland(island_id)
);
