<?php
    session_start();
    $currentPage = 'search';
?>
<?php
    require_once "../config/db.php";

    $keywordFish = $_GET['fish'] ?? '';
    $keywordRegion = $_GET['region'] ?? '';

    $sql = "
    SELECT DISTINCT
        f.fish_id,
        f.fish_name,
        f.fish_image,
        f.conservation_status,
        r.region_name
    FROM MsFishDetail f
    JOIN MsFishGeo g
    ON f.fish_id = g.fish_id
    JOIN MsRegion r
    ON g.region_id = r.region_id
    WHERE 1=1
    ";

    if($keywordFish != '')
    {
        $sql .= " AND f.fish_name LIKE '%".mysqli_real_escape_string($conn,$keywordFish)."%'";
    }

    if($keywordRegion != '')
    {
        $sql .= " AND r.region_name LIKE '%".mysqli_real_escape_string($conn,$keywordRegion)."%'";
    }

    $result = mysqli_query($conn,$sql);
    $isSearching = ($keywordFish != '' || $keywordRegion != '');
    $rowCount = $isSearching ? mysqli_num_rows($result) : 0;
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="../assets/css/search.css">
    <title>FindFins - Cari Ikan</title>
    <style>
        /* Loading overlay */
        #loadingOverlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.45);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        #loadingOverlay.show {
            display: flex;
        }
        .loading-box {
            background: #fff;
            border-radius: 12px;
            padding: 32px 40px;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0,0,0,0.18);
            min-width: 220px;
        }
        .loading-spinner {
            width: 48px;
            height: 48px;
            border: 5px solid #dbe7ff;
            border-top-color: #0c3b6e;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            margin: 0 auto 16px;
        }
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        .loading-box p {
            color: #0c3b6e;
            font-weight: bold;
            font-size: 15px;
            margin: 0;
        }
        .loading-box small {
            color: #888;
            font-size: 12px;
        }

        /* Notif banner hasil pencarian */
        .search-info-banner {
            display: flex;
            align-items: center;
            gap: 10px;
            background: #e8f0fe;
            border-left: 4px solid #0c3b6e;
            border-radius: 6px;
            padding: 12px 18px;
            margin: 16px 0 8px;
            font-size: 14px;
            color: #0c3b6e;
        }
        .search-info-banner.not-found {
            background: #fff3e0;
            border-left-color: #e65100;
            color: #e65100;
        }
        .search-info-banner .banner-icon {
            font-size: 20px;
            line-height: 1;
        }

        body.dark .loading-box {
            background: #2a2a2a;
            color: #f1f1f1;
        }
        body.dark .loading-box p { color: #64b5f6; }
        body.dark .loading-spinner {
            border-color: #444;
            border-top-color: #64b5f6;
        }
        body.dark .search-info-banner {
            background: #1e2d40;
            border-left-color: #64b5f6;
            color: #90caf9;
        }
        body.dark .search-info-banner.not-found {
            background: #3e2000;
            border-left-color: #ff9800;
            color: #ffb74d;
        }
    </style>
</head>
<body>

    <!-- Loading Overlay -->
    <div id="loadingOverlay">
        <div class="loading-box">
            <div class="loading-spinner"></div>
            <p>🔍 Sedang mencari data ikan...</p>
            <small>Harap tunggu sebentar</small>
        </div>
    </div>

    <div class="topbar">
        <div class="logo">
            <a href="../index.php">🐟 FindFins</a>
        </div>
        <div class="topbar-right">
            <button id="darkModeBtn">
                🌙 Dark Mode
            </button>
            
            <?php if (isset($_SESSION['username'])): ?>
                <span class="user-greeting">
                    Halo, <?= htmlspecialchars($_SESSION['username']) ?>
                </span>
            <?php else: ?>
                <a href="../login.php" class="btn-login">
                    Login
                </a>
            <?php endif; ?>
        </div>
    </div>

    <div class="page-container">

            <aside class="sidebar">
            <a href="search.php" class="<?= $currentPage == 'search' ? 'active' : '' ?>">Cari Ikan & Wilayah</a>
            <a href="filter.php" class="<?= $currentPage == 'filter' ? 'active' : '' ?>">Filter Data</a>
            <a href="peta.php" class="<?= $currentPage == 'peta' ? 'active' : '' ?>">Peta Persebaran</a>
            <a href="detail.php" class="<?= $currentPage == 'detail' ? 'active' : '' ?>">Detail Ikan</a>
            <a href="population.php" class="<?= $currentPage == 'population' ? 'active' : '' ?>">Statistik Populasi</a>
            <a href="collection.php" class="<?= $currentPage == 'collection' ? 'active' : '' ?>">Koleksi Ikan</a>
            <a href="favorite.php" class="<?= $currentPage == 'favorite' ? 'active' : '' ?>">Wilayah Favorit</a>
            <a href="download.php" class="<?= $currentPage == 'download' ? 'active' : '' ?>">Unduh Data</a>
            <a href="notification.php" class="<?= $currentPage == 'notification' ? 'active' : '' ?>">Notifikasi</a>
            <a href="setting.php" class="<?= $currentPage == 'setting' ? 'active' : '' ?>">Pengaturan</a>
        </aside>

    <div class="content">

    <form method="GET" id="searchForm">

        <div class="search-row">

            <input
                type="text"
                name="fish"
                placeholder="Masukkan Nama Ikan..."
                value="<?= htmlspecialchars($keywordFish) ?>">

            <button type="submit">
                Cari
            </button>

        </div>

        <div class="search-row">

            <input
                type="text"
                name="region"
                placeholder="Masukkan Nama Wilayah..."
                value="<?= htmlspecialchars($keywordRegion) ?>">

            <button type="submit">
                Cari
            </button>

        </div>

    </form>

    <h3>Contoh Pencarian Populer</h3>

    <div class="popular-search">

        <a href="?fish=Kerapu">Ikan Kerapu</a>
        <a href="?fish=Tuna">Ikan Tuna</a>
        <a href="?fish=Bandeng">Ikan Bandeng</a>

    </div>

    <hr>

    <h3>Hasil Pencarian</h3>

    <!-- Banner info hasil pencarian -->
    <?php if ($isSearching): ?>
        <?php if ($rowCount > 0): ?>
            <div class="search-info-banner">
                <span class="banner-icon">✅</span>
                <span>Ditemukan <strong><?= $rowCount ?></strong> hasil untuk
                    <?php if ($keywordFish): ?> ikan "<strong><?= htmlspecialchars($keywordFish) ?></strong>"<?php endif; ?>
                    <?php if ($keywordRegion): ?> wilayah "<strong><?= htmlspecialchars($keywordRegion) ?></strong>"<?php endif; ?>
                </span>
            </div>
        <?php else: ?>
            <div class="search-info-banner not-found">
                <span class="banner-icon">⚠️</span>
                <span>Tidak ada data ditemukan untuk
                    <?php if ($keywordFish): ?> ikan "<strong><?= htmlspecialchars($keywordFish) ?></strong>"<?php endif; ?>
                    <?php if ($keywordRegion): ?> wilayah "<strong><?= htmlspecialchars($keywordRegion) ?></strong>"<?php endif; ?>
                </span>
            </div>
        <?php endif; ?>
    <?php endif; ?>

    <div class="search-results"></div>

    <?php while($row = mysqli_fetch_assoc($result)): ?>

    <div class="fish-card">

        <img
            src="../<?= $row['fish_image'] ?>"
            alt="<?= $row['fish_name'] ?>">
            
        <div class="fish-info">

            <h4><?= $row['fish_name'] ?></h4>

            <p>
                Wilayah :
                <?= $row['region_name'] ?>
            </p>

        </div>

        <div class="fish-status">

            Status :
            <span>
                <?= $row['conservation_status'] ?>
            </span>

        </div>

    </div>

    <?php endwhile; ?>

            </div>
    </div>
    </div>

    <script>
        const darkModeBtn = document.getElementById('darkModeBtn');
        if (localStorage.getItem('theme') === 'dark') {
            document.body.classList.add('dark');
            darkModeBtn.textContent = '☀️ Light Mode';
        } else {
            document.body.classList.remove('dark');
            darkModeBtn.textContent = '🌙 Dark Mode';
        }

        darkModeBtn.addEventListener('click', () => {
            document.body.classList.toggle('dark');

            if (document.body.classList.contains('dark')) {
                localStorage.setItem('theme', 'dark');
                darkModeBtn.textContent = '☀️ Light Mode';
            } else {
                localStorage.setItem('theme', 'light');
                darkModeBtn.textContent = '🌙 Dark Mode';
            }
        });

        // Tampilkan loading saat form pencarian di-submit
        const searchForm = document.getElementById('searchForm');
        const loadingOverlay = document.getElementById('loadingOverlay');

        searchForm.addEventListener('submit', function(e) {
            const fishVal = searchForm.querySelector('input[name="fish"]').value.trim();
            const regionVal = searchForm.querySelector('input[name="region"]').value.trim();
            if (fishVal !== '' || regionVal !== '') {
                loadingOverlay.classList.add('show');
            }
        });

        // Tampilkan loading saat klik popular search
        document.querySelectorAll('.popular-search a').forEach(function(link) {
            link.addEventListener('click', function() {
                loadingOverlay.classList.add('show');
            });
        });
    </script>
    
</body>
</html>
