@echo off

REM #========================================================
REM #        Developed by Raku (rakudayo@gmail.com)
REM #========================================================
REM # Use this batch file as you please.
REM #========================================================

REM #========================================================
REM #  Setup the Paths for the Importer/Exporter
REM #========================================================

REM # The path to the utility scripts relative to the project dir
SET SCRIPTS_DIR="Utility"

REM # The path to the project dir relative to the utility scripts
SET PROJECT_DIR=".."

REM #===============================
REM #  Change to Scripts Directory
REM #===============================

SET PREV_DIR=%CD%
CD %SCRIPTS_DIR%

REM #========================
REM #  RGSS script Importer
REM #========================

RUBY script_importer.rb %PROJECT_DIR%

REM #======================
REM #  RMXP Data Importer
REM #======================

RUBY data_importer.rb %PROJECT_DIR%

REM #=======================
REM #  Start RPG Maker XP
REM #=======================

RUBY start_rmxp.rb %PROJECT_DIR%

REM #======================
REM #  RMXP Data Exporter
REM #======================

RUBY data_exporter.rb %PROJECT_DIR%

REM #========================
REM #  RGSS Script Exporter
REM #========================

RUBY script_exporter.rb %PROJECT_DIR%

REM #================================
REM #  Return to Original Directory
REM #================================

CD %PREV_DIR%