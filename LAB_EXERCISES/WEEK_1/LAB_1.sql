/*
                                            WEEK-1:
*/
-- 1.0: Create the tables with the following columns and constraints with given constraint names: 

create table EMP(
    EMPCODE numeric(3) constraint PK_EMPNO primary key,
    Name varchar2(10),
    Qualification varchar2(7) constraint VALID_QUALIF check(Qualification IN ('BTECH','MTECH','MSC','MCA','PHD')),
    Phone varchar2(14),
    Email varchar2(20) constraint EMAIL_DOMAIN check(Email LIKE ('%@digisol.com')),
    Designation varchar2(20) constraint VALID_DESIGNATION check(Designation IN ('DEVELOPER','PROJECT LEADER','PROJECT MANAGER','TECHNICAL HEAD','PROJECT DIRECTOR','CEO')),
    Salary numeric(7) constraint SALARY_RANGE check(Salary>=97000 AND Salary<=300000)
);

create table PRJ_DETAILS(
    PRJID char(3) constraint PK_PRJID primary key check(PRJID LIKE ('P%')),
    PRJ_NAME varchar2(10),
    STRAT_DATE Date,
    END_DATE Date,
    ACTUAL_END_DATE Date,
    LEAD_BY_EMPCODE numeric(3) constraint FK_LEAD_EMP references EMP,
    BUDGET_ALLOCATED numeric(10,1),
    ACTUAL_BUDGET numeric(10,1),
    constraint END_DATE_GREATER_START_DATE check(END_DATE>STRAT_DATE),
    check(ACTUAL_END_DATE>=END_DATE)
);

create table SKILL(
    SKILLID char(3) constraint UNQ_SKILLID unique,
    SKILLNAME varchar(20) constraint UNQ_SKILLNAME unique
);

create table CLIENT(
    CLIENTID char(3) constraint PK_CLIENTID primary key constraint STARTWITH_C check(CLIENTID LIKE ('C%')),
    Name varchar2(10),
    Phone char(14) constraint PHONE_FORMAT check(Phone like '+91-%' OR Phone like '+81-%'OR Phone like '+31-%'OR Phone like '+48-%'OR Phone like '+44-%')
);

create table EMP_SKILL(
    EMPNO numeric(3) constraint FK_EMPNO references EMP,
    SKILLID char(3) constraint FK_SKILLID references SKILL(SKILLID) on delete cascade,
    SKILL_EXPERIENCE numeric(3) check(SKILL_EXPERIENCE>0)
);

create table WORK_EXP(
    EMPCODE numeric(3) references EMP,
    PRJID char(3) references PRJ_DETAILS,
    WORK_EXPERIENCE numeric(3) check(WORK_EXPERIENCE>=0) not null,
    CLIENTID char(3) references CLIENT on delete set null,
    RATING char(1) constraint RATING_CHECK check(RATING IN ('A','B','C')),
    primary key(EMPCODE, PRJID)
);

create table FAMILY_DEPENDENTS(
    EMPNO numeric(3) references EMP,
    DEP_NAME varchar(20),
    RELATIONSHIP varchar(16),
    AGE numeric(3) constraint VALID_AGE check(AGE>=1 AND AGE<=130),
    primary key(EMPNO,DEP_NAME)
);

create table MEDICAL_POLICY(
    EMPNO numeric(3) references EMP,
    POLICYNO varchar2(6) constraint POLICY_CHECK check(POLICYNO LIKE 'MED%'),
    PREMIUM numeric(6) constraint CHECK_PREMIUM check (PREMIUM>0),
    POLICYDATE Date,
    primary key(EMPNO,POLICYNO)
);

create table PAY_CHECK(
    EMPCODE numeric(3) references EMP,
    PAY_DATE Date,
    REGULAR_INCREMENT numeric(4) constraint VALID_REGU_INCENTIVE check(REGULAR_INCREMENT in (2000,3000,5000,7000,9000)),
    PERFORMANCE_INCENTIVE numeric(5),
    DA numeric(7),
    PF numeric(6),
    OTHER_INCENTIVES numeric(4),
    ADVANCE_TAX numeric(5),
    primary key(EMPCODE, PAY_DATE)
);

--1.1:  Add column REPORTS_TO to EMP table with Foreign Key constraint refereing to EMPCODE and constraint name -FK_REPORTS_TO_EMPCODE.
ALTER TABLE EMP add REPORTS_TO numeric(3);
ALTER TABLE EMP add constraint FK_REPORTS foreign key(REPORTS_TO) references EMP(EMPCODE); 

--1.2: Set a constraint on SKILLID column belonging to SKILL table- every column value starts with letter 'S'. 
ALTER TABLE  SKILL ADD constraint STARTWITH_S check (SKILLID LIKE 'S%');

--1.3: Add  primary  key  constraint  on  EMPNO,  SKILLID  columns  belonging  to  EMP_SKILL  table  having constraint name- PK_EMPNO_SKILLID.
ALTER TABLE EMP_SKILL ADD constraint PK_EMPNO_SKILLID primary key(EMPNO,SKILLID);

--1.4: Set  Unique  constraint  on  PRJ_NAME  belonging  to  PRJ_DETAILS  table  with  constraint  name UNQ_PRJ_NAME. 
ALTER TABLE PRJ_DETAILS ADD constraint UNQ_PRJ_NAME unique(PRJ_NAME);

--1.5:  ADD column EMAIL to CLIENT & constraint with name 'VALID_EMAIL', valid only if-contains @. Symbols as in email format and there must be only 3 letters after. symbol on EMAIL column.
ALTER TABLE CLIENT ADD EMAIL varchar2(20);
ALTER TABLE CLIENT ADD constraint VALID_EMAIL check(EMAIL like '%@%.___');

--1.6:  Add Unique Key constraint on PHONE belonging to EMP having constraint name -UNQ_PHONE.
ALTER TABLE EMP add constraint UNQ_PHONE unique(PHONE);

--1.7:  Add Unique Key constraint on EMAIL belonging to EMP having constraint name -UNQ_EMAIL. 
ALTER TABLE EMP add constraint UNQ_EMAIL unique(EMAIL);

--1.8: Drop  primary  key  constraint  from  MEDICAL_POLICY  table  and  add  primary  key  constraint  on EMPNO, POLICYNO, POLICYDATE.
ALTER TABLE MEDICAL_POLICY DROP primary key;
ALTER TABLE MEDICAL_POLICY ADD constraint PK_EMPNO_POLICYNO_POLICYDATE primary key(EMPNO,POLICYNO,POLICYDATE);

--1.9:  Drop  constraint  from  PREMIUM  belonging  to  MEDICAL_POLICY  table  &  add  new  constraint that PREMIUM amount must be more than 1000/-. 
ALTER TABLE MEDICAL_POLICY DROP constraint CHECK_PREMIUM;
ALTER TABLE MEDICAL_POLICY ADD constraint CHECK_PREMIUM check(PREMIUM>1000);

COMMIT;
clear screen;