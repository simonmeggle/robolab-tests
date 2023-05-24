*** Settings ***
Library     Browser


*** Test Cases ***
Example Web Test 
    New Browser    firefox    headless=false
    New Page    https://playwright.dev
    Get Text    h1    ==    Playwright enables reliable end-to-end testing for modern web apps.
    Take Screenshot    filename=EMBED