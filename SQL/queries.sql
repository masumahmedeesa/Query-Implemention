USE company;

SHOW TABLES;

CREATE TABLE EMPLOYEE(
    Fname VARCHAR(30) NOT NULL,
    Minit VARCHAR(10),
    Lname VARCHAR(40) NOT NULL,
    Ssn CHAR(10) NOT NULL,
    Bdate DATE,
    Address VARCHAR(100),
    Sex CHAR(1),
    Salary DECIMAL(7),
    Super_ssn CHAR(10),
    Dno INT NOT NULL,
    PRIMARY KEY (Ssn)
);

SHOW TABLES;
SELECT * FROM EMPLOYEE;

CREATE TABLE DEPARTMENT(
    Dname VARCHAR(20) NOT NULL,
    Dnumber INT NOT NULL,
    Mgr_ssn CHAR(10) NOT NULL,
    Mgr_start_date DATE,

    PRIMARY KEY (Dnumber),
    UNIQUE (Dname),
    FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn)
);

SHOW TABLES;
SELECt * FROM DEPARTMENT;

CREATE TABLE DEPT_LOCATIONS(
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(100) NOT NULL,

    PRIMARY KEY (Dnumber, Dlocation),
    FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber)
);

SHOW TABLES;
SELECT * FROM DEPT_LOCATIONS;

INSERT INTO EMPLOYEE VALUES
('John','','Smith',123456789,'1965-01-09','731 Fondren, Houston TX','M',30000,333445555,5),
('Franklin','T','Wong',333445555,'1965-12-08','638 Voss, Houston TX','M',40000,888665555,5);

SELECT * FROM EMPLOYEE;

--- DELETE TRUNCATE DROP
DELETE FROM EMPLOYEE
WHERE Dno=5;

SELECT * FROM EMPLOYEE;

CREATE TABLE STUDENT(
    Fname VARCHAR(30) NOT NULL,
    Minit VARCHAR(10),
    Lname VARCHAR(40) NOT NULL,
    Ssn CHAR(10) NOT NULL,
    PRIMARY KEY (Ssn)
);

SELECT * FROM STUDENT;

INSERT INTO STUDENT VALUES
('John','','Smith',123456789),
('Franklin','T','Wong',333445555);

TRUNCATE STUDENT;

DROP TABLE STUDENT;

SHOW TABLES;

SHOW TABLES;
DROP TABLE DEPARTMENT;
DROP TABLE DEPT_LOCATIONS;
DROP TABLE EMPLOYEE;

SELECT * FROM EMPLOYEE;

-- Q1: Retrieve the names of all employees who don't have superviors.
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Super_ssn IS NULL;

-- Retrieve names of employees who works for department 5
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Dno=5;

-- Retrieve names of employees who works for Research department
--- EQUIJOIN
SELECT D.Dname, E.Fname, E.Lname
FROM EMPLOYEE AS E JOIN DEPARTMENT AS D ON E.Dno = D.Dnumber
WHERE D.Dname='Research';

--- NATURAL JOIN
SELECT *, Dnumber AS Dno FROM DEPARTMENT;
SELECT E.Fname, E.Lname
FROM EMPLOYEE AS E NATURAL JOIN (SELECT *, Dnumber AS Dno FROM DEPARTMENT) AS D
WHERE D.Dname = 'Research';

--- NESTED QUERY
--- Array1 = Employee, Array2 = Department (Dnumber)
--- Array2
SELECT Dnumber
FROM DEPARTMENT
WHERE Dname='Research';

SELECT Fname, Lname
FROM EMPLOYEE
WHERE Dno IN (
    SELECT Dnumber
    FROM DEPARTMENT
    WHERE Dname='Research'
);

--- ANOTHER APPROACH, WORST CASE
--- CROSS PRODUCT
SELECT E.Fname, E.Lname
FROM EMPLOYEE AS E, DEPARTMENT AS D
WHERE E.Dno = D.Dnumber AND D.Dname='Research';


-- Q2: Find out Dno, Fname, Lname of all managers.
SELECT E.Fname, E.Lname
FROM EMPLOYEE AS E JOIN DEPARTMENT AS D ON E.Ssn = D.Mgr_ssn;

--- NESTED
--- ARRAY 2
SELECT Mgr_ssn
FROM DEPARTMENT;

SELECT Fname, Lname
FROM EMPLOYEE
WHERE Ssn IN (
    SELECT Mgr_ssn
    FROM DEPARTMENT
);

-- Q2: Find out Spouse name of all managers.
--- Manager(DEPARTMENT, EMPLOYEE) SPOUSE(DEPENDENT)

--- (NESTED + JOIN) - ARRAY 2 (Managers)
SELECT E.Ssn
FROM EMPLOYEE AS E JOIN DEPARTMENT AS D ON E.Ssn = D.Mgr_ssn;

SELECT Dependent_name
FROM DEPENDENT
WHERE Relationship='Spouse' AND Essn IN (
    SELECT E.Ssn
    FROM EMPLOYEE AS E JOIN DEPARTMENT AS D ON E.Ssn = D.Mgr_ssn
);

--- MULTIPLE JOIN
--- DEPENDENT JOIN MANAGER
SELECT *
FROM DEPENDENT AS DP JOIN 
    (SELECT Mgr_ssn FROM EMPLOYEE JOIN DEPARTMENT ON Ssn = Mgr_ssn) AS ED 
    ON DP.Essn = ED.Mgr_ssn
WHERE DP.Relationship = 'Spouse';

--- ONLY NESTED
--- ARRAY 2
SELECT Ssn
FROM EMPLOYEE
WHERE Ssn IN (
    SELECT Mgr_ssn
    FROM DEPARTMENT
);

SELECT Dependent_name
FROM DEPENDENT
WHERE Relationship = 'Spouse' AND Essn IN (
    SELECT Ssn
    FROM EMPLOYEE
    WHERE Ssn IN (
        SELECT Mgr_ssn
        FROM DEPARTMENT
    )
);

-- Q(n): Find the total employees, sum of all salaries of employees of 'Research' department.

SELECT COUNT(*) AS TOTAL_EMPLOYEES, SUM(Salary) AS TOTAL_SALARIES, AVG(Salary) AS AVERAGE
FROM EMPLOYEE JOIN DEPARTMENT ON Dno=Dnumber
WHERE Dname='Research';

-- Q(n): Find the total employees, sum of all salaries of employees of  - department wise.
SELECT Dname, COUNT(*) AS TOTAL_EMPLOYEES, SUM(Salary) AS TOTAL_SALARIES, AVG(Salary) AS AVERAGE
FROM EMPLOYEE JOIN DEPARTMENT ON Dno=Dnumber
GROUP BY Dname;


-- Q5: Names of employees whose salaries are greater than the salary of all employees in department no 5;

-- Max Salary of department no 5
SELECT MAX(Salary)
FROM EMPLOYEE
WHERE Dno=5;

-- Those employees salary > (Max Salary of department no 5)
SELECT Fname, Lname, Salary
FROM EMPLOYEE
WHERE Salary > (
    SELECT MAX(Salary)
    FROM EMPLOYEE
    WHERE Dno=5
);

SELECT Fname, Lname, Salary
FROM EMPLOYEE
WHERE Salary >= (
    SELECT MAX(Salary)
    FROM EMPLOYEE
    WHERE Dno=5
);


-- Q(n+1): For each department, retrieve the department number, SUM of the distinct salaries of all employees.
SELECT Dno, COUNT(*) AS TOTAL_EMPLOYEES, SUM(DISTINCT Salary) AS TOTAL_AMOUNT
FROM EMPLOYEE
GROUP BY Dno;

SELECT Dname, COUNT(*), SUM(DISTINCT Salary)
FROM EMPLOYEE JOIN DEPARTMENT ON Dnumber = Dno
GROUP BY Dname;

SELECT * FROM EMPLOYEE;

SELECT Pno, COUNT(*)
FROM WORKS_ON
GROUP BY Pno;

-- Q(n+2): For each project on which more than two employees work, retrieve the project number 
-- and the number of employees who work on that project.

SELECT Pno, COUNT(*)
FROM WORKS_ON
GROUP BY Pno
HAVING COUNT(*) > 2;


-- Q(n+3): For each department that has more than ONE employees,
-- Retrieve the department number and the number of its employees who are making more than 40,000
SELECT Dno, COUNT(*)
FROM EMPLOYEE
GROUP BY Dno
HAVING COUNT(*) > 1;

SELECT Dno, COUNT(*)
FROM EMPLOYEE
WHERE Salary > 40000
GROUP BY Dno;

SELECT Dno, COUNT(*)
FROM EMPLOYEE
WHERE Salary > 40000 AND Dno In (
    SELECT Dno
    FROM EMPLOYEE
    GROUP BY Dno
    HAVING COUNT(*) > 1
)
GROUP BY Dno;



--- Retrieve the Ssn of those managers who have at least on Son

SELECT *
FROM DEPARTMENT JOIN EMPLOYEE ON Ssn = Mgr_ssn;


SELECT *
FROM DEPENDENT
WHERE Essn IN (
    SELECT Mgr_ssn
    FROM DEPARTMENT JOIN EMPLOYEE ON Ssn = Mgr_ssn
);

SELECT *
FROM DEPENDENT
WHERE Relationship = 'Son' AND Essn IN (
    SELECT Mgr_ssn
    FROM DEPARTMENT JOIN EMPLOYEE ON Ssn = Mgr_ssn
);




--- Retrieve the names of those managers who have at least on Son
SELECT Essn
FROM DEPENDENT
WHERE Relationship = 'Son';

SELECT Fname, Lname
FROM DEPARTMENT JOIN EMPLOYEE ON Ssn = Mgr_ssn
WHERE Mgr_ssn IN (
    SELECT Essn
    FROM DEPENDENT
    WHERE Relationship = 'Son'
);

-- DEPENDENT JOIN MANAGER

SELECT Fname, Lname
FROM DEPENDENT AS DEP JOIN (
    SELECT *
    FROM DEPARTMENT JOIN EMPLOYEE ON Ssn = Mgr_ssn
    ) AS DEM ON DEP.Essn = DEM.Mgr_ssn
WHERE DEP.Relationship = 'Son';