*** Settings ***

Library             Browser  
...  enable_presenter_mode={"duration": "1 seconds", "width": "6px", "style": "dotted", "color": "red"}  
...  run_on_failure=Take Screenshot \ EMBED   

*** Variables ***
${URL}          https://oxid.robotmk.org
${USERNAME}     mail@robotmk.org
${PASSWORD}     crypt:bD22YdO6Om/M63SHz3clvZ4UKpEonuvUh0nO+vHymmFGWjzPveg+dSTFGlVRmSk7ZQQj7anvpBA=    #


*** Keywords ***
Login
    [Documentation]    Performs a login with the given username/password.
    ...    Depending on the expectfail parameter, an error or success is expected.
    [Arguments]   ${uname}=${USERNAME}    ${pwd}=${PASSWORD}   ${expectfail}=False
    Click
    ...    div.service-menu > button
    Fill text
    ...    input#loginEmail
    ...    ${uname}
    Fill text    input#loginPasword    ${pwd}
    Click    div.service-menu form button
    IF    ${expectfail} == ${True}
        Get Element States
        ...    p#errorBadLogin
        ...    *=
        ...    visible
        ...    message="Did not receive expected error after login attempt with invalid credentials!"
    ELSE
        Get Text    div.service-menu > button    *=    Mein Konto    message="Login failed!"
    END


Search And Select Article
    [Documentation]    Performans an article query and opens the first matching item.
    [Arguments]    ${article_id}    ${article_title}    ${article_price}  
    Fill Text    input#searchParam    ${article_id}   
    Click    form.search button  
    Get Text    div.list-container div.row:first-child div.productData:first-child    *=    ${article_title}   message=Article ${article_id} cannot be found!
    Click    div.list-container div.row:first-child div.productData:first-child div.actions a
    Get Text    div.detailsInfo    *=    ${article_title}  message=Article ${article_id} cannot be found!
    Click    button#toBasket
    Click    a[title='Warenkorb zeigen']
    Get Text    td#basketGrandTotal    ==    ${article_price}  message=Price for article ${article_id} is {value} (expected:{expected})!

Empty Basket
    [Documentation]    Removes all items from the basket.   
    Click    text="Warenkorb" 
    ${basket_is_empty}=    Get Element States    div#empty-basket-warning    then  bool(value & visible)
    IF  not ${basket_is_empty}
        Click    button#basketRemoveAll
        Click    button#basketRemove
        Get Element States    div#empty-basket-warning    *=    visible    message=Basket could not be cleared!
    END
    Go To    ${URL}


Open Webshop  
    [Documentation]    Opens the web shop's landing page
    New Browser    browser=${BROWSER}    headless=False
    New Context    viewport=${None}    locale=de-DE
    New Page    ${URL}    