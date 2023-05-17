*** Settings ***
Library                             OperatingSystem

*** Variables ***
# In the variables section, you can assign values with ...
${GOOD_TEXT}=                      Hello nice humans!   # ⚠️  
# ...or without an equal (=) sign. 
${BAD_TEXT}                         Robots will take over!   # ⚠️  

***Test Cases***

Write Hello World To File
    Create File                     new_file.txt                        ${GOOD_TEXT}  # ⚠️  
    File Should Not Be Empty        new_file.txt  # ⚠️  

Test If File Is Friendly
    ${file_content} =               Get File                            new_file.txt  # ⚠️  
    Should Be Equal                 ${file_content}                     ${GOOD_TEXT}  # ⚠️  
    Should Not Be Equal             ${file_content}                     ${BAD_TEXT}   # ⚠️  