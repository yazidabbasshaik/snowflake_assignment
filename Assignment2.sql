CREATE OR REPLACE TABLE Final_PatientRecords (
    PatientID INT,
    FirstName STRING,
    LastName STRING,
    DateOfBirth DATE,
    Diagnosis STRING,
    AdmissionDate DATE,
    DischargeDate DATE
);

CREATE OR REPLACE STREAM Staging_PatientRecords_Stream 
ON TABLE PATIENTS
SHOW_INITIAL_ROWS = TRUE;


select * from Staging_PatientRecords_Stream


CREATE OR REPLACE TASK Process_PatientRecords
  WAREHOUSE = 'COMPUTE_WH'
  SCHEDULE = '5 MINUTE'
AS
  INSERT INTO Final_PatientRecords (PatientID, FirstName, LastName, AdmissionDate, DischargeDate, Diagnosis)
  SELECT PatientID, FirstName, LastName, AdmissionDate, DischargeDate, Diagnosis
  FROM Staging_PatientRecords_Stream
  WHERE METADATA$ACTION = 'INSERT'  
  OR METADATA$ACTION = 'UPDATE';

ALTER TASK Process_PatientRecords RESUME;

select * from Final_PatientRecords


SELECT COUNT(*)
FROM PATIENTS
WHERE AdmissionDate BETWEEN '2024-01-01' AND '2024-12-31';

ALTER TABLE PATIENTS 
  CLUSTER BY (AdmissionDate);

SHOW CLUSTERING INFORMATION FOR TABLE PATIENTS;


SELECT COUNT(*)
FROM PATIENTS
WHERE AdmissionDate BETWEEN '2024-01-01' AND '2024-12-31';









