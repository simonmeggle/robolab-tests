# In case of a test failure, you probably want to know how the application looked like
# at this moment. 
# SeleniumLibrary has a built-in mechanism to capture screenshots if ANY keyword failed.
# ("Run-on-failure functionality") 
# This is not ideal because it also applies to keywords which are allowed to fail when 
# they are wrapped. 

# During the library import, we override the default keyword to run on failure (Capture Page Screenshot)
# with "None".
# Instead of the default, we use the "Test Teardown" functionality and define a custom
# keyword to run after each test execution. 
http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#test-setup-and-teardown
# Inside of "Test Finalization", the keyword "Run Keyword If Test Has Failed" only executes
# the screen capture keyword, if the test really failed. 
# A filename argument of "EMBED" embeds the taken screenshot directly into the HTML log
# (instead of saving it to disk). 
# https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html#Capture%20Page%20Screenshot

# Btw, 
# - we also add a new argument 'service_log_path=None' to the "Open Browser" keyword. This 
#   prevents the webdrivers to create a log file for each run. 
# - The opened browser should be closed after the Robot execution anyway, but it is good
#   practice to do this implicitly. Note the "Suite Teardown" hook which calls "Suite Finalization".

# --------------------
# YOUR TASK: 
# - Delete all "selenium-screenshot-X.png" files from your suite folder. 
# - Delete all "geckodriver-X.log" log files from your suite folder. 
# - Execute Test 1 again with a wrong package name to let the test fail. 
# - There should be neither a webdriver log nor a screenshot file on the file system.
# - Instead you should see the screenshot of the web page embeded within the log.html
 
*** Settings ***
Library           SeleniumLibrary  run_on_failure=None  # ⚠️ 
Documentation     This suite checks if Robotmk is Download No1 and if 
...  a given version of Robotmk is available for both major Checkmk versions
Suite Setup        Suite Initialization  
Suite Teardown     Suite Finalization     # ⚠️ 
Test Teardown     Test Finalization       # ⚠️ 

*** Variables ***
${URL}        https://exchange.checkmk.com
${BROWSER}  firefox

*** Test Cases ***

Robotmk Is Most Downloaded
    Assert Most Downloaded Item  RobotMdK
    
Robotmk Version for CMK available
    No Operation


*** Keywords ***

Test Finalization
    Run Keyword If Test Failed
    ...  Capture Page Screenshot  filename=EMBED     # ⚠️ 

Suite Finalization
    Close All Browsers     # ⚠️ 

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
    ...  service_log_path=None     # ⚠️ 
    Maximize Browser Window
    Wait For And Click  //button[@aria-label='Accept all']  

Wait For And Click 
    [Documentation]  Waits for an element and clicks it, if found.
    [Arguments]  ${selector}  ${timeout}=10  
    Wait Until Element Is Visible    ${selector}  ${timeout} 
    Click Element  ${selector}  