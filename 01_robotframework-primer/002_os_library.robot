*** Settings ***
Documentation  This Robot writes a friendly message 
...  into a text file. 

Library   OperatingSystem  # ⚠️  

***Test Cases***

Write Hello World To File
    Create File    new_file.txt  Hello World!  # ⚠️  