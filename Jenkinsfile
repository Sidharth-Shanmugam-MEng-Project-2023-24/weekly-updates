def masterHeading = """
\\documentclass[11pt]{update}
\\usepackage{hyperref}
\\title{Project Updates: Master Record}
\\author{Sidharth Shanmugam}
\\date{\\today}
\\begin{document}
\\maketitle	
\\pagebreak
\\tableofcontents
\\pagebreak
\\section*{Introduction}
\\addcontentsline{toc}{section}{Introduction}
This master record collates weekly project updates to produce a thorough insight into progress within a single document. Each section consists of a week's update. Within each section are the following subsections and descriptions:
\\input{introduction}
\\pagebreak
"""

def weekHeading(weekName) {
    return """
\\documentclass[11pt]{update}
\\usepackage{hyperref}
\\title{Project Updates: $weekName}
\\author{Sidharth Shanmugam}
\\date{\\today}
\\begin{document}
\\maketitle	
\\pagebreak
\\section*{Introduction}
\\addcontentsline{toc}{section}{Introduction}
\\input{introduction}
\\pagebreak
"""
}

def weekContent(weekName, weekDir) {
    return """
\\section{$weekName}
\\subsection{Supervision Meetings}
\\input{../$weekDir/01_supervision_meetings}
\\pagebreak
\\subsection{Actionable Items Recap}
\\input{../$weekDir/02_actionables_recap}
\\pagebreak
\\subsection{Additional Project Updates}
\\input{../$weekDir/03_additional_updates}
\\pagebreak
\\subsection{Next Week's Agenda}
\\input{../$weekDir/04_nextweek_agenda}
\\pagebreak
\\subsection{Comments \\& Concerns}
\\input{../$weekDir/05_comments_concerns}
\\pagebreak
"""
}

def weekDirs

void setBuildStatus(String message, String state) {
  step([
      $class: "GitHubCommitStatusSetter",
      reposSource: [$class: "ManuallyEnteredRepositorySource", url: "https://github.com/Sidharth-Shanmugam-MEng-Project-2023-24/weekly-updates"],
      contextSource: [$class: "ManuallyEnteredCommitContextSource", context: "ci/jenkins/build-status"],
      errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
      statusResultSource: [ $class: "ConditionalStatusResultSource", results: [[$class: "AnyBuildResult", message: message, state: state]] ]
  ]);
}

pipeline {
    agent any
    options {
        skipDefaultCheckout()
    }
    stages {
        stage('Clean & Checkout') {
            steps {
                cleanWs()
                checkout scm
                script {
                    weekDirs = sh(script: 'ls -d [0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]', returnStdout: true).trim().split('\n')
                }
            }
        }
        stage('Generate LaTeX') {
            parallel {
                stage('Master Document') {
                    steps {
                        script {
                            def templatePath = 'templates/master_update.tex'
                            // Read the template content
                            // def templateContent = readFile(templatePath)
                            def finalContent = masterHeading
                            // Iterate through week directories and update the content
                            for (weekDir in weekDirs) {
                                def weekName = weekDir.substring(0, 10) // Extract the date part from the directory name
                                // Append section content to the final content
                                finalContent += weekContent(weekName, weekDir)
                            }
                            finalContent += "\n\\end{document}"
                            // Write the final content back to the master document
                            writeFile(file: templatePath, text: finalContent)
                        }
                    }
                }
                stage('Weekly Documents') {
                    steps {
                        script {
                            for (weekDir in weekDirs) {
                                def weekName = weekDir.substring(0, 10) // Extract the date part from the directory name
                                def templatePath = "templates/${weekName}_update.tex"
                                def finalContent = weekHeading(weekName) + weekContent(weekName, weekDir) + "\n\\end{document}"
                                writeFile(file: templatePath, text: finalContent)
                            }
                        }
                    }
                }
            }
        }
        stage('Compile LaTeX') {
            steps {
                script {
                    def latexFiles = findFiles(glob: 'templates/*.tex')
                    for (file in latexFiles) {
                        def relativeFilePath = file.toString().substring('templates/'.length()) // Remove 'templates/' part
                        // compile latex twice since the toc file generates in the first run, and then used in the second to render the table of contents.
                        sh "cd templates && /Library/TeX/texbin/pdflatex -interaction=nonstopmode $relativeFilePath && /Library/TeX/texbin/pdflatex -interaction=nonstopmode $relativeFilePath || true" // Compile LaTeX to PDF
                    }
                }
            }
        }
        stage('Upload Files') {
            steps {
                script {
                    def commitName = new Date().format('dd-MM-yyyy') // Get the current date in DD-MM-YYYY format
                    // Clone main branch
                    sh "git clone https://github.com/Sidharth-Shanmugam-MEng-Project-2023-24/weekly-updates && cd weekly-updates && git checkout main"
                    // Copy PDF files to the main branch
                    sh 'find templates/ -name "*.pdf" -exec cp {} weekly-updates/ \\;'
                    // Commit and push new files
                    sh "cd weekly-updates && git add -A && git commit -m '${commitName}' && git push"
                }
            }
        }
    }
    post {
        success {
            archiveArtifacts artifacts: 'templates/*.pdf', fingerprint: true
            setBuildStatus("Build succeeded", "SUCCESS");
        }
        failure {
            setBuildStatus("Build failed", "FAILURE");
        }
    }
}
