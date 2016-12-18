:: If the time is less than two digits insert a zero so there is no space to break the filename
:: If the time is less than two digits insert a zero so there is no space to break the filename
:: If you have any regional date/time issues call this include: getdate.cmd  credit: Simon Sheppard for this cmd - untested
:: call getdate.cmd

set year=%DATE:~10,4%
set day=%DATE:~7,2%
set mnt=%DATE:~4,2%
set hr=%TIME:~0,2%
set min=%TIME:~3,2%

IF %day% LSS 10 SET day=0%day:~1,1%
IF %mnt% LSS 10 SET mnt=0%mnt:~1,1%
IF %hr% LSS 10 SET hr=0%hr:~1,1%
IF %min% LSS 10 SET min=0%min:~1,1%

set backuptime=%year%-%day%-%mnt%-%hr%-%min%
echo %backuptime%

pause

:: SETTINGS AND PATHS 
:: Note: Do not put spaces before the equal signs or variables will fail

:: set backup directory which u want to take backup.

set backupfldr="D:\Majnu (2016) ~320Kbps"

:: set a path to same the backup .zip file.

set datafldr="F:\backup\"

:: Path to zip executable
set zipper="F:\7za.exe"

:: Number of days to retain .zip backup files 
::set retaindays=5

:: DONE WITH SETTINGS

pause

:: GO FORTH AND BACKUP EVERYTHING!

:: Switch to the data directory to enumerate the folders

pushd %datafldr%

pause

echo "Zipping folders  in the folder"

pause

:: .zip option clean but not as compressed

%zipper% a -tzip "%backuptime%.zip"   "D:\Majnu (2016) ~320Kbps" 
::%zipper% a -tzip  "%backuptime%-new.zip"   "D:\Soft"

::%zipper% a -tzip "%backuptime%.zip"  "%backupfldr%\backup" 

pause

echo "done"

pause

echo "Syncing data to s3" 

pushd %datafldr%


::aws s3 sync  "F:\backup\"   s3://mytes 


echo "pushing data completed"

:: Number of days to retain .zip backup files 
set retaindays=5

echo "Deleting zip files older than 30 days now"

:: turn on if you are debugging
@echo on

:: Delete Files Older than 5 Days  in backup path 

forfiles -p "F:\backup" -s -m *.* -d -5 -c "cmd /c del @path"

pause

::aws s3 sync  "F:\backup"   s3://mytes 
::aws s3 sync  "F:\backup"   s3://mytes 

::return to the main script dir on end
popd
