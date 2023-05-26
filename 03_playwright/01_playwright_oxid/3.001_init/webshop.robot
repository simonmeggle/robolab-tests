*** Comments ***
-> Have an idea in mind of what you want to test. Create the suite skeleton with placeholders for the tests.

Key Learnings: 
- Comments
- HERE, ACTION
- Basic skeleton for tests

Welcome to this Robot Framework tutorial! Our goal is to write a
web test suite for out ecommerce shop system. This Docstring should briefly outline what 
the suite is about and what the tests are doing. 
This "comments" section allows to put arbitrary text into the suite file. 

<--HERE-- arrows point to the most important changes within this code checkpoint.  
!!ACTION: What you can do here to play around. 

!!ACTION: Execute the suite and both test cases 

*** Settings ***
Documentation   Oxid eshop test for login and item search.   <--HERE--  Brief explanation what this suite does. 


*** Test Cases ***
Login with valid credentials
    [Documentation]    A user with valid credentials must be able to login.  <--HERE-- Brief explanation what this test does. 
    No Operation  #  <--HERE--   "No Operation" can be used as a placeholder, it does nothing. (like "pass" in Python)

Login with invalid credentials
    [Documentation]    A user with valid credentials must be able to login.  <--HERE-- Brief explanation what this test does. 
    No Operation

Search Item And Add To Basket
    [Documentation]    Searches an article, adds it to the basket and tries to navigate to the checkout page. <--HERE-- Brief explanation what this test does. 
    No Operation