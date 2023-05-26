# Ups. Depending on the OS language, your browser has been started with a german or english 
# locale setting => The consent button either shows
# - "Accept all"
# - "Alle akzeptieren"
# How do we guarantee that the page loads in english? 
# With SeleniumLibrary for Selenium 4.0, browsers can be parametrized directly with the
# "Open Browser" keyword. For Firefox, this is done by configuring the profile dir. Here
# we use "intl.accept_languages". 
# https://www.lambdatest.com/blog/internationalization-with-selenium-webdriver/
# https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html#Open%20Browser

# If a line gets too long, it can be splitted into multiple lines with three dots and 
# a separator. 

# "Waiting" and "Clicking" an element is a very common task. Instead of writing two lines
# for that, we created a new keyword "Wait For And Click". 
# Take note of the default argument for "timeout". 
# https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#user-keyword-arguments

# --------------------
# YOUR TASK: 
# - switch your OS to German language
# - debug the test, check for a German cookie consent button
# - comment the first "Open browser" keyword, uncomment the second
# - restart the debugger (Ctrl+Shift+F5)
# - Do you see the Button "Accept All" ? 
# - Experiment with other locales: pl, ru, es, ... 

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
    No Operation

Robotmk Version for CMK available
    No Operation


*** Keywords ***
Suite Initialization  
    [Documentation]  Start and Maximize the browser
    Open Browser  
    ...  url=${URL}  
    ...  browser=${BROWSER}      
    # Open Browser  
    # ...  url=${URL}  
    # ...  browser=${BROWSER}  
    # ...  ff_profile_dir=set_preference("intl.accept_languages", "en")  # ⚠️ 
    Maximize Browser Window
    Wait For And Click  //button[@aria-label='Accept all']    # ⚠️ 



Wait For And Click 
    [Documentation]  Waits for an element and clicks it, if found.
    [Arguments]  ${selector}  ${timeout}=10    # ⚠️ 
    Wait Until Element Is Visible    ${selector}  ${timeout}    # ⚠️ 
    Click Element  ${selector}    # ⚠️ 