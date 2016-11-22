-- MySQL Script generated by MySQL Workbench
-- Tue Nov 22 23:10:26 2016
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema exam
-- -----------------------------------------------------
-- 考试数据库

-- -----------------------------------------------------
-- Schema exam
--
-- 考试数据库
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `exam` DEFAULT CHARACTER SET utf8 ;
USE `exam` ;

-- -----------------------------------------------------
-- Table `exam`.`News`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `exam`.`News` (
  `id` INT NOT NULL,
  `title` VARCHAR(45) NOT NULL DEFAULT '',
  `content` LONGTEXT NULL,
  `bbg` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '超大背景图片',
  `bg` VARCHAR(255) NOT NULL DEFAULT '',
  `up` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '赞',
  `down` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '踩的人数',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `exam`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `exam`.`Users` (
  `id` INT NOT NULL COMMENT '老师是产生试卷，而学生是做试卷。多对多关系的地方比较乱',
  `role` INT UNSIGNED NOT NULL DEFAULT 11 COMMENT '角色类型：0-9 暂定无\n10-19 学生\n20-29 教师\n30-39 管理员',
  `name` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '显示出的名字',
  `school_id` INT NOT NULL COMMENT '学号/老师号什么的',
  `pwd` VARCHAR(255) NULL COMMENT '密码',
  `avatar` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '头像',
  `News_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `school_id_UNIQUE` (`school_id` ASC),
  INDEX `fk_Users_News1_idx` (`News_id` ASC),
  CONSTRAINT `fk_Users_News1`
    FOREIGN KEY (`News_id`)
    REFERENCES `exam`.`News` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `exam`.`Questions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `exam`.`Questions` (
  `id` INT NOT NULL,
  `title` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '问题的标题',
  `content` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '问题的内容',
  `answers` JSON NULL COMMENT '所有答案',
  `right` JSON NOT NULL COMMENT '正确答案',
  `hasBug` INT NOT NULL DEFAULT 0,
  `stared` INT NOT NULL DEFAULT 0,
  `score` TINYINT(2) NOT NULL DEFAULT 0 COMMENT '答对这道题能得多少分',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `exam`.`Courses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `exam`.`Courses` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL DEFAULT '' COMMENT '课程名字',
  `desc` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '课程简介',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `exam`.`Papers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `exam`.`Papers` (
  `id` INT NOT NULL COMMENT '试卷',
  `title` VARCHAR(45) NOT NULL DEFAULT '',
  `alert` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '提示信息，警告什么的',
  `score` TINYINT(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT '可获得学分',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `exam`.`Courses_has_News`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `exam`.`Courses_has_News` (
  `Courses_id` INT NOT NULL,
  `News_id` INT NOT NULL,
  PRIMARY KEY (`Courses_id`, `News_id`),
  INDEX `fk_Courses_has_News_News1_idx` (`News_id` ASC),
  INDEX `fk_Courses_has_News_Courses_idx` (`Courses_id` ASC),
  CONSTRAINT `fk_Courses_has_News_Courses`
    FOREIGN KEY (`Courses_id`)
    REFERENCES `exam`.`Courses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Courses_has_News_News1`
    FOREIGN KEY (`News_id`)
    REFERENCES `exam`.`News` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `exam`.`Courses_has_Papers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `exam`.`Courses_has_Papers` (
  `Courses_id` INT NOT NULL,
  `Paper_id` INT NOT NULL,
  PRIMARY KEY (`Courses_id`, `Paper_id`),
  INDEX `fk_Courses_has_Paper_Paper1_idx` (`Paper_id` ASC),
  INDEX `fk_Courses_has_Paper_Courses1_idx` (`Courses_id` ASC),
  CONSTRAINT `fk_Courses_has_Paper_Courses1`
    FOREIGN KEY (`Courses_id`)
    REFERENCES `exam`.`Courses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Courses_has_Paper_Paper1`
    FOREIGN KEY (`Paper_id`)
    REFERENCES `exam`.`Papers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `exam`.`Papers_has_Questions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `exam`.`Papers_has_Questions` (
  `Paper_id` INT NOT NULL,
  `Questions_id` INT NOT NULL,
  PRIMARY KEY (`Paper_id`, `Questions_id`),
  INDEX `fk_Paper_has_Questions_Questions1_idx` (`Questions_id` ASC),
  INDEX `fk_Paper_has_Questions_Paper1_idx` (`Paper_id` ASC),
  CONSTRAINT `fk_Paper_has_Questions_Paper1`
    FOREIGN KEY (`Paper_id`)
    REFERENCES `exam`.`Papers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Paper_has_Questions_Questions1`
    FOREIGN KEY (`Questions_id`)
    REFERENCES `exam`.`Questions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `exam`.`Users_has_Paper`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `exam`.`Users_has_Paper` (
  `Users_id` INT NOT NULL,
  `Paper_id` INT NOT NULL,
  `score` FLOAT NOT NULL DEFAULT 0.00 COMMENT '这张试卷的分数',
  PRIMARY KEY (`Users_id`, `Paper_id`),
  INDEX `fk_Users_has_Paper_Paper1_idx` (`Paper_id` ASC),
  INDEX `fk_Users_has_Paper_Users1_idx` (`Users_id` ASC),
  CONSTRAINT `fk_Users_has_Paper_Users1`
    FOREIGN KEY (`Users_id`)
    REFERENCES `exam`.`Users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Users_has_Paper_Paper1`
    FOREIGN KEY (`Paper_id`)
    REFERENCES `exam`.`Papers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `exam`.`Questions_has_Courses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `exam`.`Questions_has_Courses` (
  `Questions_id` INT NOT NULL,
  `Courses_id` INT NOT NULL,
  PRIMARY KEY (`Questions_id`, `Courses_id`),
  INDEX `fk_Questions_has_Courses_Courses1_idx` (`Courses_id` ASC),
  INDEX `fk_Questions_has_Courses_Questions1_idx` (`Questions_id` ASC),
  CONSTRAINT `fk_Questions_has_Courses_Questions1`
    FOREIGN KEY (`Questions_id`)
    REFERENCES `exam`.`Questions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Questions_has_Courses_Courses1`
    FOREIGN KEY (`Courses_id`)
    REFERENCES `exam`.`Courses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;