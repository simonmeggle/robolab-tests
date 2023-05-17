*** Settings ***
Documentation       Oxid eshop test for login and item search.

Resource            oxid_eshop.resource
Library             CryptoLibrary    password=%{ROBOT_CRYPTO_KEY_PASSWORD_OXID}
...                     variable_decryption=True    key_path=${CURDIR}${/}keys

Test Setup          Open Webshop


*** Variables ***
${USERNAME}     mail@robotmk.org
${PASSWORD}     crypt:bD22YdO6Om/M63SHz3clvZ4UKpEonuvUh0nO+vHymmFGWjzPveg+dSTFGlVRmSk7ZQQj7anvpBA=


*** Test Cases ***
Login with valid credentials
    [Documentation]    A user with valid credentials must be able to login.
    Login    ${USERNAME}    ${PASSWORD}    expectfail=False

Login with invalid credentials
    [Documentation]    A user with valid credentials must be able to login.
    Login    ${USERNAME}    wrongpassword    expectfail=True

Search Item And Add To Basket
    [Documentation]    Searches for an article and adds it to the basket.
    ...    Tries to navigate to the checkout page.
    Empty Basket
    Search And Open Article
    ...    articleid=2402
    ...    expect_string=Bindung LIQUID FORCE TRANSIT BOOT
    ...    price=259,00 €


*** Keywords ***
Open Webshop
    [Documentation]    Opens the web shop.
    Open Oxid Webshop    chromium
