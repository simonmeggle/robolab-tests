# As we want to open the browser only ONCE per suite, we use the "Suite Setup" 
# setting: it allows to define any keyword (builtin or user) which must be executed
# before the first test starts. ("Suite Initialization")
# https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#suite-setup-and-teardown

# The arguments "url" and "browser" are taken from variables we have defined in the
# "Variables" section. In this way, the browser or url can be switched easy. It is 
# also possible to override these variables from the commandline.
# https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#setting-variables-in-command-line

# Also in the Setup keyword we Maximize the browser window. 
# After that we wait for the cookie consent button. Then we click it. 
# https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html#Click%20Element

# --------------------
# YOUR TASK: 
# - set a breakpoint at "No Operation" in Test case 1
# - debug the suite 
# - FF should open the page and click away the cokie button. 

*** Settings ***
Library           SeleniumLibrary
Documentation     This suite checks if Robotmk is Download No1 and if 
...  a given version of Robotmk is available for both major Checkmk versions
Suite Setup        Suite Initialization  # ⚠️ 

*** Variables ***
${URL}        https://exchange.checkmk.com  # ⚠️ 
${BROWSER}  firefox  # ⚠️ 

*** Test Cases ***

Robotmk Is Most Downloaded
    No Operation        # ⚠️ 

Robotmk Version for CMK available
    No Operation        # ⚠️ 

*** Keywords ***
Suite Initialization  
    [Documentation]  Start and Maximize the browser
    Open Browser  url=${URL}  browser=${BROWSER}  # ⚠️ 
    Maximize Browser Window  # ⚠️ 
    Wait Until Element Is Visible  //button[@aria-label='Accept all']    # ⚠️ 
    Click Element  //button[@aria-label='Accept all']    # ⚠️ 