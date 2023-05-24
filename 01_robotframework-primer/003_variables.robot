*** Comments ***
Variable names are always enclosed in {} and are prefixed by a special character to show the type:
- $ = scalar
- & = dict
- @ = list
- % = Environment

Variables can be overridden on the CLI:

    robot --variable VAR_ONE:Goodbye 003_variables.robot

Robot is not case-aware: the convention is to keep suite vars in UPPERcase,
all others in lowercase.


*** Settings ***
Library         Collections
Variables       varfile.py
Variables       varfile.yml


*** Variables ***
# Variables set here have suite scope (equal to the ones loaded from file)
# Scalar vars:
${VAR_ONE}=         Hello World!
${VAR_TWO}          Robots 4ever!

# Values are stored as string by default
${COUNTER}          4    # ops, stored as string!
${COUNTER}          ${4}    # stored as int

# List variables: watch the two spaces between list elements
@{SALUTATIONS}      Hello    Guten Abend    Guten Morgen

# Dict vars:
&{CARS}             ford=mustang    ferrari=f40    vw=beetle
# (also possible)
&{CARS}
...                 ford=Mustang
...                 ferrari=F40
...                 vw=Beetle

# Nested dict:
&{mydict}           eins=1    zwei=2    drei=3
&{outerdict}        a=&{mydict}    b=V    c=C

&{USER 2}       name=Teppo    address=yyy         phone=456
*** Test Cases ***
Scalar Var Examples
    Set Suite Variable    ${SALUTATIONDE}    Guten Abend
    Set Test Variable    ${SALUTATIONEN}    Good Morning
    Log To Console    ${SALUTATIONDE}
    Log To Console    ${SALUTATIONEN}

List Var Example
    # When accessing values of list vars, use $ instead of @
    Log To Console    ${SALUTATIONS}[1]
    Set List Value    ${SALUTATIONS}    1    Griaßdi
    Log To Console    ${SALUTATIONS}[1]

Dict Var Example
    # When accessing values of dict vars, use $ instead of &
    # Dict values can be accessed with brackets:
    Log To Console    Today I want to drive a Ford ${CARS}[ford]
    # ...or with attribute-like way:
    Log To Console    Wo wants to drive a Ferrari ${CARS.ferrari}?

    # nested dicts
    Log to console    ${outerdict.a.eins}
    Log to console    ${outerdict}[a][eins]

Env Var Example
    Log To Console    Hello, I am %{USER} and I am living in ${CITY=berlin}

Path Vars Example
    # The following variables are Robot-Internal and can be used as desired:
    Log To Console    The path of this robot file is ${CURDIR}
    Log To Console    The execution dir is ${EXECDIR}
    Log To Console    The temp dir is ${TEMPDIR}

YAML Vars Example
    [Documentation]    Example for using variables read from YAML file
    Log To Console    ${yml_var}
    Log To Console  ${yml_fruit_list}[1]
    FOR    ${index}    ${element}    IN ENUMERATE    @{yml_fruit_list}
        Log To Console    ${index}: ${element}
        
    END

    Log To Console  ${yml_name_dict}[age]
    Log To Console  ${yml_name_dict.age}  #alternative syntax

Python Vars Example
    [Documentation]    Example for using variables read from Python file
    Log To Console    ${py_var}
    Log To Console  ${py_fruit_list}[1]
    FOR    ${index}    ${element}    IN ENUMERATE    @{py_fruit_list}
        Log To Console    ${index}: ${element}
        
    END
    
    Log To Console  ${py_name_dict}[age]
    Log To Console  ${py_name_dict}[name]
