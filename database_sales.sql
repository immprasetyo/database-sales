-- Start by creating and populating database with some tables such as "sales", "pelanggan", "penjualan", "daerah", and "suplier_daerah"

CREATE TABLE sales (
	id_sales VARCHAR(10),
	nama_depan VARCHAR(20),
	nama_belakang VARCHAR(20),
	tanggal_lahir DATE,
	jenis_kelamin VARCHAR(1),
	id_daerah VARCHAR(10),
	PRIMARY KEY(id_sales)
);

INSERT INTO sales VALUES ('S001', 'Budi', 'Utomo', '1987-08-06', 'L', 'D002');
INSERT INTO sales VALUES ('S002', 'Daud', 'Firmansyah', '1994-02-26', 'L', 'D001');
INSERT INTO sales VALUES ('S003', 'Freya', 'Azizah', '1999-12-06', 'P', 'D001');
INSERT INTO sales VALUES ('S004', 'Hamzah', 'Yak', '1996-06-16', 'L', 'D003');
INSERT INTO sales VALUES ('S005', 'Ilma', 'Sadiyah', '1999-10-01', 'P', 'D003');
INSERT INTO sales VALUES ('S006', 'Jeka', 'Gesangan', '1990-03-17', 'L', 'D002');


CREATE TABLE penjualan (
	id_sales VARCHAR(10),
	id_pelanggan VARCHAR(10),
	id_daerah VARCHAR(10),
	deal_penjualan INTEGER
);

INSERT INTO penjualan VALUES ('S001', 'P008', 'D002', 5000000);
INSERT INTO penjualan VALUES ('S001', 'P005', 'D002', 4000000);
INSERT INTO penjualan VALUES ('S002', 'P009', 'D001', 6000000);
INSERT INTO penjualan VALUES ('S002', 'P003', 'D001', 2000000);
INSERT INTO penjualan VALUES ('S003', 'P006', 'D001', 2000000);
INSERT INTO penjualan VALUES ('S003', 'P006', 'D001', 4000000);
INSERT INTO penjualan VALUES ('S003', 'P003', 'D001', 8000000);
INSERT INTO penjualan VALUES ('S004', 'P001', 'D003', 5000000);
INSERT INTO penjualan VALUES ('S004', 'P007', 'D003', 7000000);
INSERT INTO penjualan VALUES ('S004', 'P004', 'D003', 3000000);
INSERT INTO penjualan VALUES ('S005', 'P001', 'D003', 1000000);
INSERT INTO penjualan VALUES ('S005', 'P007', 'D003', 9000000);
INSERT INTO penjualan VALUES ('S005', 'P004', 'D003', 6000000);
INSERT INTO penjualan VALUES ('S006', 'P005', 'D002', 3000000);
INSERT INTO penjualan VALUES ('S006', 'P002', 'D002', 1000000);


CREATE TABLE pelanggan (
	id_pelanggan VARCHAR(10),
	nama_depan VARCHAR(20),
	nama_belakang VARCHAR(20),
	PRIMARY KEY(id_pelanggan)
);

INSERT INTO pelanggan VALUES ('P001', 'Amri', 'Sidiq');
INSERT INTO pelanggan VALUES ('P002', 'Cakra', 'Kembar');
INSERT INTO pelanggan VALUES ('P003', 'Eko', 'Ganten');
INSERT INTO pelanggan VALUES ('P004', 'Gendut', 'Doni');
INSERT INTO pelanggan VALUES ('P005', 'Kasino', 'Jekati');
INSERT INTO pelanggan VALUES ('P006', 'Lumpia', 'Kusdini');
INSERT INTO pelanggan VALUES ('P007', 'Muhammad', 'Zuhal');
INSERT INTO pelanggan VALUES ('P008', 'Naryo', 'Reyog');
INSERT INTO pelanggan VALUES ('P009', 'Opi', 'Kumies');


CREATE TABLE daerah (
	id_daerah VARCHAR(10),
	nama_daerah VARCHAR(20),
	PRIMARY KEY(id_daerah)
);

INSERT INTO daerah VALUES ('D001', 'Depok');
INSERT INTO daerah VALUES ('D002', 'Jakarta Barat');
INSERT INTO daerah VALUES ('D003', 'Tangerang Selatan');


CREATE TABLE suplier_daerah (
	id_daerah VARCHAR(10),
	nama_suplier VARCHAR(20),
	tipe_barang VARCHAR(20)
);

INSERT INTO suplier_daerah VALUES ('D001', 'SSD', 'Kertas');
INSERT INTO suplier_daerah VALUES ('D001', 'SSD', 'Pulpen');
INSERT INTO suplier_daerah VALUES ('D002', 'KKY', 'Penghapus');
INSERT INTO suplier_daerah VALUES ('D002', 'KKY', 'Kertas');
INSERT INTO suplier_daerah VALUES ('D003', 'PTT', 'Pulpen');
INSERT INTO suplier_daerah VALUES ('D003', 'PTT', 'Penghapus');


-- Query that displays all collumns in a table using two different ways

SELECT *
FROM sales AS "s", penjualan AS "pj", pelanggan AS "p", daerah AS "d", suplier_daerah AS "sd"
WHERE s.id_sales = pj.id_sales
	AND s.id_daerah = d.id_daerah
	AND pj.id_pelanggan = p.id_pelanggan
	AND d.id_daerah = sd.id_daerah
EXCEPT
SELECT *
FROM sales AS "s" INNER JOIN penjualan AS "pj" ON s.id_sales = pj.id_sales
				  INNER JOIN pelanggan AS "p" ON p.id_pelanggan = pj.id_pelanggan
				  INNER JOIN daerah AS "d" ON s.id_daerah = d.id_daerah
				  INNER JOIN suplier_daerah AS "sd" ON d.id_daerah = sd.id_daerah;


-- Query to return "deal_penjualan" which lesser than "rerata_penjualan_tiap_daerah" using correlated subqueries

SELECT *
FROM (
	SELECT s.nama_depan, s.nama_belakang, s.id_daerah, pj.deal_penjualan, (
		SELECT ROUND(AVG(pj.deal_penjualan))
		FROM penjualan AS "pj"
		WHERE s.id_daerah = pj.id_daerah) AS "rerata_penjualan_tiap_daerah"
	FROM sales AS "s", penjualan AS "pj"
	) AS s001
WHERE s001.deal_penjualan < s001.rerata_penjualan_tiap_daerah
ORDER BY s001.rerata_penjualan_tiap_daerah DESC;


-- Query to find salespersons who are not in "Jakarta Barat" using CASE statement

SELECT s.nama_depan, s.nama_belakang, d.nama_daerah
FROM sales AS "s" LEFT OUTER JOIN daerah AS "d" ON s.id_daerah = d.id_daerah
GROUP BY s.nama_depan, s.nama_belakang, d.nama_daerah
HAVING MAX(CASE
	   	WHEN d.nama_daerah IN ('Jakarta Barat') THEN 1 ELSE 0
	   END) = 0
ORDER BY d.nama_daerah;


-- END, thank you for being here. I hope you have a nice day :)
