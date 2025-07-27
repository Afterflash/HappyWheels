@echo off
echo building SWF...
call core\sdk\bin\compc -source-path src -include-sources src -output core\libs\happy_wheels.swc >nul
call asconfigc --sdk core\sdk --debug=true >nul
echo done.