CREATE OR REPLACE TABLE Patients (
    PatientID INT,
    FirstName STRING,
    LastName STRING,
    DateOfBirth DATE,
    Diagnosis STRING,
    AdmissionDate DATE,
    DischargeDate DATE
);

CREATE FILE FORMAT my_csv_format TYPE=CSV
FIELD_OPTIONALLY_ENCLOSED_BY='"';

CREATE OR REPLACE STAGE patient_stage
URL='s3://test/patients.csv'
CREDENTIALS=(AWS_KEY_ID='xxxxxxx' AWS_SECRET_KEY='xxxxxxxxx');


COPY INTO Patients
FROM @patient_stage
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format');

CREATE MATERIALIZED VIEW AvgStayByDiagnosis AS
SELECT Diagnosis,
       AVG(DATEDIFF(DAY, AdmissionDate, DischargeDate)) AS AvgStay
FROM Patients
GROUP BY Diagnosis;

SELECT * FROM AvgStayByDiagnosis;