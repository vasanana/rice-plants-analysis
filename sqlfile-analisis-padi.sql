USE data_tanamanpadi;
SHOW TABLES;

ALTER TABLE padi_sumatera
CHANGE COLUMN `ï»¿Provinsi` Provinsi VARCHAR(255),
CHANGE COLUMN `Luas Panen` Luas_Panen DOUBLE,
CHANGE COLUMN `Curah Hujan` Curah_Hujan DOUBLE,
CHANGE COLUMN `Suhu rata-rata` Suhu_Rerata DOUBLE;

SELECT * FROM padi_sumatera;


-- tren produksi padi sumatera dari tahun ke tahun
SELECT Tahun, 
ROUND(SUM(Produksi), 2) AS 'Total Produksi', 
ROUND(AVG(Produksi), 2) AS 'Rata-Rata Produksi',
ROUND(STDDEV(Produksi), 2) AS 'Variabilitas Produksi'
FROM padi_sumatera
GROUP BY Tahun;

-- informasi produksi per provinsi
SELECT Provinsi,
ROUND(SUM(Produksi), 2) AS 'Total Produksi',
ROUND(AVG(Produksi), 2) AS 'Rata-Rata Hasil Produksi',
MAX(Produksi) AS 'Produksi Tertinggi', 
MIN(Produksi) AS 'Produksi Terendah',
ROUND(SUM(Produksi) / (SELECT SUM(Produksi) FROM padi_sumatera) * 100, 2) AS 'Persentase Kontribusi (%)',
ROUND(((MAX(Produksi) - MIN(Produksi)) / MIN(Produksi)) * 100, 2) AS 'Pertumbuhan Produksi (%)'
FROM padi_sumatera
GROUP BY Provinsi
ORDER BY Provinsi;

-- analisis rasio luas panen terhadap produksi
SELECT Provinsi, 
ROUND(SUM(Luas_Panen), 2) AS 'Luas Panen', 
ROUND(SUM(Produksi), 2) AS 'Total Produksi',
ROUND(SUM(Produksi) / SUM(Luas_Panen), 2) AS Rasio
FROM padi_sumatera
GROUP BY Provinsi
ORDER BY Rasio DESC;


-- analisis korelasi curah hujan, kelembaban, dan suhu terhadap produksi
SELECT Tahun, 
ROUND(AVG(Curah_Hujan), 2) AS 'Curah Hujan',
ROUND(AVG(Kelembapan), 2) AS 'Kelembapan',
ROUND(AVG(Suhu_Rerata), 2) AS 'Suhu',
ROUND(AVG(Produksi), 2) AS "Rata Rata Produksi",
ROUND(
	(COUNT(*) * SUM(Curah_Hujan * Produksi) - SUM(Curah_Hujan) * SUM(Produksi)) /
	SQRT((COUNT(*) * SUM(Curah_Hujan * Curah_Hujan) - (SUM(Curah_Hujan) * SUM(Curah_Hujan))) * 
	(COUNT(*) * SUM(Produksi * Produksi) - (SUM(Produksi) * SUM(Produksi)))), 2) 
    AS 'Korelasi Curah Hujan-Produksi',
ROUND(
	(COUNT(*) * SUM(Kelembapan * Produksi) - SUM(Kelembapan) * SUM(Produksi)) /
	SQRT((COUNT(*) * SUM(Kelembapan * Kelembapan) - (SUM(Kelembapan) * SUM(Kelembapan))) * 
	(COUNT(*) * SUM(Produksi * Produksi) - (SUM(Produksi) * SUM(Produksi)))), 2) 
    AS 'Korelasi Kelembapan-Produksi',
ROUND(
	(COUNT(*) * SUM(Suhu_Rerata * Produksi) - SUM(Suhu_Rerata) * SUM(Produksi)) /
	SQRT((COUNT(*) * SUM(Suhu_Rerata * Suhu_Rerata) - (SUM(Suhu_Rerata) * SUM(Suhu_Rerata))) * 
	(COUNT(*) * SUM(Produksi * Produksi) - (SUM(Produksi) * SUM(Produksi)))), 2) 
    AS 'Korelasi Suhu-Produksi'
FROM padi_sumatera
GROUP BY Tahun;

