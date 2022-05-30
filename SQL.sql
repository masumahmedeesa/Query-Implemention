USE dbms50CD;

# CREATE DATABASES
CREATE TABLE EMPLOYEE
( Fname           VARCHAR(10)   NOT NULL,
  Minit           CHAR,
  Lname           VARCHAR(20)      NOT NULL,
  Ssn             CHAR(9)          NOT NULL,
  Bdate           DATE,
  Address         VARCHAR(30),
  Sex             CHAR(1),
  Salary          DECIMAL(5),
  Super_ssn       CHAR(9),
  Dno             INT               NOT NULL,
PRIMARY KEY   (Ssn));

CREATE TABLE DEPARTMENT
( Dname           VARCHAR(15)       NOT NULL,
  Dnumber         INT               NOT NULL,
  Mgr_ssn         CHAR(9)           NOT NULL,
  Mgr_start_date  DATE,
PRIMARY KEY (Dnumber),
UNIQUE      (Dname),
FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn) );

CREATE TABLE DEPT_LOCATIONS
( Dnumber         INT               NOT NULL,
  Dlocation       VARCHAR(15)       NOT NULL,
PRIMARY KEY (Dnumber, Dlocation),
FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber) );

CREATE TABLE PROJECT
( Pname           VARCHAR(15)       NOT NULL,
  Pnumber         INT               NOT NULL,
  Plocation       VARCHAR(15),
  Dnum            INT               NOT NULL,
PRIMARY KEY (Pnumber),
UNIQUE      (Pname),
FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber) );

CREATE TABLE WORKS_ON
( Essn            CHAR(9)           NOT NULL,
  Pno             INT               NOT NULL,
  Hours           DECIMAL(3,1)      NOT NULL,
PRIMARY KEY (Essn, Pno),
FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn),
FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber) );

CREATE TABLE DEPENDENT
( Essn            CHAR(9)           NOT NULL,
  Dependent_name  VARCHAR(15)       NOT NULL,
  Sex             CHAR,
  Bdate           DATE,
  Relationship    VARCHAR(8),
PRIMARY KEY (Essn, Dependent_name),
FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn) );


# INSERT VALUES
INSERT INTO EMPLOYEE
VALUES      ('John','B','Smith',123456789,'1965-01-09','731 Fondren, Houston TX','M',30000,333445555,5),
            ('Franklin','T','Wong',333445555,'1965-12-08','638 Voss, Houston TX','M',40000,888665555,5),
            ('Alicia','J','Zelaya',999887777,'1968-01-19','3321 Castle, Spring TX','F',25000,987654321,4),
            ('Jennifer','S','Wallace',987654321,'1941-06-20','291 Berry, Bellaire TX','F',43000,888665555,4),
            ('Ramesh','K','Narayan',666884444,'1962-09-15','975 Fire Oak, Humble TX','M',38000,333445555,5),
            ('Joyce','A','English',453453453,'1972-07-31','5631 Rice, Houston TX','F',25000,333445555,5),
            ('Ahmad','V','Jabbar',987987987,'1969-03-29','980 Dallas, Houston TX','M',25000,987654321,4),
            ('James','E','Borg',888665555,'1937-11-10','450 Stone, Houston TX','M',55000,null,1);

INSERT INTO DEPARTMENT
VALUES      ('Research',5,333445555,'1988-05-22'),
            ('Administration',4,987654321,'1995-01-01'),
            ('Headquarters',1,888665555,'1981-06-19');

INSERT INTO PROJECT
VALUES      ('ProductX',1,'Bellaire',5),
            ('ProductY',2,'Sugarland',5),
            ('ProductZ',3,'Houston',5),
            ('Computerization',10,'Stafford',4),
            ('Reorganization',20,'Houston',1),
            ('Newbenefits',30,'Stafford',4);

INSERT INTO WORKS_ON
VALUES     (123456789,1,32.5),
           (123456789,2,7.5),
           (666884444,3,40.0),
           (453453453,1,20.0),
           (453453453,2,20.0),
           (333445555,2,10.0),
           (333445555,3,10.0),
           (333445555,10,10.0),
           (333445555,20,10.0),
           (999887777,30,30.0),
           (999887777,10,10.0),
           (987987987,10,35.0),
           (987987987,30,5.0),
           (987654321,30,20.0),
           (987654321,20,15.0),
           (888665555,20,16.0);

INSERT INTO DEPENDENT
VALUES      (333445555,'Alice','F','1986-04-04','Daughter'),
            (333445555,'Theodore','M','1983-10-25','Son'),
            (333445555,'Joy','F','1958-05-03','Spouse'),
            (987654321,'Abner','M','1942-02-28','Spouse'),
            (123456789,'Michael','M','1988-01-04','Son'),
            (123456789,'Alice','F','1988-12-30','Daughter'),
            (123456789,'Elizabeth','F','1967-05-05','Spouse');

INSERT INTO DEPT_LOCATIONS
VALUES      (1,'Houston'),
            (4,'Stafford'),
            (5,'Bellaire'),
            (5,'Sugarland'),
            (5,'Houston');

ALTER TABLE DEPARTMENT
 ADD CONSTRAINT Dep_emp FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn);

ALTER TABLE EMPLOYEE
 ADD CONSTRAINT Emp_emp FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn);
ALTER TABLE EMPLOYEE
 ADD CONSTRAINT Emp_dno FOREIGN KEY  (Dno) REFERENCES DEPARTMENT(Dnumber);
ALTER TABLE EMPLOYEE
 ADD CONSTRAINT Emp_super FOREIGN KEY  (Super_ssn) REFERENCES EMPLOYEE(Ssn);


# QUIRES

SELECT * FROM EMPLOYEE;

# Q1: Retrieve the names of all employees who don't have superviors.
-- SELECT Fname, Lname
-- FROM EMPLOYEE
-- WHERE Super_ssn IS NULL;

# Retrieve names of employees who works for any department
-- SELECT D.Dnumber, D.Dname, E.Fname 
-- FROM EMPLOYEE AS E JOIN DEPARTMENT AS D on E.Dno = D.Dnumber;


# Q2: Find out Dno, Fname, Lname of all managers.
-- SELECT Ssn, Dno, Fname, Lname
-- FROM EMPLOYEE
-- WHERE Ssn IN (SELECT Mgr_ssn FROM DEPARTMENT);

-- SELECT Dno, Fname, Lname
-- FROM EMPLOYEE
-- WHERE Ssn IN (SELECT Mgr_ssn FROM DEPARTMENT WHERE Ssn=Mgr_ssn);

-- SELECT Dno, Fname, Lname
-- FROM EMPLOYEE, DEPARTMENT
-- WHERE Ssn=Mgr_ssn;

-- SELECT Fname, Lname
-- FROM EMPLOYEE JOIN DEPARTMENT ON Ssn=Mgr_ssn;


# Q3: Find out the project numbers of projects that have an employee with the last name 'Wong' involded as manager.
-- SELECT Pnumber, Pname
-- FROM PROJECT
-- WHERE Dnum In (
--     SELECT Dno
--     FROM DEPARTMENT JOIN EMPLOYEE ON Mgr_ssn=Ssn
--     WHERE Lname='Wong');

-- SELECT Pnumber, Pname
-- FROM (PROJECT JOIN DEPARTMENT ON Dnum=Dnumber) JOIN EMPLOYEE ON Mgr_ssn=Ssn
-- WHERE Lname='Wong';
# (n * m) * o

-- SELECT Pnumber, Pname
-- FROM PROJECT, DEPARTMENT, EMPLOYEE
-- WHERE Dnum=Dnumber AND Mgr_ssn=Ssn AND Lname='Wong';

-- Q5: Names of employees whose salaries are greater than the salary of all employees in department no 5;
-- SELECT Dno, Fname, Lname, Salary
-- FROM EMPLOYEE
-- WHERE Salary > (SELECT MAX(Salary)
-- FROM EMPLOYEE
-- WHERE Dno=5);

-- SELECT Dno, Fname, Lname, Salary
-- FROM EMPLOYEE
-- WHERE Dno=5;

 # Q(n): Find the sum of all salaries of employees of 'Research' department.
--  SELECT Dname, COUNT(*) AS TOTAL_EMPLOYEES, SUM(Salary) AS TOTAL_SALARY, AVG(Salary) AS AVERAGE_SALARY, MAX(Salary) AS MAXIMUM_SALARY
--  FROM DEPARTMENT JOIN EMPLOYEE ON Dnumber=Dno
--  WHERE Dname='Research';

-- Q(n+1): For each department, retrieve the department number, SUM of the distinct salaries of all employees.

-- SELECT Dno, SUM(Salary) AS TOTAL_SALARY, COUNT(*) AS TOTAL_EMPLOYEES
-- FROM EMPLOYEE
-- GROUP BY Dno;

-- Q(n+2): For each project on which more than two employees work, retrieve the project number 
-- and the number of employees who work on that project.

-- SELECT Pno, COUNT(*)
-- FROM WORKS_ON
-- GROUP BY Pno
-- HAVING COUNT(*)>2;


-- Q(n+3): For each department that has more than ONE employees, retrieve the department 
-- number and the number of its employees who are making more than 40,000

-- For each department that has more than three employees
-- SELECT Dno
-- FROM EMPLOYEE
-- GROUP BY Dno
-- HAVING COUNT(*) > 1;

-- retrieve the department number and the number of its employees who are making more than 40,000
-- SELECT Dno, COUNT(*) AS TOTAL_EMPLOYEES
-- FROM EMPLOYEE
-- WHERE Salary > 40000 
-- GROUP BY Dno;

-- FINAL ANSWER
SELECT Dno, COUNT(*) AS TOTAL_EMPLOYEES
FROM EMPLOYEE
WHERE Salary > 40000 AND Dno IN (
            SELECT Dno
            FROM EMPLOYEE
            GROUP BY Dno
            HAVING COUNT(*) > 1
            )
GROUP BY Dno;



-- SELECT *
-- FROM DEPENDENT AS D JOIN EMPLOYEE AS E ON D.Essn = E.Ssn
-- WHERE E.Sex = D.Sex;

-- SELECT E.Fname, E.Lname
-- FROM DEPENDENT AS D JOIN EMPLOYEE AS E ON D.Essn = E.Ssn
-- WHERE E.Fname = D.Dependent_name AND E.Sex = D.Sex;
