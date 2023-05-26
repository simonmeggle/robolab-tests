# TEST CASE 1 should test if Robotmk is the first item in column "most downloaded".
# To be more precise: check that the headline in the first box contains "RobotMK"
# XPath explanation: 
# //header                                 a "header" tag somewhere on the page
# [contains(text(), 'Most downloaded')]    condition: its text must contain 'Most downloaded'
# /following-sibling::article[1]           from its direct successor nodes, take the first
#                                          which is an "article" tag
# /div/h5                                  div and h5 are directly below that 
# /a[contains(text(),'RobotMK')]           a link below that which contains "RobotMK" as text

# https://www.wilfried-grupe.de/contains.html
# https://www.wilfried-grupe.de/XPath_Achsen2.html

# --------------------
# YOUR TASK: 
# - set a breakpoint in line 29, start the debugger
# - at the open page try to understand this XPath 

*** Settings ***
Library           SeleniumLibrary
Documentation     This suite checks if Robotmk is Download No1 and if 
...  a given version of Robotmk is available for both major Checkmk versions
Suite Setup        Suite Initialization

*** Variables ***
${URL}        https://exchange.checkmk.com
${BROWSER}  firefox

*** Test Cases ***

Robotmk Is Most Downloaded
    Element Should Be Visible    //header[contains(text(), 'Most downloaded')]/following-sibling::article[1]/div/h5/a[contains(text(),'RobotMK')]  # ⚠️ 
    
Robotmk Version for CMK available
    No Operation


*** Keywords ***
Suite Initialization  
    [Documentation]  Start and Maximize the browser    
    Open Browser  
    ...  url=${URL}  
    ...  browser=${BROWSER}  
    ...  ff_profile_dir=set_preference("intl.accept_languages", "en") 
    Maximize Browser Window
    Wait For And Click  //button[@aria-label='Accept all']  

Wait For And Click 
    [Documentation]  Waits for an element and clicks it, if found.
    [Arguments]  ${selector}  ${timeout}=10  
    Wait Until Element Is Visible    ${selector}  ${timeout} 
    Click Element  ${selector}  