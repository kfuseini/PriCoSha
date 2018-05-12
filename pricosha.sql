-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Dec 11, 2017 at 12:15 AM
-- Server version: 5.7.19
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pricosha`
--

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
CREATE TABLE IF NOT EXISTS `comment` (
  `id` int(11) NOT NULL DEFAULT '0',
  `username` varchar(50) NOT NULL DEFAULT '',
  `timest` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment_text` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`,`username`,`timest`),
  KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `comment`
--

INSERT INTO `comment` (`id`, `username`, `timest`, `comment_text`) VALUES
(3, 'AA', '2017-12-10 02:08:55', 'Hello'),
(3, 'AA', '2017-12-10 02:09:02', 'asdfg'),
(6, 'tyty', '2017-12-10 06:13:42', 'Hohoho');

-- --------------------------------------------------------

--
-- Table structure for table `content`
--

DROP TABLE IF EXISTS `content`;
CREATE TABLE IF NOT EXISTS `content` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `timest` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `file_path` varchar(100) DEFAULT NULL,
  `content_name` varchar(50) DEFAULT NULL,
  `public` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `content`
--

INSERT INTO `content` (`id`, `username`, `timest`, `file_path`, `content_name`, `public`) VALUES
(2, 'BB', '2017-11-14 20:24:04', 'Bye', 'See you', 0),
(3, 'AA', '2017-12-09 23:43:39', '', 'My First Content', 1),
(6, 'tyty', '2017-12-10 06:13:33', 'www.santa.com', 'Merry Christmas', 0);

-- --------------------------------------------------------

--
-- Table structure for table `friendgroup`
--

DROP TABLE IF EXISTS `friendgroup`;
CREATE TABLE IF NOT EXISTS `friendgroup` (
  `group_name` varchar(50) NOT NULL DEFAULT '',
  `username` varchar(50) NOT NULL DEFAULT '',
  `description` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`group_name`,`username`),
  KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `friendgroup`
--

INSERT INTO `friendgroup` (`group_name`, `username`, `description`) VALUES
('My Besties', 'Allie', 'This group will contain my friends'),
('My Friends', 'AA', 'This group will contain my friends'),
('My Friends', 'Allie', 'This group will contain my friends'),
('My Friends', 'tyty', 'My Friends'),
('New Friends', 'Allie', 'This group will contain my friends'),
('People', 'Allie', 'This is a group of people');

-- --------------------------------------------------------

--
-- Table structure for table `friendrequest`
--

DROP TABLE IF EXISTS `friendrequest`;
CREATE TABLE IF NOT EXISTS `friendrequest` (
  `username_requester` varchar(50) NOT NULL DEFAULT '',
  `username_requestee` varchar(50) NOT NULL DEFAULT '',
  `timest` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`username_requester`,`username_requestee`),
  KEY `username_requestee` (`username_requestee`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `friendrequest`
--

INSERT INTO `friendrequest` (`username_requester`, `username_requestee`, `timest`, `status`) VALUES
('Allie', 'kfuseini', '2017-12-10 06:03:20', 0),
('Allie', 'tyty', '2017-12-10 15:42:58', 1),
('kfuseini', 'ty', '2017-11-29 03:51:41', 0),
('kfuseini', 'wenyi', '2017-12-10 06:04:37', 1),
('tyty', 'Wenyi', '2017-12-10 15:53:53', 0),
('wenyi', 'Allie', '2017-12-10 06:22:18', 1);

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
CREATE TABLE IF NOT EXISTS `member` (
  `username` varchar(50) NOT NULL DEFAULT '',
  `group_name` varchar(50) NOT NULL DEFAULT '',
  `username_creator` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`username`,`group_name`,`username_creator`),
  KEY `group_name` (`group_name`,`username_creator`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`username`, `group_name`, `username_creator`) VALUES
('AA', 'My Friends', 'AA'),
('Allie', 'My Friends', 'tyty'),
('tyty', 'My Friends', 'tyty'),
('kfuseini', 'New Friends', 'Allie'),
('Allie', 'People', 'Allie'),
('wenyi', 'People', 'Allie');

-- --------------------------------------------------------

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
CREATE TABLE IF NOT EXISTS `person` (
  `username` varchar(50) NOT NULL DEFAULT '',
  `password` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `DOB` int(8) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `person`
--

INSERT INTO `person` (`username`, `password`, `first_name`, `last_name`, `DOB`) VALUES
('AA', '1234', 'Ann', 'Anderson', 19961003),
('Allie', '12345', 'Allie', 'Longo', 19961023),
('BB', '9d3d9048db16a7eee539e93e3618cbe7', 'Bob', 'Baker', 19951108),
('CC', 'aa53ca0b650dfd85c4f59fa156f7a2cc', 'Cathy', 'Chang', 0),
('DD', '350bfcb1e3cfb28ddff48ce525d4f139', 'David', 'Davidson', 0),
('EE', 'a57b8491d1d8fc1014dd54bcf83b130a', 'Ellen', 'Ellenberg', 0),
('FF', '1fd406685cbdee605d0a7bebed56fdb0', 'Fred', 'Fox', 0),
('GG', '86d8d92aba9ecf9bbf89f69cb3e49588', 'Gina', 'Gupta', 0),
('HH', 'faafc315b95987fc2b071bcd8f698b81', 'Helen', 'Harper', 0),
('kfuseini', '12345', 'Kamal', 'Fuseini', 20151210),
('MM', '3456', 'Mary', 'Smith', 20171210),
('tyty', '12345', 'Tyrone', 'Tolbert', 20171210),
('Wenyi', 'password', 'Wenyi', 'Ji', 20171209),
('ZZ', '1234', 'Zach', 'Zoo', 19950801);

-- --------------------------------------------------------

--
-- Table structure for table `share`
--

DROP TABLE IF EXISTS `share`;
CREATE TABLE IF NOT EXISTS `share` (
  `id` int(11) NOT NULL DEFAULT '0',
  `group_name` varchar(50) NOT NULL DEFAULT '',
  `username` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`group_name`,`username`),
  KEY `group_name` (`group_name`,`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `share`
--

INSERT INTO `share` (`id`, `group_name`, `username`) VALUES
(6, 'People', 'Allie');

-- --------------------------------------------------------

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
CREATE TABLE IF NOT EXISTS `tag` (
  `id` int(11) NOT NULL DEFAULT '0',
  `username_tagger` varchar(50) NOT NULL DEFAULT '',
  `username_taggee` varchar(50) NOT NULL DEFAULT '',
  `timest` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`,`username_tagger`,`username_taggee`),
  KEY `username_tagger` (`username_tagger`),
  KEY `username_taggee` (`username_taggee`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tag`
--

INSERT INTO `tag` (`id`, `username_tagger`, `username_taggee`, `timest`, `status`) VALUES
(3, 'AA', 'Allie', '2017-12-10 02:06:02', 1),
(6, 'tyty', 'Allie', '2017-12-10 23:11:24', 1),
(6, 'tyty', 'tyty', '2017-12-10 15:57:10', 1);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`id`) REFERENCES `content` (`id`),
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`username`) REFERENCES `person` (`username`);

--
-- Constraints for table `content`
--
ALTER TABLE `content`
  ADD CONSTRAINT `content_ibfk_1` FOREIGN KEY (`username`) REFERENCES `person` (`username`);

--
-- Constraints for table `friendgroup`
--
ALTER TABLE `friendgroup`
  ADD CONSTRAINT `friendgroup_ibfk_1` FOREIGN KEY (`username`) REFERENCES `person` (`username`);

--
-- Constraints for table `member`
--
ALTER TABLE `member`
  ADD CONSTRAINT `member_ibfk_1` FOREIGN KEY (`username`) REFERENCES `person` (`username`),
  ADD CONSTRAINT `member_ibfk_2` FOREIGN KEY (`group_name`,`username_creator`) REFERENCES `friendgroup` (`group_name`, `username`);

--
-- Constraints for table `share`
--
ALTER TABLE `share`
  ADD CONSTRAINT `share_ibfk_1` FOREIGN KEY (`id`) REFERENCES `content` (`id`),
  ADD CONSTRAINT `share_ibfk_2` FOREIGN KEY (`group_name`,`username`) REFERENCES `friendgroup` (`group_name`, `username`);

--
-- Constraints for table `tag`
--
ALTER TABLE `tag`
  ADD CONSTRAINT `tag_ibfk_1` FOREIGN KEY (`id`) REFERENCES `content` (`id`),
  ADD CONSTRAINT `tag_ibfk_2` FOREIGN KEY (`username_tagger`) REFERENCES `person` (`username`),
  ADD CONSTRAINT `tag_ibfk_3` FOREIGN KEY (`username_taggee`) REFERENCES `person` (`username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
