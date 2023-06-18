*** Comments ***

Sometimes it is useful to have default values for arguments. 
This can be done by giving the default value after the argument name. 

*** Variables ***
${VARIABLE}    foo

***Test Cases***

Test With One Argument With Default Value
    One Argument With Default Value

Test With Two Arguments With Defaults
    Two Arguments With Defaults
    # just overriding one of the defaults by using named arguments
    Two Arguments With Defaults    arg2=bar

Test With One Required And One With Default
    One Required And One With Default    required

Test With Default Based On Earlier Argument
    Default Based On Earlier Argument    ${True}

*** Keywords ***
One Argument With Default Value
    [Arguments]    ${arg}=default value
    [Documentation]    This keyword takes 0-1 arguments
    Log To Console    Got argument ${arg}

Two Arguments With Defaults
    [Arguments]    ${arg1}=default 1    ${arg2}=${VARIABLE}
    [Documentation]    This keyword takes 0-2 arguments; second argument defaults to a variable
    Log To Console    1st argument ${arg1}
    Log To Console    2nd argument ${arg2}

One Required And One With Default
    [Arguments]    ${required}    ${optional}=default
    [Documentation]    This keyword takes 1-2 arguments
    Log To Console    Required: ${required}
    Log To Console    Optional: ${optional}

 Default Based On Earlier Argument
    [Arguments]    ${a}    ${b}=${a}    ${c}=${a} and ${b}
    Should Be Equal    ${a}    ${b}
    Should Be Equal    ${c}    ${a} and ${b}