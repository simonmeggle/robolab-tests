*** Comments ***

Positional arguments are the most common way to pass arguments to keywords. 
They are called positional because 
- the FIRST argument is mapped to the FIRST argument in the keyword definition. 
- the SECOND argument to the SECOND argument, and so on. 

Positional arguments are also called mandatory arguments because they must be given when the keyword is used.

***Test Cases***

Test with one argument
    One Argument    Hello World

Test with three arguments
    Three Arguments    Hello    CMK Users    How are you?

*** Keywords ***
One Argument
    [Arguments]    ${arg_name}
    Log To Console    Got argument ${arg_name}

Three Arguments
    [Arguments]    ${arg1}    ${arg2}    ${arg3}
    Log To Console    1st argument: ${arg1}
    Log To Console    2nd argument: ${arg2}
    Log To Console    3rd argument: ${arg3}