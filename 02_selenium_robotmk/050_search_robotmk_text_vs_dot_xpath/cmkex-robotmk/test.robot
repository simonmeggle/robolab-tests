# The next test should check if a given Robotmk version is available for Checkmk major
# version 1 and 2. 
# The Robotmk version to check is stored as a variable ${RMK_VERSION}. (This variable 
# will be set later by the RobotMK rule in Checkmk and overrides the value set here.)

# The "Go To" keyword assures that the test always starts from the Exchange start page 
# (never rely on a given applciation status!).

# "Input Text" enters the string "robotmk" into the search bar. 
# XPath selector explanation: 
# //input                        a input field anywhere on the document
# [@placeholder='here for your package']  its placeholder attribute must have this string

# We expect now that the Robotmk package gets displayed after entering the search string.
# After that we click the package item to open it. 

# XPath selector explanation: 
# //header                                  a "header" tag somewhere on the page
# [contains(text(), 'Search results')]      condition: its text must contain 'Search results'
# /following-sibling::div                   from its direct successor nodes, take the first
#                                           which is an "div" tag
# /article/div/h5/a[contains(.,'RobotMK')]  go for a link below which contains "RobotMK" 

# Watch out - this time we have to use a dot instead of text().
# The difference between text() and ".": 
#  1) contains(text(), 'abc')  ==> only return the text node of the curent node.
#  2) contains(., 'abc')       ==> . is "stringified current node", with all contained text nodes 
#                                      concatenated, recursively resolved.

# <a href="/p/robotmk" class="package-list__item__link">
#    <b>RobotMK</b> | Robot Framework End2End
#                  ^-------------------------^  text()
#       ^-----^  + ^-------------------------^  .
# </a>

# --------------------
# YOUR TASK: 
# - set a breakpoint at the line after "Stop at the following line"
# - Open the browser devtool console and try to understand the difference between both XPaths: 
#   //header[contains(text(), 'Search results')]/following-sibling::div/article/div/h5/a[contains(.,'RobotMK')]
#   //header[contains(text(), 'Search results')]/following-sibling::div/article/div/h5/a[contains(text(),'RobotMK')]

*** Settings ***
Library           SeleniumLibrary  run_on_failure=None 
Documentation     This suite checks if Robotmk is Download No1 and if 
...  a given version of Robotmk is available for both major Checkmk versions
Suite Setup        Suite Initialization  
Suite Teardown     Suite Finalization    
Test Teardown      Test Finalization      

*** Variables ***
${URL}          https://exchange.checkmk.com
${BROWSER}      firefox
${RMK_VERSION}  1.2.9

*** Test Cases ***

Robotmk Is Most Downloaded
    Assert Most Downloaded Item  RobotMK
    
Robotmk Version for CMK available
    Go To    ${URL}      # ⚠️ 
    Input Text    //input[@placeholder='here for your package']    robotmk     # ⚠️ 
    # Stop at following line
    Wait Until Element Is Visible    //header[contains(text(), 'Search results')]/following-sibling::div/article/div/h5/a[contains(.,'RobotMK')]     # ⚠️ 
    Click Element                    //header[contains(text(), 'Search results')]/following-sibling::div/article/div/h5/a[contains(.,'RobotMK')]     # ⚠️ 
     


*** Keywords ***

Test Finalization
    Run Keyword If Test Failed
    ...  Capture Page Screenshot  filename=EMBED    

Suite Finalization
    Close All Browsers    

Assert Most Downloaded Item
    [Arguments]  ${text}
    [Documentation]  Asserts that the most downloaded CMK package title contains 
    ...  a certain string. 
    ${result}=  Run Keyword And Return Status 
    ...  Element Should Be Visible    //header[contains(text(), 'Most downloaded')]/following-sibling::article[1]/div/h5/a[contains(text(),'${text}')]
    Run Keyword If    ${result}!=True  
    ...  Fail  msg=${text} is not Download No.1

Suite Initialization  
    [Documentation]  Start and Maximize the browser    
    Open Browser  
    ...  url=${URL}  
    ...  browser=${BROWSER}  
    ...  ff_profile_dir=set_preference("intl.accept_languages", "en") 
    ...  service_log_path=None    
    Maximize Browser Window
    Wait For And Click  //button[@aria-label='Accept all']  

Wait For And Click 
    [Documentation]  Waits for an element and clicks it, if found.
    [Arguments]  ${selector}  ${timeout}=10  
    Wait Until Element Is Visible    ${selector}  ${timeout} 
    Click Element  ${selector}  