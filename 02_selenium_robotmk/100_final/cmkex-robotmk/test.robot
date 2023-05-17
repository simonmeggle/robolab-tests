# This test is ready to be executed by Robotmk.

# --------------------
# YOUR TASK: 
# - place this folder "cmkex-robotmk" in the agent/robot folder.


*** Settings ***
Library           SeleniumLibrary  run_on_failure=None 
Documentation     This suite checks if a package is Download No1 and if              
...  a given version of a package is available for both major Checkmk versions
Suite Setup        Suite Initialization  
Suite Teardown     Suite Finalization    
Test Teardown      Test Finalization      

*** Variables ***
${URL}          https://exchange.checkmk.com
${BROWSER}      firefox
${PACKAGE_NAME}      RobotMK             
${PACKAGE_VERSION}   v1.2.9               

*** Test Cases ***

Package Is Most Downloaded
    Assert Most Downloaded Item     ${PACKAGE_NAME}      
    
Package Version for CMK 1 available
    Go To    ${URL}                                                           
    Search And Click Package        ${PACKAGE_NAME}                           
    Check MKP Version Is Available  ${PACKAGE_NAME}  ${PACKAGE_VERSION}  1    

Package Version for CMK 2 available
    Go To    ${URL}                                                           
    Search And Click Package        ${PACKAGE_NAME}                           
    Check MKP Version Is Available  ${PACKAGE_NAME}  ${PACKAGE_VERSION}  2    


*** Keywords ***
Search And Click Package
    [Arguments]  ${package}         
    [Documentation]  Searches and opens a package      
    Input Text    //input[@placeholder='here for your package']    ${package}          
    Wait Until Element Is Visible    //header[contains(text(), 'Search results')]/following-sibling::div/article/div/h5/a[contains(.,'${package}')]        
    Click Element                    //header[contains(text(), 'Search results')]/following-sibling::div/article/div/h5/a[contains(.,'${package}')]          
  
Check MKP Version Is Available
    [Arguments]  ${package_name}  ${package_version}  ${cmkversion}       
    [Documentation]  Checks package availability for a given CMK version       
    ${result}=  Run Keyword And Return Status          
    ...  Element Should Be Visible  //h2[text()='Latest Version ${cmkversion}.x']/following-sibling::div//td[contains(.,'Version: ${package_version}')]        
    Run Keyword If    ${result}!=True       
    ...  Fail  msg=${package_name} package ${package_version} for Checkmk V${cmkversion}.x is not available!          

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
    ...  Fail  msg=Package ${text} is not Download No.1

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