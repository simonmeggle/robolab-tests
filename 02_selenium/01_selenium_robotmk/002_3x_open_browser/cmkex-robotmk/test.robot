# The first keyword we must know is "Open Browser", which starts a Browser instance. 
# This suite would work, but it opens two instances at the same time which is not ideal. 


*** Settings ***
Library           SeleniumLibrary
Documentation     This suite checks if Robotmk is Download No1 and if 
...  a given version of Robotmk is available for both major Checkmk versions

*** Test Cases ***

Robotmk Is Most Downloaded
    Open Browser  https://exchange.checkmk.com       # ⚠️ 

Robotmk Version for CMK available
    Open Browser  https://exchange.checkmk.com       # ⚠️ 