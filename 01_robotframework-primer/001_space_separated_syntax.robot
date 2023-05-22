*** Comments ***
The minimum requirements of a robot suite are: 
1 Test with 1 Keyword

Robot Frmework understands 3 different formats: 
- pipe separated
- reStructured
- Space separated (this one, recommended): between tokens there must be
    - 2+ spaces 
    OR 
    - 2+ tabs

COMMENTS can be written in the ***comments*** section (here) or in lines beginning with a #.

*** Test Cases ***


Hello World
# Log To Console    This is wrong (1 space)
  Log To Console    Hello World, this works.
  # Spaces within tokens must be escaped or replaced by special var
  Log To Console    Hello World, this also works. \ Wow!  no_newline=True
  Log To Console    Hello World, this also works. ${SPACE}Wow!  no_newline=True
  Log To Console    Hello World, this also works. \ \ \ Wow!  no_newline=True
    #Log To Console Wrong because RF sees this as a long keyword name  (no 2 spaces between kw and arg)

  Log To Console  Long lines can be splitted with three dots
  ...  no_newline=${False}