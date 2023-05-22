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
Library     Collections
Variables   varfile.py
# FIXME
Variables   varfile.yml

*** Variables ***
# Variables set here have suite scope (equal to the ones loaded from file)
# Scalar vars: 
${VAR_ONE}=         Hello World!
${VAR_TWO}          Robots 4ever!
${WELCOME}          welcome to Robot!
${COUNTER}          4  # ops, stored as string!
${COUNTER}          ${4}  # stored as int




# List variables: watch the two spaces between list elements
@{SALUTATIONS}      Hello    Guten Abend    Guten Morgen

# Dict vars:
&{CARS}             ford=mustang    ferrari=f40    vw=beetle
# (also possible)
&{CARS}             
...    ford=Mustang    
...    ferrari=F40    
...    vw=Beetle

# Nested dict: 
&{mydict}  eins=1111  zwei=2222  drei=3333
&{outerdict}  a=&{mydict}  b=BBB  c=CCC

*** Test Cases ***
Scalar Var Examples
    Set Suite Variable    ${SALUTATION}    Guten Abend
    Set Test Variable    ${SALUTATION}    Guten Abend
    Log    ${SALUTATION}

List Var Example
    # When accessing values of list vars, use $ instead of @
    Log    ${SALUTATIONS}[1], ${WELCOME}
    Set List Value    ${SALUTATIONS}    1    Griaßdi
    Log    ${SALUTATIONS}[1], ${WELCOME}

Dict Var Example 
    # When accessing values of dict vars, use $ instead of &
    # Dict values can be accessed with brackets: 
    Log  Today I want to drive a Ford ${CARS}[ford]
    # ...or with attribute-like way: 
    Log  Wo wants to drive a Ferrari ${CARS.ferrari}?

    # nested dicts
    Log to console  ${outerdict.a.eins}
	Log to console  ${outerdict}[a][eins]

Env Var Example
    Log  Hello, I am %{USER} and I am living in ${CITY=berlin}

Path Vars Example 
    # The following variables are Robot-Internal and can be used as desired: 
    Log  The path of this robot file is ${CURDIR}
    Log  The execution dir is ${EXECDIR}
    Log  The temp dir is ${TEMPDIR}


YAML Vars Example
    Log  ${yml_var}

Python Vars Example 
    No Operation  # FIXME