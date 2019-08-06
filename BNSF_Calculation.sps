* Encoding: UTF-8.
COMMENT Retrieve Historical Skytguard Warning File.
GET DATA  /TYPE=TXT
  /FILE="C:\ArcGIS\Data\bnsf_warnings_with_duration\bnsf_wind_warnings_2015-2019.csv"
  /ENCODING='Locale'
  /DELCASE=LINE
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  START_DATE A25
  END_DATE A25
  DURATION F3.0
  WIND_TYPE A15
  SPEED F2.0
  SUBDIVISION A20
  DIV_MILEPOST A50
  LAT F16.13
  LON F17.12.
CACHE.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.

COMMENT Save file to local drive.
SAVE OUTFILE='C:\ArcGIS\Data\SkyGuardWarnings.sav'
  /COMPRESSED.

COMMENT Create Date Variables; Hour, Month, Day, Year.
STRING YEAR (A4). 
COMPUTE YEAR = CHAR.SUBSTR(START_DATE, 1, 4).
STRING MONTH (A2).
COMPUTE MONTH = CHAR.SUBSTR(START_DATE, 6,7).
STRING DAY (A2).
COMPUTE DAY = CHAR.SUBSTR(START_DATE, 9,10).
STRING HOUR (A2).
COMPUTE HOUR = CHAR.SUBSTR(START_DATE, 12,13).
EXECUTE.

COMMENT Observe speeds.
FREQUENCIES SPEED.

COMMENT Human error in speeds, recode the values above 100. 
IF SPEED = 550 SPEED = 55.
IF SPEED = 555 SPEED = 55.
IF SPEED = 565 SPEED = 65. 
IF SPEED = 600 SPEED = 60.
IF SPEED = 602 SPEED = 60.
IF SPEED = 605 SPEED = 60. 
IF SPEED = 630 SPEED = 63.
IF SPEED = 650 SPEED = 65. 
IF SPEED = 655 SPEED = 65.
IF SPEED = 700 SPEED = 70.
EXECUTE.
COMMENT Rerrun Frequencies on Speed to make sure all values have switched. 

COMMENT Observe Duration.
FREQUENCIES DURATION.
COMPUTE DURATION = ABS(DURATION).
EXECUTE.

COMMENT Aggregate data taking the average duration in minutes for a period of time (to begin, let's start with day).
DATASET DECLARE AverageDuration.
AGGREGATE
  /OUTFILE='AverageDuration'
  /BREAK=WIND_TYPE SUBDIVISION DIV_MILEPOST MONTH DAY
  /AVG_TIME=MEAN(DURATION)
  /TOT_TIME=SUM(DURATION)
  /LAT=FIRST(LAT) 
  /LON=FIRST(LON)
  /SPEED=MEAN(SPEED).

COMMENT Select only the divisions of interest; PANHAN, HEREFO, CLOVIS, GALLUP, SELIGM.
TEMPORARY.
SELECT IF SUBDIVISION = "PANHAN" OR SUBDIVISION="HEREFO" OR SUBDIVISION="CLOVIS" OR SUBDIVISION="GALLUP" OR SUBDIVISION="SELIGM".
SAVE OUTFILE 'C:\ArcGIS\Data\SkyGuardWarnings_Selection.sav'.
GET FILE 'C:\ArcGIS\Data\SkyGuardWarnings_Selection.sav'.
EXECUTE.

COMMENT Create a categorial variable for wind speed; 51 to 60, 61 to 70, 71 and higher.
COMPUTE SPEED_CAT = 0.
IF SPEED GE 51 AND SPEED LE 60 SPEED_CAT=1.
IF SPEED GT 60 AND SPEED LE 70 SPEED_CAT=2. 
IF SPEED GT 70 SPEED_CAT=3. 
EXECUTE.

COMMENT Create Date Variable from MONTH and DAY string in MM/DD format.
STRING DATE (A5).
COMPUTE DATE = CONCAT(MONTH,"/",DAY).
EXECUTE.

COMMENT Save File. 
SAVE OUTFILE='C:\ArcGIS\Data\SkyGuardWarnings_Selection.sav'
  /COMPRESSED.

COMMENT Save DBF File for ArcGIS analysis.
SAVE TRANSLATE OUTFILE='C:\ArcGIS\Data\AvgDurationByTrack_Final.dbf'
  /TYPE=DBF
  /VERSION=4
  /MAP
  /REPLACE.

COMMENT Save as CSV file for Excel Workbook.
SAVE TRANSLATE OUTFILE='C:\ArcGIS\Data\SkyGuardWarnings.csv'
  /TYPE=CSV
  /ENCODING='UTF8'
  /MAP
  /REPLACE
  /FIELDNAMES
  /CELLS=VALUES.

************Emerging Hot Spot Analysis***************************************.
COMMENT Compute Date Variable. 
STRING DATE_STR (A11).
COMPUTE DATE_STR = CONCAT(YEAR,"-",MONTH,"-",DAY).
EXECUTE.

