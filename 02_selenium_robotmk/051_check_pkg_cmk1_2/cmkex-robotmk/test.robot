# Now that the package is displayed, let's check if the given Robotmk version is available
# for "latest" CMK version 1 and 2. 

# The Robotmk version to check is stored as a variable ${RMK_VERSION}. (This variable 
# will be set later by the RobotMK rule in Checkmk and overrides the value set here.)

# To get a proper failure message, we use the "Run Keyword And Return" keyword, too. 
# It simply returns if the package is displayed. The conditional "Fail" produces a proper
# error messgae. 

# XPath selector explanation: 
# //h2[text()='Latest Version 1.x']         find a h2 with the given text
# /following-sibling::div                   from its direct successor nodes, take the one
#                                           which is a "div" tag
# //td                                      'somewhere deeper' there mus be a td...
# [contains(.,'Version: v${RMK_VERSION}')]  ...which contains a given string.


# --------------------
# YOUR TASK: 
- look at the added code and think about an optimization.


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
    Go To    ${URL}     
    Input Text    //input[@placeholder='here for your package']    robotmk    
    # Stop at following line
    Wait Until Element Is Visible    //header[contains(text(), 'Search results')]/following-sibling::div/article/div/h5/a[contains(.,'RobotMK')]    
    Click Element                    //header[contains(text(), 'Search results')]/following-sibling::div/article/div/h5/a[contains(.,'RobotMK')]    

    # Test for Checkmk v1       # ⚠️ 
    ${result}=  Run Keyword And Return Status         # ⚠️ 
    ...  Element Should Be Visible  //h2[text()='Latest Version 1.x']/following-sibling::div//td[contains(.,'Version: v${RMK_VERSION}')]       # ⚠️ 
    Run Keyword If    ${result}!=True        # ⚠️ 
    ...  Fail  msg=Robotmk package ${RMK_VERSION} for Checkmk V1.x is not available!      # ⚠️ 

    # Test for Checkmk v2       # ⚠️ 
    ${result}=  Run Keyword And Return Status         # ⚠️ 
    ...  Element Should Be Visible  //h2[text()='Latest Version 2.x']/following-sibling::div//td[contains(.,'Version: v${RMK_VERSION}')]       # ⚠️ 
    Run Keyword If    ${result}!=True        # ⚠️ 
    ...  Fail  msg=Robotmk package ${RMK_VERSION} for Checkmk V2.x is not available!      # ⚠️ 


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