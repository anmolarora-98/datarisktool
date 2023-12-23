# Load necessary libraries
library(rsconnect)

# Install necessary packages if not already installed
if (!requireNamespace("shinymaterial", quietly = TRUE)) {
  install.packages("shinymaterial")
}

if (!requireNamespace("shinyjs", quietly = TRUE)) {
  install.packages("shinyjs")
}

if (!requireNamespace("shinydashboard", quietly = TRUE)) {
  install.packages("shinydashboard")
}
# Load required libraries
library(shiny)
library(shinymaterial)
library(shinyjs)
library(shinydashboard)

# Define UI
ui <- dashboardPage(
  skin = 'yellow',
  
  dashboardHeader(title = "Data Risk Assessment Questionnaire", titleWidth = 350),
  
  dashboardSidebar(
    width = 350,
      h4("About this tool:"),
      p("In accordance with NHS guidance and GDPR legislation, all organisations in the United Kingdom handling sensitive data have a duty to assess and minimise associated risks. CUH handles large volumes of patient data and receives hundreds of requests per year to use this data for research projects. This data risk tool aims to quantify the data risks associated with each project and is informed by guidance from: GDPR, ICO, GMC, DCMS, Five Safes, HIPAA and the NHS. The purpose of this data risk tool is to identify risks associated with each project and ensure that data is only shared where efforts have been made to minimise risks."),
      h4("Examples of risks include:"),
      HTML("&bull; Through inadequate de-identification or lack of safeguarding, legitimate actors may be able to identify specific patients."),br(),
      HTML("&bull; Through inadequate security, malicious actors may be able to access the data, causing threats to patient confidentiality and reputational damage."),br(),
      HTML("&bull; Through inadequate security, the accuracy of the data may be compromised, and the results of the study may be harmed."),br(),
      HTML("&bull; Through inadequate security, compromised data may lead to medical identity theft."),br(),
      
      h4("What is covered by this tool?"),
      HTML("&bull; All studies that use routinely collected patient data from CUH, including secondary uses of study data, that do not have specific research consent or a Section 251 consent waiver (which allows the common law duty of confidentiality to be temporarily lifted)."),br(),
      
      h4("What is exempt from this tool?"),
      HTML("&bull; Projects using data from public data repositories (e.g., Kaggle, Google Datasets);"),br(),
      HTML("&bull; Projects where data is sourced from other health organizations; and"),br(),
      HTML("&bull; Projects using entirely synthetic data that does not correspond with real patients, although the creation of synthetic data would require approval first."),br(),
      br(),
      p("The data risk tool encompasses several domains of data usage in order to calculate an overall risk score (baseline score = 50). The risk tool is designed to capture information about the likelihood, severity and reputational hazard of different risks. Most elements of the risk score are modifiable and each section is accompanied by advice on how to reduce risk scores. The baseline for each project risk score is set based on the type of data that is being requested. High risk data requests can have scores reduced if safeguards are in place to minimise risks. Similarly, the score of projects requesting low-risk data can be increased if the processing and storage of the data is outside the control of CUH, as this increases security and reputational risks. All projects are subject to panel review, which includes patient and public representation. Projects with high risk scores will not be considered by the panel until safeguards are suggested to reduce the score."),
      p("The risk tool will take approximately 15 minutes to complete. It is expected that a completed version of the risk tool will be accompanied by the full project proposal which includes supporting documents to allow further contextualised scrutiny of the statements in the review. The data that you input is not saved on any server or automatically sent to us and will be lost if you refresh the page. The only way to submit your score is by saving a completed copy of the form and emailing it to us. When you have completed the tool, please click print and save a copy as a pdf to submit to the review committee.")
  ),
    
  dashboardBody(
    useShinyjs(),  # Initialize shinyjs
      style="margin-left: 10px;margin-right: 10px",
      fluidRow(
        column(12,
               textAreaInput("q1a", "Q1a: Title of project", width = "50%"),
               textAreaInput("q1b", "Q1b: Lead applicant", width = "50%"),
               textAreaInput("q1c", "Q1c: Named co-applicants", width = "40%"),
               textAreaInput("q1d", "Q1d: Please list any reference numbers, with dates, for existing project approvals, e.g. Research & Development, Integrated Research Application System (IRAS) or Research Ethics Committee. If none, please write N/A.", width = "50%"),
               textAreaInput("q1e", "Q1e: Plain English summary (max 300 words)", width = "50%"),
               textAreaInput("q1f", "Q1f: Scientific abstract (max 300 words)", width = "50%"),
               textAreaInput("q1g", "Q1g: Conflicts of interest statement (including financial disclosures). Please include conflicts relevant to all co-applicants", width = "50%"),
               checkboxGroupInput("q1h", "Q1h: Which of the following best describes your study",
                                  choices = c("Population study with descriptive statistics only",
                                              "Patient cohort study with descriptive statistics only",
                                              "Data collection for development of a new algorithm",
                                              "Data collection to assess or cross-validate an existing algorithm",
                                              "Other, please detail:"), width = "50%"),
               textAreaInput("q1h-other", "Q1h-other: If other, please detail:", width = "50%"),
               textAreaInput("q1i", "Q1i: Please list the specific data that is being requested with a brief explanation of why is is required for the project", width = "50%"),
               textAreaInput("q1j", "Q1j: Does the project have Health Research Authority (HRA) approval?", width = "50%"),
               textAreaInput("q1k", "Q1k: Name of person completing form", width = "50%"),
               em(style = "color: blue;", "About Question 1: The information provided in this section does not contribute to the data risk score. It is only used to provide contextual information to the review panel when assessing the application. Many projects will have already obtained other ethics approvals which will be useful for the Research & Development department to consider when interpreting the results of this data risk score."),
               hr(),
               h4("Project Eligibility Check"),
               radioButtons("q2a", "Q2a: Do you require de-identified routinely collected patient data for your project?", choices = c("Yes", "No"), selected = character(0), inline = TRUE),
               conditionalPanel(
                 condition = "input.q2a == 'Yes'",
                 HTML('<p style="color:green;">Please continue to the next question.</p>')),
               conditionalPanel(
                 condition = "input.q2a == 'No'",
                 HTML('<p style="color:red;">This project is not eligible for this tool.</p>')),
               radioButtons("q2b", "Q2b: The project has ethical approval and patients consent to researchers accessing their routinely collected data", choices = c("Yes", "No"), selected = character(0), inline = TRUE),
               conditionalPanel(
                 condition = "input.q2b == 'Yes'",
                 HTML('<p style="color:red;">This project is not eligible for this tool. Please speak to R&D.</p>')),
               conditionalPanel(
                 condition = "input.q2b == 'No'",
                 HTML('<p style="color:green;">Please continue to the next question.</p>')),
               radioButtons("q2c", "Q2c: The project has a favourable opinion from an NHS REC and a section 251 consent waiver approval from the Confidentiality Advisory Group", choices = c("Yes", "No"), selected = character(0), inline = TRUE),
               conditionalPanel(
                 condition = "input.q2c == 'Yes'",
                 HTML('<p style="color:red;">This project is not eligible for this tool. Please speak to R&D.</p>')),
               conditionalPanel(
                 condition = "input.q2c == 'No'",
                 HTML('<p style="color:green;">Please continue to the next question.</p>')),
               radioButtons("q2d", "Q2d: The project involves  members of the direct clinical care team who will access identifiable information in order to de-identify the data for analysis", choices = c("Yes", "No"), selected = character(0), inline = TRUE),
               conditionalPanel(
                 condition = "input.q2d == 'Yes'",
                 HTML('<p style="color:green;">Please continue with the tool and answer the questions with reference to the de-identified data set.</p>')),
               conditionalPanel(
                 condition = "input.q2d == 'No'",
                 HTML('<p style="color:green;">Please continue to the next question.</p>')),
               radioButtons("q2e", "Q2e: The project involves researchers who have (or will have) a research passport and EPIC access, but who are not members of the direct care team accessing identifiable information in order to de-identify data for analysis", choices = c("Yes", "No"), selected = character(0), inline = TRUE),
               conditionalPanel(
                 condition = "input.q2e == 'Yes'",
                 HTML('<p style="color:red;">This is not permissible and is a breach of confidentiality law. Please speak to R&D to find a solution.</p>')),
               conditionalPanel(
                 condition = "input.q2e == 'No'",
                 HTML('<p style="color:green;">Please continue to the next question.</p>')),
               em(style = "color: blue;", "About Question 2: It is usually permissible to use de-identified data for research which is deemed ethical. However, it is essential that the de-identification of the data is performed by a member of the direct clinical care team in order to prevent unnecessary exposure of personally identifiable information to other researchers or third-parties."),
               hr(),
               checkboxGroupInput("q3", "Q3: Does your project involve any of the following types of data? Please select all that apply",
                                  choices = c("Biometric or genetic data" = 1.25,
                                              "Linkage with data from outside CUH" = 1.25,
                                              "DICOM or other imaging data which includes metadata e.g. CT/MRI scans, echocardiograms or cardiac MRIs with contextual clinical information or metadata" = 1.25,
                                              "Rare or unusual diagnosis either in general population or CUH patients (criteria: UK general population prevalence <1 in 100,000 or <10 new diagnoses at CUH per year)" = 1.1,
                                              "Rare or unusual medications or procedures at CUH (<10 at CUH per year)" = 1.1,
                                              "Outliers in the data set – age, weight, height, length of stay etc" = 1.2,
                                              "Specific times and dates, including date of death" = 1.3,
                                              "Photographs of the face or other identifying feature" = 1.4,
                                              "Free-text fields" = 1.2))),
        em(style = "color: blue;", "About Question 3: Certain types of data are associated with higher risk of re-identification of patients. For example, pseudonymised data is being crosslinked with data from another dataset, the re-identification risk may increase. Furthermore, risks may compound each other. For example, if data includes personal identifiers and this is then cross-linked with another dataset, then the amount of personally identifiable data at risk per patient increases. Free-text fields may have a higher identification risk and hence they do increase the risk score."),
        hr(),
        checkboxGroupInput("q4", "Q4: Does your project involve any of the following types of data? Please select all that apply",
                           choices = c("Data relating to any of: race, ethnic origin, politics, religion, trade union membership, sex life, sexual orientation, domestic violence history, forensic history" = 1.25,
                                       "Particularly sensitive medical data such as HIV status or IVF treatment" = 1.25,
                                       "Data relating to children (under 18 years)" = 1.2,
                                       "Data relating to vulnerable adults, for example patients living in care homes or other institutions, or with learning difficulties or mental illness" = 1.2)),
        textAreaInput("q4a", "Q4a: Where any of the options in question 4 have been selected, please justify inclusion of this data", width = "50%"),
        em(style = "color: blue;", "About Question 4: Certain types of data are associated with an increased risk of harm if patients become identifiable or if the data is leaked."),
        hr(),
        checkboxGroupInput("q5", "Q5: How and where will data be used? Please select all that apply",
                           choices = c("Internal study within CUH only" = 0.9,
                                       "Study involving transfer to University of Cambridge" = 1.0,
                                       "Study with an academic partner organization in the UK" = 1.05,
                                       "Study with public or third sector organization in the UK" = 1.1,
                                       "Study with tech start-up" = 1.4,
                                       "Study with established pharmaceutical company" = 1.1,
                                       "Study with established technology company" = 1.1,
                                       "Stored entirely within a trusted research environment" = 0.9,
                                       "Other commerical organisation (will be reviewed separately)" = 1.0), width="50%"),
        em(style = "color: blue;", "About Question 5: All relevant options should be selected. If data is stored entirely within a trusted research environment but shared with other partners, then options relating to the sharing with partners should still be included."),
        hr(),
        checkboxGroupInput("q5a", "Q5a: (If Applicable) For external organisations where is the institution based",
                           choices = c("In the UK" = 1.0,
                                       "Outside the UK but in the EEA" = 1.05,
                                       "Outside the EEA but in a country recognized with GDPR adequacy decision" = 1.05,
                                       "Outside the EEA but in a country recognised with a GDPR partial adequacy decision (e.g. USA, Australia, Japan, Canada)" = 1.1,
                                       "Outside the EEA and in a country without GDPR adequacy decision" = 10), width="50%"),
        em(style = "color: blue;", "About Question 5a: Data leaks are made more likely by the exchange of information between different institutions. Minimising data transfer outside the host institution is one method of safeguarding data security. It is well documented that patients are generally favourable towards their data being shared with NHS institutions and for academic purposes compared with commercial organisations. This does not disqualify such projects from approval, but further precautions may be needed. Similarly, sharing data outside of the country is risky but these risks are somewhat mitigated where the countries have General Data Protection Regulation (GDPR) adequacy decisions."),
        hr(),
        textAreaInput("q5b_partner", "Q5b: Please name any organisations identified in Q5", width = "50%"),
        hr(),
        checkboxGroupInput("q6", "Q6: Who will have access to the de-identified data?",
                           choices = c("Data will only be accessed by members of the clinical care team at CUH, other CUH staff with a substantive contract or with a non-research contract" = 0.9,
                                       "Data will only be accessed by academic researchers (usually UCAM or PPIE) with an honorary research contract or letter of access for CUH" = 0.95,
                                       "In addition to or instead of the above options, data will be accessed by staff from another NHS partner organisation" = 1.05,
                                       "In addition to or instead of the above options, data will also be accessed by staff from another academic partner organisation or PPIE members who do not fit into any other category" = 1.05,
                                       "In addition to or instead of the above options, data will also be accessed by staff from a commercial partner organisation" = 1.1), width="50%"),
        em(style = "color: blue;", "About Question 6: Please select as many options as are true. For example, if data will be accessed by clinical CUH staff, an NHS partner organisation, another academic partner organisation and a commercial partner organisation then options 3, 4 and 5 should all be selected. PPIE members may not require direct access to the data but if this is being arranged then the access details should be reflected in answering this question."),
        hr(),
        checkboxGroupInput("q7", "Q7: What are the security arrangements for data storage? Please select all that apply",
                           choices = c("Within the CUH IT environment, including BYOD" = 0.95,
                                       "Within an area of the University of Cambridge covered by an NHS toolkit" = 1.0,
                                       "Within an area of the University of Cambridge not covered by an NHS toolkit" = 1.05,
                                       "Organisational secure electronic devices (laptops, tablets, smart phones)" = 1.0,
                                       "Personal electronic devices (laptops, tablets, smart phones)" = 10,
                                       "Encrypted mobile media (thumb drives, mobile hard drives, magnetic media)" = 1.0,
                                       "Encrypted cloud storage not covered above but ISO270001 compliant" = 1.0,
                                       "Paper records/hard copies subject to the trust policy on sensitive documents" = 1.0,
                                       "Other (detail):" = 1.0), width="50%"),
        textAreaInput("q7_other", "Q7 Other: Specify (if applicable):", width = "50%"),
        em(style = "color: blue;", "About Question 7: Most projects will involve more than one site of data storage. Different projects may involve different sites of data storage. In some cases, there may be more than one site. Depending on these sites, further protective measures e.g. encryption may be required. Please select all sites involved in the project. Where other is selected, this will not be scored by the risk tool but will be assessed during the review process."),
        hr(),
        checkboxGroupInput("q8", "Q8: How will the data be transferred between devices?",
                           choices = c("Not applicable" = 0.8,
                                       "Secure File Transfer Protocol" = 0.95,
                                       "Encrypted cloud storage (ISO270001 compliant)" = 1.0,
                                       "Secure email server (e.g. CUH email, NHS.net)" = 1.0,
                                       "Standard email" = 10,
                                       "Encrypted mobile media (thumb drives, mobile hard drives, magnetic media)" = 1.05,
                                       "Standard mobile media" = 10)),
        em(style = "color: blue;", "About Question 8: Modes of transfer of data are common targets for data leakage, including through cybercrime. This can include physical communication of data using mobile media or electronic communication using e-mail. Wherever possible, data should be transmitted using end to end encryption. If encrypted mobile media was selected for Q7, it should be selected for Q8 also."),
        hr(),
        checkboxGroupInput("q9", "Q9: Public and patient involvement and engagement",
                           choices = c("Patients and public have been involved in the design of this study, including membership on the research team or close involvement in the formulation of the study" = 0.8,
                                       "Patients and public have been consulted on the study but not directly involved in its design" = 0.9,
                                       "There is a protocol for the study in the public domain, e.g. as a published article or on a public repository" = 0.95,
                                       "Information on the study will be made available to the public in plain English e.g. on a website with an avenue for members of the public to contact the team if needed for further information" = 0.95), width="50%"),
        em(style = "color: blue;", style = "color: blue;", "About Question 9: Patient and public involvement is an important element of research and is highly encouraged for all studies."),
        hr(),
        checkboxGroupInput("q10", "Q10: Other approvals",
                           choices = c("This study has received NHS ethics approval" = 0.85,
                                       "This study has a data sharing agreement in place" = 0.95,
                                       "This study has received University REC approval" = 0.85,
                                       "This study has received specific research funding after review by a funding body" = 0.9,
                                       "CUH maintains control of the data retention period" = 0.95,
                                       "CUH maintains control of data access" = 0.95), width="50%"),
        em(style = "color: blue;", "About Question 10: This question seeks to identify elements of the study design, not captured elsewhere, that can reduce or increase the data risk. Previous review of the study design and involvement of PPI can improve the acceptability of the project. Under normal circumstances a data sharing agreement would be covered under one of the other approvals, but if it has been completed separately then this option should be selected."),
        hr(),
        textAreaInput("q11a", "Q11a: Please describe the extent to which patients and the public have been involved in designing this study (max 250 words)", width = "50%"),
        textAreaInput("q11b", "Q11b: Please provide details of the ethics review for this project (max 250 words)", width = "50%"),
        textAreaInput("q11c", "Q11c: Please provide details of the funding that has been provided for this project (max 250 words)", width = "50%"),
        textAreaInput("q11d", "Q11d: If applicable, please attach the data protection impact assessment that has been completed specifically for this study (optional) (max 250 words)", width = "50%"),
        em(style = "color: blue;", "About Question 11: Qualitative answers are sought for Q11a-d. Although these do not affect the numerical score, the information is essential for review of the project and allows contextualised interpretation of the overall score. We would therefore encourage as much detail as possible. Data protection impact assessments do not influence the risk score. If a project is identified as medium or high risk, a DPIA may be requested."),
        hr(),
        h1("Cumulative Score", style = "text-align: center; color: red; font-weight: bold"),
        h1(textOutput("score"), style = "text-align: center; color: red; font-weight: bold; text-decoration: underline;"),
        hr(),
        actionButton("printPageButton", "Print Page", style = "width: 200px; height: 100px; margin: auto; display: block;"),
        hr(),
        br()
      )
    )
  )


# Define server logic
server <- function(input, output, session) {
  output$score <- renderText({
    # Calculate cumulative score based on user inputs
    cumulative_score <- 50 *
      prod(as.numeric(input$q3)) *
      prod(as.numeric(input$q4)) *
      prod(as.numeric(input$q5)) *
      prod(as.numeric(input$q5a)) *
      prod(as.numeric(input$q6)) *
      prod(as.numeric(input$q7)) *
      prod(as.numeric(input$q8)) *
      prod(as.numeric(input$q9)) *
      prod(as.numeric(input$q10))
    
    cumulative_score
  })
  
  # Define a custom JavaScript function using shinyjs
  shinyjs::runjs(
    "
    // Adjust the height of textAreaInput dynamically based on content
    function autoResizeTextarea() {
      $('textarea').each(function() {
        this.style.height = 'auto';
        this.style.height = (this.scrollHeight) + 'px';
      });
    }

    // Call the autoResizeTextarea function on input change
    $('textarea').on('input', function() {
      autoResizeTextarea();
    });

    shinyjs.printPage = function() {
      window.print();
    }
    "
  )
  
  # Observer to trigger the JavaScript function when the button is clicked
  observeEvent(input$printPageButton, {
    shinyjs::runjs("shinyjs.printPage();")
  })
}

# Run the application
shinyApp(ui, server)
