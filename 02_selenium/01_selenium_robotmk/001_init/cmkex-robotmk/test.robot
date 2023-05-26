# Welcome to this Robot Framework test! Our goal is to write tests which 
# are in the Doc string. From that, we have scaffolded a suite file: 
# - In Settings, we import the SeleniumLibrary and wrote the docstring 
# - In Test Cases, we created two test cases, but still empty. RF does not allow
#   to have emtpy tests, we use the keyword "No Operation" from the Builtin library. 
#   It does, right: nothing but prevents an error message.  

*** Settings ***
Library           SeleniumLibrary
Documentation     This suite checks if Robotmk is Download No1 and if 
...  a given version of Robotmk is available for both major Checkmk versions

*** Test Cases ***

Robotmk Is Most Downloaded
    No Operation

Robotmk Version for CMK available
    No Operation