*** Settings ***
Documentation   Load Lunch List
Library         SeleniumLibrary
Library         OperatingSystem
Library         DateTime

*** Variables ***
${URL}          https://www.abcasemat.fi/asemat/abc-keljonkangas-jyvaskyla-613768399/noutopoyta-lounas/
${BROWSER}      firefox
${FILENAME}     lunchmenu.txt

*** Test Cases ***
Load Lunch List
    Open Browser1
    Search And Load Lunch List
    Close Browser

*** Keywords ***
Open Browser1
    ${firefox_options}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    sys, selenium.webdriver
    Call Method    ${firefox_options}    add_argument    --headless

    Open Browser    url=${URL}    browser=${BROWSER}    options=${firefox_options}    executable_path=/usr/local/bin/geckodriver


Search And Load Lunch List
    Click Link  css=a[class="sc-12399126-0 sc-2f27d2f1-0 knVNwv idhRwt"]
    Switch Window  NEW
    Sleep  4s
    Create File  ${FILENAME}  ${EMPTY}
    @{days_elements}=  Get WebElements  xpath://div[@data-testid="printable-daily-buffet-container"]
     ${current_day_number} =  Get Current Date  result_format=%w
    ${current_day_number} =  Evaluate  (${current_day_number} - 1) % 7
    @{days_list} =  Create List  MAANANTAINA  TIISTAINA  KESKIVIIKKONA  TORSTAINA  PERJANTAINA  LAUANTAINA  SUNNUNTAINA
    ${current_day_name} =  Set Variable  ${days_list[int(${current_day_number})]}

    FOR  ${day_element}  IN  @{days_elements}
        ${date_element}=  Call Method  ${day_element}  find_element  xpath  .//span[contains(@class, 'cdwHgX')]
        ${date_text}=  Get Text  ${date_element}
        ${day_name}=  Extract Day From Text  ${date_text}

        IF  "${day_name}" == "${current_day_name}"
            Log  Processing day: ${date_text}
            Append To File  ${FILENAME}  ${date_text}\n\n
        
            @{food_elements}=  Call Method  ${day_element}  find_elements  xpath  .//ul/li
            FOR  ${food_element}  IN  @{food_elements}
                ${food_text}=  Get Text  ${food_element}
                Append To File  ${FILENAME}  ${food_text}\n
            END
            Append To File  ${FILENAME}  \n\n
            EXIT FOR LOOP
        END
    END

Close Browser1
    Close Browser

Extract Day From Text
    [Arguments]  ${text}
    ${day_name}=  Evaluate  "${text}".split(' ')[0]
    [Return]  ${day_name}
