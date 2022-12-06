---
-- 列出所有用户 \dg;

-- 创建用户
CREATE
USER novel_user WITH PASSWORD 'novel123';

-- 列出所有用户: \du;

-- 当前数据库所有表 \d+;

-- 表结构 \d+ 表名；

-- 切换 schema:
set
search_path to <schema 名>;

SHOW
search_path;


-- 3.3.1 模式的定义与删除 -------------------------------------------------------------

--  例3.1 为用户 WANG 创建一个学生-课程模式 S-T
--  Mysql 不可执行
CREATE SCHEMA "S-T" AUTHORIZATION WANG;

-- 例3.2 如果该语句没有指定模式名，则模式名隐含为用户名 WANG；
--  Mysql 不可执行
CREATE SCHEMA AUTHORIZATION WANG;

-- 例3.3 为用户 ZHANG 创建一个模式 TEST，并且在其中定义一个表 TAB1.
--  Mysql 不可执行
CREATE SCHEMA TEST AUTHORIZATION ZHANG

    CREATE TABLE TAB1
    (
        COL1 SMALLINT,
        COL2 INT,
        COL3 CHAR(20),
    );

-- 例3.4 删除模式 ZHANG, 同时，该模式中已定义的表 TAB1 也删除。
DROP SCHEMA ZHANG CASCADE;

-- 3.3.2 基本表的定义、删除与修改 ---------------------------------------------------------

-- 例3.5 建立一个学生表 Student
CREATE TABLE Student
(
    Sno   CHAR(9) PRIMARY KEY,
    Sname CHAR(20) UNIQUE,
    Ssex  CHAR(2),
    Sage  SMALLINT,
    Sdept CHAR(20)
);

-- 例3.6 建立一个课程表 Course
-- 本例说明参照表和被参照表可以是同一个表
CREATE TABLE Course
(
    Cno    CHAR(4) PRIMARY KEY,
    Cname  CHAR(40) NOT NULL,
    Cpno   CHAR(4), -- Cpno 是先修课
    Credit SMALLINT,
    FOREIGN KEY (Cpno) REFERENCES Course (Cno)
);

-- 参照表和被参照表可以是同一个表的使用场景是？
INSERT INTO Course
    (Cno, Cname, Cpno, Credit)
VALUES ('1', '数学上册', null, 20);

INSERT INTO Course
    (Cno, Cname, Cpno, Credit)
VALUES ('2', '数学下册', '1', 20);

DELETE
FROM Course
WHERE Cno = '1';

-- 例3.7 建立学生选课表 SC
-- 注意：主码由两个属性构成，必须作为表级完整性进行定义
CREATE TABLE SC
(
    Sno   CHAR(9),
    Cno   CHAR(4),
    Grade SMALLINT,
    PRIMARY KEY (Sno, Cno),                     -- 主码由两个属性构成，必须作为表级完整性进行定义
    FOREIGN KEY (Sno) REFERENCES Student (Sno), -- 表级完整性约束，被参照表是 Student
    FOREIGN KEY (Cno) REFERENCES Course (Cno)   -- 表级完整性约束，被参照表是 Course
);

-- 例3.8 向 Student 表增加 “入学时间” 列，其数据类型为日期型。
ALTER TABLE Student
    ADD S_entrance DATE;

-- 例3.9 将 Student 表的年龄的数据由字符型改为整数
-- Mysql 执行语句： ALTER TABLE Student MODIFY COLUMN Sage INT;
ALTER TABLE Student ALTER COLUMN Sage INT;

-- 例3.10 增加课程表名称必须取唯一值的约束条件
ALTER TABLE Course
    ADD UNIQUE (Cname);

-- 例3.11 删除 Student 表
-- mysql 不支持，psql 可以。
-- 在事务中不支持使用 cascade
DROP TABLE Student RESTRICT;
DROP TABLE Student CASCADE;

-- 例3.12 选择 CASCADE 时可以删除表，表上的视图也会被删除。
CREATE VIEW IS_Student
AS
SELECT Sno, Sname, Sage
FROM Student
WHERE Sdept = 'IS';
-- 使用 RESTRICT 删除 Student 表. 会不允许删除，因为有关联。
DROP TABLE Student RESTRICT;
-- 使用 CASCADE 删除 Student 表，会删除关联的依赖（如 SC 上的外键），以及刚才创建的视图 IS_Student
DROP TABLE Student CASCADE;
-- 恢复;

-- 3.3.3 索引的定义、删除 ---------------------------------------------------------
-- 例3.13 为 Student, Course 和 SC 三个表建立索引。
-- 其中 Student 按学号升序建唯一索引，
-- Course 表按课程号升序建唯一索引，
-- SC 表按学号升序和课程号降序建唯一索引.
CREATE UNIQUE INDEX Stusno ON Student (Sno);
CREATE UNIQUE INDEX Coucno ON Course (Cno);
CREATE UNIQUE INDEX Scno ON SC (Sno ASC, Cno DESC);

-- 例3.14 将 SC 表的 Scno 索引改为 SCSno.
ALTER
INDEX Scno RENAME TO SCSno;

-- 例3.15 删除 Student 表的 Stusname 索引
DROP INDEX Stusname;


-- 3.7 视图的定义、删除 ---------------------------------------------------------

-- 3.84 建立信息系学生的视图
CREATE VIEW IS_Student
AS
SELECT Sno, Sname, Sage
FROM Student
WHERE Sdept = 'IS';

-- 3.85 建立信息系学生的视图，并要求进行修改和插入操作时仍需保证该视图只有信息系的学生
CREATE VIEW IS_Student385
AS
SELECT Sno, Sname, Sage
FROM Student
WHERE Sdept = 'IS'
WITH CHECK OPTION;
-- IS_Student 无 WITH CHECK OPTION, 可以成功执行如下插入语句：
INSERT INTO is_student (sno, sname, sage)
VALUES ('1', 'jack', 10);
-- IS_Student385 执行如下插入语句则失败：
INSERT INTO is_student385 (sno, sname, sage)
VALUES ('2', 'LiMing', 10);
-- 原因：
-- 通过视图进行的修改，必须也能通过该视图看到修改后的结果。
-- 比如你insert，那么加的这条记录在刷新视图后必须可以看到；
-- 如果修改，修改完的结果也必须能通过该视图看到；如果删除，当然只能删除视图里有显示的记录。

-- 而你只是查询出sdept='is'的纪录，你插入的根本不符合sdept='is'呀，所以就不行。
-- 默认情况下，由于行通过视图进行添加或更新，当其不再符合定义视图的查询的条件时，它们即从视图范围中消失。

-- 3.86 建立信息系选修了 1 号课程的学生的视图（包括学号、姓名、成绩）
-- 视图建立在一个或多个已定义好的视图上。
CREATE VIEW IS_S1(Sno, Sname, Grade)
AS
SELECT Student.Sno, Sname, Grade
FROM Student,
     SC
WHERE Sdept = 'IS'
  AND Student.Sno = SC.Sno
  AND SC.Cno = '1';

-- 3.87 建立信息系选修了 1 号课程且成绩在 90 分以上的学生的视图。
-- 基于视图创建的视图，带虚拟列的视图也称为带表达式的视图。
CREATE VIEW IS_S2
AS
SELECT Sno, Sname, Grade
FROM IS_S1
WHERE Grade >= 90;

-- 3.88 定义一个反映学生出生年份的视图。
CREATE VIEW BT_S(Sno, Sname, Sbirth)
AS
SELECT Sno, Sname, 2014 - Sage
FROM Student;

-- 3.4 数据查询 ---------------------------------------------------------

-- 例3.16 查询全体学生的学号与姓名
SELECT Sno, Sname
FROM Student;

-- KEY SQL
SELECT pvd, timeUnit from job where jobName='ksv2';