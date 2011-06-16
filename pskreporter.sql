-- MySQL dump 10.13  Distrib 5.1.45, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: dx
-- ------------------------------------------------------
-- Server version	5.1.45-1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `pskreporter`
--

DROP TABLE IF EXISTS `pskreporter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pskreporter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guid` varchar(64) NOT NULL,
  `hash` varchar(32) NOT NULL,
  `sender_callsign` varchar(16) NOT NULL,
  `receiver_callsign` varchar(16) DEFAULT NULL,
  `sender_locator` varchar(16) DEFAULT NULL,
  `receiver_locator` varchar(16) DEFAULT NULL,
  `timestamp` varchar(20) NOT NULL,
  `mode` varchar(16) NOT NULL,
  `frequency` varchar(16) DEFAULT NULL,
  `sender_lt` double DEFAULT NULL,
  `sender_ln` double DEFAULT NULL,
  `receiver_lt` double DEFAULT NULL,
  `receiver_ln` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=13096 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-06-16 17:08:32
