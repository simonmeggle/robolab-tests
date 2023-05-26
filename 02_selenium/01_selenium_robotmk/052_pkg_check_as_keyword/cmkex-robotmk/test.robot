# Code optimization: 
# - "Check MKP Version Is Available" is now a generic keyword which tales the package name and 
#    the Checkmk version to compare against. This saved duplicate code and keeps the file readable.
# - "Search And Click Robotmk Package" also takes the package name as parameter.

# --------------------
# YOUR TASK: 
# - run the second test and think about a way to make the whole suite generic so that 
#   also the package name can be parametrized to the suite.   



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
    Search And Click Robotmk Package  RobotMK      # ⚠️ 
    Check MKP Version Is Available  Robotmk  1     # ⚠️ 
    Check MKP Version Is Available  Robotmk  2     # ⚠️ 


*** Keywords ***
Search And Click Robotmk Package
    [Arguments]  ${package}        # ⚠️ 
    [Documentation]  Searches and opens a package     # ⚠️ 
    Input Text    //input[@placeholder='here for your package']    ${package}         # ⚠️ 
    Wait Until Element Is Visible    //header[contains(text(), 'Search results')]/following-sibling::div/article/div/h5/a[contains(.,'${package}')]       # ⚠️ 
    Click Element                    //header[contains(text(), 'Search results')]/following-sibling::div/article/div/h5/a[contains(.,'${package}')]       # ⚠️   
  
Check MKP Version Is Available
    [Arguments]  ${package}  ${cmkversion}      # ⚠️ 
    [Documentation]  Checks package availability for a given CMK version      # ⚠️ 
    ${result}=  Run Keyword And Return Status         # ⚠️ 
    ...  Element Should Be Visible  //h2[text()='Latest Version ${cmkversion}.x']/following-sibling::div//td[contains(.,'Version: v${RMK_VERSION}')]     # ⚠️ 
    Run Keyword If    ${result}!=True      # ⚠️ 
    ...  Fail  msg=${package} package ${RMK_VERSION} for Checkmk V${cmkversion}.x is not available!     # ⚠️ 

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