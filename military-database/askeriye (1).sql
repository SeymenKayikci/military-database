-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: localhost:8889
-- Üretim Zamanı: 26 Ara 2022, 18:50:07
-- Sunucu sürümü: 5.7.34
-- PHP Sürümü: 7.4.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `askeriye`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Sorgu_1` ()  SELECT * FROM urunler
INNER JOIN stoklar ON urunler.urun_id = stoklar.stok_urun_id WHERE urunler.urun_fiyati BETWEEN 10 and 20
ORDER BY urun_fiyati ASC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu_2` ()  SELECT urun_kategorisi FROM urunler
INNER JOIN stoklar ON urunler.urun_id = stoklar.stok_urun_id WHERE stoklar.stok_miktari > 10 AND urunler.urun_fiyati < 20 GROUP BY urunler.urun_kategorisi$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu_3` ()  SELECT urunler.urun_kategorisi FROM urunler
INNER JOIN stoklar ON urunler.urun_id = stoklar.stok_urun_id WHERE stoklar.stok_miktari IN (10, 20)
GROUP BY urunler.urun_kategorisi
HAVING urunler.urun_adi LIKE "canta"$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu_4` ()  SELECT araclar.arac_markasi,COUNT(araclar.arac_id) FROM araclar
INNER JOIN arac_suruculeri ON araclar.arac_id= arac_suruculeri.surucu_id WHERE araclar.arac_kapasitesi=5
GROUP BY arac_markasi$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu_5` ()  SELECT araclar.arac_markasi FROM araclar
INNER JOIN arac_suruculeri ON araclar.arac_id= arac_suruculeri.surucu_id WHERE araclar.arac_yili IN ('2008', '2012')
GROUP BY araclar.arac_markasi
HAVING arac_suruculeri.surucu_ad LIKE "seymen"$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu_6` ()  SELECT araclar.arac_markasi FROM arac_suruculeri
INNER JOIN araclar ON arac_suruculeri.surucu_id = araclar.arac_id
WHERE araclar.arac_yili < 2012
GROUP BY araclar.arac_markasi
HAVING arac_suruculeri.surucu_ehliyet_sinifi LIKE "B%"$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu_7` ()  SELECT birimler.birim_adi FROM birimler
INNER JOIN calisanlar ON birimler.birim_id = calisanlar.birim_id
WHERE calisanlar.calisan_dogum_tarihi < "1992-01-01"
GROUP BY birimler.birim_adi
HAVING birimler.birim_aciklamasi LIKE "Erbas rutbesinin ilk basamagi%"$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu_8` ()  SELECT birimler.birim_adi,COUNT(calisan_id) FROM calisanlar
INNER JOIN birimler ON calisanlar.birim_id = birimler.birim_id
WHERE calisanlar.calisan_dogum_tarihi BETWEEN "1992-01-01" AND "2000-01-01" GROUP BY birimler.birim_adi$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sorgu_9` ()  SELECT birimler.birim_aciklamasi FROM birimler
INNER JOIN calisanlar ON birimler.birim_id = calisanlar.birim_id
WHERE calisanlar.calisan_dogum_tarihi < "1998-01-01" AND birimler.birim_adi LIKE "Albay" GROUP BY birimler.birim_aciklamasi$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `araclar`
--

CREATE TABLE `araclar` (
  `arac_id` int(11) NOT NULL,
  `arac_markasi` varchar(255) DEFAULT NULL,
  `arac_yili` int(11) DEFAULT NULL,
  `arac_kapasitesi` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `araclar`
--

INSERT INTO `araclar` (`arac_id`, `arac_markasi`, `arac_yili`, `arac_kapasitesi`) VALUES
(1, '4x4 Meskun Mahal Mudahale Araci', 2015, 5),
(2, '8x8 Cok Maksatli Hafif Arazi Araci', 2019, 4),
(3, 'Kirpi', 2020, 8),
(4, 'STM500 Kucuk Tonajlı Denizalti', 2022, 24),
(5, 'Marlin Silahli Insansiz Deniz Araci', 2022, 0),
(6, 'Airbus A400M Atlas', 2015, 1),
(7, 'C-160 Transall', 2014, 1),
(8, 'UH-1', 2010, 6),
(9, 'Cobra 2', 2021, 11),
(10, 'Akrep 3', 2022, 5);

--
-- Tetikleyiciler `araclar`
--
DELIMITER $$
CREATE TRIGGER `trigger1` BEFORE INSERT ON `araclar` FOR EACH ROW SET NEW.arac_markasi= CONCAT(UCASE(LEFT(NEW.arac_markasi,1)) , LCASE(SUBSTRING(NEW.arac_markasi,2)))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `arac_suruculeri`
--

CREATE TABLE `arac_suruculeri` (
  `surucu_id` int(11) NOT NULL,
  `surucu_ad` varchar(255) DEFAULT NULL,
  `surucu_soyad` varchar(255) DEFAULT NULL,
  `surucu_ehliyet_sinifi` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `arac_suruculeri`
--

INSERT INTO `arac_suruculeri` (`surucu_id`, `surucu_ad`, `surucu_soyad`, `surucu_ehliyet_sinifi`) VALUES
(1, 'Ahmet', 'Durmaz', 'B'),
(2, 'Baturay', 'Temel', 'C'),
(3, 'Efe', 'Yurdakul', 'D1'),
(4, 'Kaan', 'Er', 'B'),
(5, 'Seymen', 'Kayikci', 'M'),
(6, 'Necati', 'Baber', 'C'),
(7, 'Cem', 'Ozcan', 'B'),
(8, 'Murat', 'Kara', 'DE'),
(9, 'Cem', 'Yılmaz', 'M'),
(10, 'Eray', 'Dede', 'CE'),
(11, 'Mehmet', 'Demir', 'B1');

--
-- Tetikleyiciler `arac_suruculeri`
--
DELIMITER $$
CREATE TRIGGER `trigger2` BEFORE INSERT ON `arac_suruculeri` FOR EACH ROW SET NEW.surucu_ad= CONCAT(UCASE(LEFT(NEW.surucu_ad,1)) , LCASE(SUBSTRING(NEW.surucu_ad,2)))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `birimler`
--

CREATE TABLE `birimler` (
  `birim_id` int(11) NOT NULL,
  `birim_adi` varchar(255) DEFAULT NULL,
  `birim_aciklamasi` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `birimler`
--

INSERT INTO `birimler` (`birim_id`, `birim_adi`, `birim_aciklamasi`) VALUES
(1, 'Er', 'Silahli kuvvetlerde en alttaki ve rutbesiz asker'),
(2, 'Onbasi', 'Askerlikte erbas rutbesinin ilk basamagi'),
(3, 'Cavus', 'Onbasidan bir ust rutbe ve rutbede bulunan erbas'),
(4, 'Yuzbasi', 'Gorevi boluk komutanligi olan Onbasi ve Binbasi arasındaki rutbe '),
(5, 'Binbasi', 'Gorevi boluk veya tabur komutanligi olan Yuzbasi ile Yarbay arasindaki rutbe'),
(6, 'Yarbay', 'Gorevi tabur kkomutani olan Binbasi ile Albay arasindaki rutbe'),
(7, 'Albay', 'Kita gorevi alay komutanligi olan Yarbay ve Tuggeneral arasindaki rutbe'),
(8, 'Tuggeneral', 'Kita gorevi tugay komutanligi olan Albay ve Tumgeneral arasindaki rutbe'),
(9, 'Tumgeneral', ' Kita gorevi tumen komutani olan Tuggeneral ve Korgeneral arasindaki rutbe'),
(10, 'Korgeneral', 'Asil gorevi kolordu komutanligi olan Tumgeneral ve Orgeneral arasındaki rutbe'),
(11, 'Orgeneral', 'Asil gorevi ordu komutanligi olan Korgeneral ile Maresal arasindaki rutbe');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `calisanlar`
--

CREATE TABLE `calisanlar` (
  `calisan_id` int(11) NOT NULL,
  `calisan_ad` varchar(255) DEFAULT NULL,
  `calisan_soyad` varchar(255) DEFAULT NULL,
  `calisan_dogum_tarihi` date DEFAULT NULL,
  `birim_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `calisanlar`
--

INSERT INTO `calisanlar` (`calisan_id`, `calisan_ad`, `calisan_soyad`, `calisan_dogum_tarihi`, `birim_id`) VALUES
(1, 'Seymen', 'Kayikci', '2002-04-22', 1),
(2, 'Gorkem', 'Kocak', '2001-09-19', 2),
(3, 'Mahir', 'Diler', '2001-03-31', 3),
(4, 'Emre', 'Aslan', '2002-08-01', 4),
(5, 'Serda', 'Poyraz', '2001-02-01', 5),
(6, 'Mehmet', 'Mercan', '2002-01-11', 6),
(7, 'Emre', 'Onal', '2002-05-14', 7),
(8, 'Mehmetcan', 'Donmez', '1998-07-14', 8),
(9, 'Ugurcan', 'Yilmaz', '1994-11-15', 9),
(10, 'Burak', 'Oz', '1997-12-23', 10),
(11, 'Ender', 'Kayikci', '1969-06-28', 11);

--
-- Tetikleyiciler `calisanlar`
--
DELIMITER $$
CREATE TRIGGER `trigger3` BEFORE UPDATE ON `calisanlar` FOR EACH ROW SET NEW.calisan_ad= CONCAT(UCASE(LEFT(NEW.calisan_ad,1)) , LCASE(SUBSTRING(NEW.calisan_ad,2)))
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `muhimmat_deposu`
--

CREATE TABLE `muhimmat_deposu` (
  `muhimmat_id` int(11) NOT NULL,
  `muhimmat_adi` varchar(255) DEFAULT NULL,
  `muhimmat_miktari` int(11) DEFAULT NULL,
  `muhimmat_birimi` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `muhimmat_deposu`
--

INSERT INTO `muhimmat_deposu` (`muhimmat_id`, `muhimmat_adi`, `muhimmat_miktari`, `muhimmat_birimi`) VALUES
(1, 'LACIN Gudum Kiti ve L-POD', 1500, 'Hava Kuvvetleri'),
(2, 'SAR9', 235000, 'Hava,Deniz ve Kara Kuvvetleri'),
(3, 'Armsan RS-S1', 1300, 'Komando ve Ozel Kuvvetler Komutanliği'),
(4, 'MPT', 70000, 'Kara Kuvvetleri'),
(5, 'Arctic Warfare', 5000, 'Ozel Kuvvetler Komutanligi'),
(6, 'Canik M2 QCB', 3000, 'Kara kuvvetleri'),
(7, '9x19mm Parabellium', 500, 'Kara ve Deniz Komutanligi'),
(8, 'M4A1', 100000, 'Kara Kuvvetleri'),
(9, 'Drone\'dan atilablir 40mm Mini Roket', 3000, 'Hava Komutanligi'),
(10, 'Hassas Gudum Kiti 82', 150, 'hava komutanligi');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `stoklar`
--

CREATE TABLE `stoklar` (
  `stok_id` int(11) NOT NULL,
  `stok_urun_id` int(11) DEFAULT NULL,
  `stok_miktari` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `stoklar`
--

INSERT INTO `stoklar` (`stok_id`, `stok_urun_id`, `stok_miktari`) VALUES
(1, 1, 12),
(2, 2, 20),
(3, 3, 2),
(4, 4, 1),
(5, 5, 4),
(6, 6, 1),
(7, 7, 4),
(8, 8, 8),
(9, 9, 2),
(10, 10, 3);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tedarikciler`
--

CREATE TABLE `tedarikciler` (
  `tedarikci_id` int(11) NOT NULL,
  `tedarikci_adi` varchar(255) DEFAULT NULL,
  `tedarikci_telefonu` varchar(255) DEFAULT NULL,
  `tedarikci_adresi` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `tedarikciler`
--

INSERT INTO `tedarikciler` (`tedarikci_id`, `tedarikci_adi`, `tedarikci_telefonu`, `tedarikci_adresi`) VALUES
(1, 'Almanya', '1234567893', 'Berlin'),
(2, 'Ingiltere', '5349853034', 'Manchester'),
(3, 'ABD', '350912345', 'Kaliforniya'),
(4, 'Rusya', '480912345', 'Moskova'),
(5, 'Kanada', '126879098', 'Ottova'),
(6, 'Irlanda', '8905124560', 'Dublin'),
(7, 'Italya', '114338896', 'Roma'),
(8, 'Arjantin', '9430456972', 'Bueonos Aries'),
(9, 'Fransa', '14509322040', 'Paris'),
(10, 'Ispanya', '71487690', 'Madrid');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `urunler`
--

CREATE TABLE `urunler` (
  `urun_id` int(11) NOT NULL,
  `urun_adi` varchar(255) DEFAULT NULL,
  `urun_kategorisi` varchar(255) DEFAULT NULL,
  `urun_fiyati` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Tablo döküm verisi `urunler`
--

INSERT INTO `urunler` (`urun_id`, `urun_adi`, `urun_kategorisi`, `urun_fiyati`) VALUES
(1, 'Fanila', 'Giyim', 5),
(2, 'İclik', 'Giyim', 10),
(3, 'Bot', 'Giyim', 150),
(4, 'Banyo Jileti', 'Bakim', 15),
(5, 'Tuvalet Kagidi', 'Temizlik', 5),
(6, 'Dolap Kilidi', 'Materyel', 20),
(7, 'Canta', 'Bireysel', 50),
(8, 'Corap', 'Giyim', 1),
(9, 'Cuzdan', 'Bireysel', 30),
(10, 'Camasir Torbasi', 'Bakim', 25);

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `araclar`
--
ALTER TABLE `araclar`
  ADD PRIMARY KEY (`arac_id`);

--
-- Tablo için indeksler `arac_suruculeri`
--
ALTER TABLE `arac_suruculeri`
  ADD PRIMARY KEY (`surucu_id`);

--
-- Tablo için indeksler `birimler`
--
ALTER TABLE `birimler`
  ADD PRIMARY KEY (`birim_id`);

--
-- Tablo için indeksler `calisanlar`
--
ALTER TABLE `calisanlar`
  ADD PRIMARY KEY (`calisan_id`),
  ADD KEY `birim_id` (`birim_id`);

--
-- Tablo için indeksler `muhimmat_deposu`
--
ALTER TABLE `muhimmat_deposu`
  ADD PRIMARY KEY (`muhimmat_id`);

--
-- Tablo için indeksler `stoklar`
--
ALTER TABLE `stoklar`
  ADD PRIMARY KEY (`stok_id`),
  ADD KEY `stok_urun_id` (`stok_urun_id`);

--
-- Tablo için indeksler `tedarikciler`
--
ALTER TABLE `tedarikciler`
  ADD PRIMARY KEY (`tedarikci_id`);

--
-- Tablo için indeksler `urunler`
--
ALTER TABLE `urunler`
  ADD PRIMARY KEY (`urun_id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `birimler`
--
ALTER TABLE `birimler`
  MODIFY `birim_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Tablo için AUTO_INCREMENT değeri `calisanlar`
--
ALTER TABLE `calisanlar`
  MODIFY `calisan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `araclar`
--
ALTER TABLE `araclar`
  ADD CONSTRAINT `araclar_ibfk_1` FOREIGN KEY (`arac_id`) REFERENCES `arac_suruculeri` (`surucu_id`);

--
-- Tablo kısıtlamaları `calisanlar`
--
ALTER TABLE `calisanlar`
  ADD CONSTRAINT `calisanlar_ibfk_1` FOREIGN KEY (`birim_id`) REFERENCES `birimler` (`birim_id`);

--
-- Tablo kısıtlamaları `stoklar`
--
ALTER TABLE `stoklar`
  ADD CONSTRAINT `stoklar_ibfk_1` FOREIGN KEY (`stok_urun_id`) REFERENCES `urunler` (`urun_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
