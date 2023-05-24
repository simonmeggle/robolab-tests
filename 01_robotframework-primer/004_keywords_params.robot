*** Comments ***
This example shows how to use the OperatingSystem library to create a file and write text to it.
It also shows how keywords are defined and used.

*** Settings ***
Library                             OperatingSystem

*** Variables ***
# In the variables section, you can assign values with ...
${GOOD_TEXT}=                      Hello nice humans! 
# ...or without an equal (=) sign. 
${BAD_TEXT}                         Robots will take over! 

***Test Cases***
Write Hello World To File
    [Documentation]  Creates a File with the text "Hello World" and checks if the file is not empty.
    Create File                     new_file.txt                        ${GOOD_TEXT}
    File Should Not Be Empty        new_file.txt

Test If File Is Friendly
    [Documentation]  Compares the content of a file with a friendly text.
    ${file_content} =               Get File                            new_file.txt
    Compare The Results      ${file_content}


*** Keywords ***
Compare The Results
    [Arguments]  ${text}  
    Should Be Equal                 ${text}                     ${GOOD_TEXT}
    Should Not Be Equal             ${text}                     ${BAD_TEXT}