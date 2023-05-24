*** Comments ***
A Robot file is divided into different sections which are explained below.

!! ACTION: Use F12 to jump directly into the python code of the OperatingSystem library!


*** Settings ***
# The Documentation is the "business card" of a suite. Fill it wisely!
Documentation       Small example

# Importing test libraries
Library             OperatingSystem
# Importing keywords from another file
Resource            my_keywords.resource
# Importing variables from another file
Variables           varfile.py
# (and much more...)


*** Variables ***
${URL}      www.mywebshop.com


*** Test Cases ***
# Tests are singular action sequences (=keyword calls) which all must success to make the test PASS.

Test One
    [Documentation]  The Test documentation should explain what the test does
    My User Keyword

Test Two
    [Documentation]  The Test documentation should explain what the test does
    My User Keyword


*** Keywords ***
# This section allows to define custom keywords (can be nested)
My User Keyword
    [Documentation]  Also keywords can/should be documented
    No Operation

# -----------------
# Chamber of horrors
# Robot does accept many variations of section name.
# Read it & forget it!

#*** Settings ***
# With Spaces...

#***settings***
# ...or without...

#*** seTTings ***
# ...Upper/lowercase...

#*settings*
# ...or an arbitrary number...

#******* settings *******
# ...of stars
