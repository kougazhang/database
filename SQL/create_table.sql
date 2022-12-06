-- mysql

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
                           `Sno` char(9) DEFAULT NULL,
                           `Sname` char(20) DEFAULT NULL,
                           `Ssex` char(2) DEFAULT NULL,
                           `Sage` int(11) DEFAULT NULL,
                           `Sdept` char(20) DEFAULT NULL,
                           UNIQUE KEY `Sno` (`Sno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES ('200215121', '李勇', '男', '20', 'CS');
INSERT INTO `student` VALUES ('200215122', '刘晨', '女', '19', 'CS');
INSERT INTO `student` VALUES ('200215123', '王敏', '女', '18', 'MA');
INSERT INTO `student` VALUES ('200215124', '张立', '男', '19', 'IS');

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
                          `Cno` char(4) NOT NULL,
                          `Cname` char(40) DEFAULT NULL,
                          `Cpno` char(4) DEFAULT NULL,
                          `Ccredit` smallint(6) DEFAULT NULL,
                          PRIMARY KEY (`Cno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES ('1', '数据库', '5', '4');
INSERT INTO `course` VALUES ('2', '数学', '', '2');
INSERT INTO `course` VALUES ('3', '信息系统', '1', '4');
INSERT INTO `course` VALUES ('4', '操作系统', '6', '3');
INSERT INTO `course` VALUES ('5', '数据结构', '7', '4');
INSERT INTO `course` VALUES ('6', '数据处理', '', '2');
INSERT INTO `course` VALUES ('7', 'PaSCal语言', '6', '4');


-- ----------------------------
-- Table structure for sc
-- ----------------------------
DROP TABLE IF EXISTS `sc`;
CREATE TABLE `sc` (
                      `Sno` char(9) DEFAULT NULL,
                      `Cno` char(4) DEFAULT NULL,
                      `Grade` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of sc
-- ----------------------------
INSERT INTO `sc` VALUES ('200215121', '1', '92');
INSERT INTO `sc` VALUES ('200215121', '2', '85');
INSERT INTO `sc` VALUES ('200215121', '3', '88');
INSERT INTO `sc` VALUES ('200215122', '2', '90');
INSERT INTO `sc` VALUES ('200215122', '3', '80');


