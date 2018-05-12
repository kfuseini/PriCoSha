-- phpMyAdmin SQL Dump
-- version 4.7.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Dec 09, 2017 at 11:52 PM
-- Server version: 5.6.35
-- PHP Version: 7.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `PriCoSha`
--

-- --------------------------------------------------------

--
-- Table structure for table `Comment`
--

CREATE TABLE `Comment` (
  `id` int(11) NOT NULL DEFAULT '0',
  `username` varchar(50) NOT NULL DEFAULT '',
  `timest` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment_text` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Content`
--

CREATE TABLE `Content` (
  `id` int(11) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `timest` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `file_path` varchar(100) DEFAULT NULL,
  `content_name` varchar(50) DEFAULT NULL,
  `public` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Content`
--

INSERT INTO `Content` (`id`, `username`, `timest`, `file_path`, `content_name`, `public`) VALUES
(1, 'AA', '2017-11-14 20:24:04', 'Different Name', 'Hello', 1),
(2, 'BB', '2017-11-14 20:24:04', 'Bye', 'See you', 0);

-- --------------------------------------------------------

--
-- Table structure for table `FriendGroup`
--

CREATE TABLE `FriendGroup` (
  `group_name` varchar(50) NOT NULL DEFAULT '',
  `username` varchar(50) NOT NULL DEFAULT '',
  `description` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `FriendGroup`
--

INSERT INTO `FriendGroup` (`group_name`, `username`, `description`) VALUES
('Friend', 'AA', 'Friends');

-- --------------------------------------------------------

--
-- Table structure for table `Member`
--

CREATE TABLE `Member` (
  `username` varchar(50) NOT NULL DEFAULT '',
  `group_name` varchar(50) NOT NULL DEFAULT '',
  `username_creator` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Member`
--

INSERT INTO `Member` (`username`, `group_name`, `username_creator`) VALUES
('BB', 'Friend', 'AA'),
('CC', 'Friend', 'AA'),
('DD', 'Friend', 'AA'),
('EE', 'Friend', 'AA'),
('FF', 'Friend', 'AA');

-- --------------------------------------------------------

--
-- Table structure for table `Person`
--

CREATE TABLE `Person` (
  `username` varchar(50) NOT NULL DEFAULT '',
  `password` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `DOB` int(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Person`
--

INSERT INTO `Person` (`username`, `password`, `first_name`, `last_name`, `DOB`) VALUES
('AA', '1234', 'Ann', 'Anderson', 19961208),
('BB', '9d3d9048db16a7eee539e93e3618cbe7', 'Bob', 'Baker', 19951209),
('CC', 'aa53ca0b650dfd85c4f59fa156f7a2cc', 'Cathy', 'Chang', 19971209),
('DD', '350bfcb1e3cfb28ddff48ce525d4f139', 'David', 'Davidson', 19701210),
('EE', 'a57b8491d1d8fc1014dd54bcf83b130a', 'Ellen', 'Ellenberg', 19701210),
('FF', '1fd406685cbdee605d0a7bebed56fdb0', 'Fred', 'Fox', 19940201),
('GG', '86d8d92aba9ecf9bbf89f69cb3e49588', 'Gina', 'Gupta', 19701208),
('HH', 'faafc315b95987fc2b071bcd8f698b81', 'Helen', 'Harper', 20171124),
('WinnieJi', 'jwy19961003', 'Wenyi', 'Ji', 19961003),
('ZZ', '1234', 'Zach', 'Zoo', 19950801);

-- --------------------------------------------------------

--
-- Table structure for table `Share`
--

CREATE TABLE `Share` (
  `id` int(11) NOT NULL DEFAULT '0',
  `group_name` varchar(50) NOT NULL DEFAULT '',
  `username` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Tag`
--

CREATE TABLE `Tag` (
  `id` int(11) NOT NULL DEFAULT '0',
  `username_tagger` varchar(50) NOT NULL DEFAULT '',
  `username_taggee` varchar(50) NOT NULL DEFAULT '',
  `timest` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Comment`
--
ALTER TABLE `Comment`
  ADD PRIMARY KEY (`id`,`username`,`timest`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `Content`
--
ALTER TABLE `Content`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `FriendGroup`
--
ALTER TABLE `FriendGroup`
  ADD PRIMARY KEY (`group_name`,`username`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `Member`
--
ALTER TABLE `Member`
  ADD PRIMARY KEY (`username`,`group_name`,`username_creator`),
  ADD KEY `group_name` (`group_name`,`username_creator`);

--
-- Indexes for table `Person`
--
ALTER TABLE `Person`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `Share`
--
ALTER TABLE `Share`
  ADD PRIMARY KEY (`id`,`group_name`,`username`),
  ADD KEY `group_name` (`group_name`,`username`);

--
-- Indexes for table `Tag`
--
ALTER TABLE `Tag`
  ADD PRIMARY KEY (`id`,`username_tagger`,`username_taggee`),
  ADD KEY `username_tagger` (`username_tagger`),
  ADD KEY `username_taggee` (`username_taggee`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Content`
--
ALTER TABLE `Content`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `Comment`
--
ALTER TABLE `Comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Content` (`id`),
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`username`) REFERENCES `Person` (`username`);

--
-- Constraints for table `Content`
--
ALTER TABLE `Content`
  ADD CONSTRAINT `content_ibfk_1` FOREIGN KEY (`username`) REFERENCES `Person` (`username`);

--
-- Constraints for table `FriendGroup`
--
ALTER TABLE `FriendGroup`
  ADD CONSTRAINT `friendgroup_ibfk_1` FOREIGN KEY (`username`) REFERENCES `Person` (`username`);

--
-- Constraints for table `Member`
--
ALTER TABLE `Member`
  ADD CONSTRAINT `member_ibfk_1` FOREIGN KEY (`username`) REFERENCES `Person` (`username`),
  ADD CONSTRAINT `member_ibfk_2` FOREIGN KEY (`group_name`,`username_creator`) REFERENCES `FriendGroup` (`group_name`, `username`);

--
-- Constraints for table `Share`
--
ALTER TABLE `Share`
  ADD CONSTRAINT `share_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Content` (`id`),
  ADD CONSTRAINT `share_ibfk_2` FOREIGN KEY (`group_name`,`username`) REFERENCES `FriendGroup` (`group_name`, `username`);

--
-- Constraints for table `Tag`
--
ALTER TABLE `Tag`
  ADD CONSTRAINT `tag_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Content` (`id`),
  ADD CONSTRAINT `tag_ibfk_2` FOREIGN KEY (`username_tagger`) REFERENCES `Person` (`username`),
  ADD CONSTRAINT `tag_ibfk_3` FOREIGN KEY (`username_taggee`) REFERENCES `Person` (`username`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
