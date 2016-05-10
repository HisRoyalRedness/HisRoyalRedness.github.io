@echo off
pushd "%~dp0.."
jekyll build --drafts
pause