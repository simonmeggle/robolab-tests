*** Settings ***
# in case of an error, take a screenshot and embed the image into the log
Library     Browser    timeout=10
...             run_on_failure=Take Screenshot \ EMBED
...             enable_presenter_mode={"duration": "1 seconds", "width": "4px", "style": "dotted", "color": "red"}
# ...    enable_presenter_mode=%{PRESENTER_MODE=False}


*** Variables ***
${URL}      https://oxid.robotmk.org


*** Keywords ***
Login
    [Documentation]    Performs a login with the given username/password.
    ...    Depending on the expectfail parameter, an error or success is expected.
    [Arguments]    ${username}    ${password}    ${expectfail}=False
    Click    div.service-menu > button
    Fill text    input#loginEmail    ${username}
    Fill text    input#loginPasword    ${password}
    Click    div.service-menu form >> //button[normalize-space()='Anmelden']
    IF    ${expectfail} == ${True}
        Get Element States
        ...    p#errorBadLogin
        ...    *=
        ...    visible
        ...    message="Did not receive expected error after login attempt with invalid credentials!"
    ELSE
        Get Element States
        ...    div.service-menu >> //button[contains(text(),"Mein Konto")]
        ...    *=
        ...    visible
        ...    message="Login failed!"
    END

Empty Basket
    [Documentation]    Removes all items from the basket.
    # Click    text=Warenkorb    # NOT POSSIBLE - matches where text is contained (5 results)
    # Click    text=/^(Waren|Einkaufs)korb$/    # POSSIBLE with regex
    Click    text="Warenkorb"    # Simple EXAKT text matching
    ${warning_basket_empty}=    Get Element Count    div#empty-basket-warning
    IF    ${warning_basket_empty} == 0
        Click    button#basketRemoveAll
        Click    button#basketRemove
        Get Element States    div#empty-basket-warning    *=    visible    message=Basket could not be cleared!
    END
    Go To    ${URL}

Search And Select Article
    [Documentation]    Performans an article query and opens the first mathcing item.
    [Arguments]    ${articleid}    ${expect_string}    ${price}
    Fill Text    input#searchParam    ${articleid}
    Click    form.search button
    Get Text    div.list-container div.row:first-child div.productData:first-child    *=    ${expect_string}
    Click    div.list-container div.row:first-child div.productData:first-child div.actions a
    Get Text    div.detailsInfo    *=    ${expect_string}
    Click    button#toBasket
    Click    a[title='Warenkorb zeigen']
    Get Text    td#basketGrandTotal    ==    ${price}

Open Oxid Webshop
    [Documentation]    Opens the web shop
    [Arguments]    ${browser}
    New Browser    browser=${browser}    headless=False
    # A viewport of None leads to a browser window with optimal width and maximal height
    # If the page is i18n, setting the context locale can result in the desired page language.
    New Context    viewport=${None}    locale=de-DE
    New Page    ${URL}
    # For conveniance, "Open Browser" wraps all three "New..." keywords:
    #Open Browser    ${URL}    ${browser}    headless=False    # do not use in production
