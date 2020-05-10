-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 09, 2020 at 11:22 PM
-- Server version: 10.3.22-MariaDB-1ubuntu1
-- PHP Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bird_dev`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_favs` (IN `post` BIGINT)  Select u_id,fav from post_interactions where p_id=post and fav is not null$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_followers` (IN `user` BIGINT)  NO SQL
select u_id,follow_date from follows where followee_id = user$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_follows` (IN `user` INT)  NO SQL
select followee_id,follow_date from follows where u_id = user$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_rts` (IN `post` BIGINT)  NO SQL
select u_id,rt from post_interactions where p_id=post and rt is not null$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `follows`
--

CREATE TABLE `follows` (
  `u_id` bigint(20) NOT NULL,
  `followee_id` bigint(20) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `u_id` bigint(20) NOT NULL,
  `pass` text NOT NULL,
  `salt` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `p_id` bigint(20) NOT NULL,
  `post_date` datetime NOT NULL DEFAULT current_timestamp(),
  `u_id` bigint(20) NOT NULL,
  `reply_id` bigint(20) DEFAULT NULL,
  `quote_id` bigint(20) DEFAULT NULL,
  `content` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `post_interactions`
--

CREATE TABLE `post_interactions` (
  `u_id` bigint(20) NOT NULL,
  `p_id` bigint(20) NOT NULL,
  `fav` datetime DEFAULT NULL,
  `rt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_info`
--

CREATE TABLE `user_info` (
  `u_id` bigint(20) NOT NULL,
  `email` varchar(384) NOT NULL,
  `handle` varchar(20) NOT NULL,
  `display` text NOT NULL,
  `join_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `follows`
--
ALTER TABLE `follows`
  ADD PRIMARY KEY (`u_id`,`followee_id`),
  ADD KEY `fk_followee_follow` (`followee_id`),
  ADD KEY `u_id` (`u_id`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`u_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`p_id`),
  ADD KEY `fk_user_post` (`u_id`),
  ADD KEY `fk_reply_post` (`reply_id`),
  ADD KEY `fk_quote_post` (`quote_id`);

--
-- Indexes for table `post_interactions`
--
ALTER TABLE `post_interactions`
  ADD PRIMARY KEY (`u_id`,`p_id`),
  ADD UNIQUE KEY `fk_user_interaction` (`u_id`) USING BTREE,
  ADD KEY `fk_post_interaction` (`p_id`);

--
-- Indexes for table `user_info`
--
ALTER TABLE `user_info`
  ADD PRIMARY KEY (`u_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `handle` (`handle`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `p_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_info`
--
ALTER TABLE `user_info`
  MODIFY `u_id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `follows`
--
ALTER TABLE `follows`
  ADD CONSTRAINT `fk_followee_follow` FOREIGN KEY (`followee_id`) REFERENCES `user_info` (`u_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_follow` FOREIGN KEY (`u_id`) REFERENCES `user_info` (`u_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `fk_login_user` FOREIGN KEY (`u_id`) REFERENCES `user_info` (`u_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `fk_quote_post` FOREIGN KEY (`quote_id`) REFERENCES `posts` (`p_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_reply_post` FOREIGN KEY (`reply_id`) REFERENCES `posts` (`p_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_post` FOREIGN KEY (`u_id`) REFERENCES `user_info` (`u_id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `post_interactions`
--
ALTER TABLE `post_interactions`
  ADD CONSTRAINT `fk_post_interaction` FOREIGN KEY (`p_id`) REFERENCES `posts` (`p_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_interaction` FOREIGN KEY (`u_id`) REFERENCES `user_info` (`u_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
