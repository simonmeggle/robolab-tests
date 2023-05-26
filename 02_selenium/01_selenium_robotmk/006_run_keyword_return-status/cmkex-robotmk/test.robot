# In the last test, you probably got an ugly error like this: 
# Element with locator '//header[contains(text(), 'Most downloaded')]/following-sibling::article[1]/div/h5/a[contains(text(),'RobotsMK')]' not found.
# This is how it would be displayed in Checkmk... let's display a more readable message. 

# "Assert Most Downloaded Item" is a user keyword which encapsulates the technical stuff
# and will keep the Checkmk service output uncluttered. 
# To write it in a generic way, it takes the package name (Robotmk) as an argument. 

# Look into the new keyword:
# Instead of letting "Element should be Visible" fail for itself, we wrap it with 
# "Run Keyword And Return Status". The return code of this is silently saved into a variable
# "${result}". 
# "Run Keyword If" evaluates the result variable if it is True. 
# If not, we raise a custom - and more readable - error message with "Fail". 

https://robotframework.org/robotframework/latest/libraries/BuiltIn.html#Run%20Keyword%20And%20Return%20Status
https://robotframework.org/robotframework/latest/libraries/BuiltIn.html#Run%20Keyword%20If
https://robotframework.org/robotframework/latest/libraries/BuiltIn.html#Fail

# --------------------
# YOUR TASK: 
# - run the suite
# - open the log.html and examine the result.
# - try to run the suite with the package name XXXX (uncomment the line) and view how the 
#   HTML report nicely reports: "XXXXX is not Download No.1"
 
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
    Assert Most Downloaded Item  RobotMK    # ⚠️  
    # Assert Most Downloaded Item  XXXXX    # ⚠️  
    
Robotmk Version for CMK available
    No Operation


*** Keywords ***

Assert Most Downloaded Item
    [Arguments]  ${text}
    [Documentation]  Asserts that the most downloaded CMK package title contains 
    ...  a certain string. 
    ${result}=  Run Keyword And Return Status   # ⚠️  
    ...  Element Should Be Visible    //header[contains(text(), 'Most downloaded')]/following-sibling::article[1]/div/h5/a[contains(text(),'${text}')]
    Run Keyword If    ${result}!=True     # ⚠️ 
    ...  Fail  msg=${text} is not Download No.1   # ⚠️ 

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