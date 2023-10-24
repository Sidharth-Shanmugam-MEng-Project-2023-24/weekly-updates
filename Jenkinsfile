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
            }
        }
        stage('Generate Master Document') {
            steps {
                script {
                    def templatePath = 'templates/master_update.tex'
                    def weekDirs = sh(script: 'ls -d [0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]', returnStdout: true).trim().split('\n')

                    // Read the template content
                    // def templateContent = readFile(templatePath)
                    def templateContent = """
\\documentclass[11pt]{update}
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
\\input{introduction}
\\pagebreak
"""

                    // Create a variable to hold the final content
                    def finalContent = templateContent

                    // Iterate through week directories and update the content
                    for (weekDir in weekDirs) {
                        def weekName = weekDir.substring(0, 10) // Extract the date part from the directory name

                        // Generate section content for the week
                        def sectionContent = """
\\section{$weekName}
\\subsection{Supervision Meetings}
\\input{../$weekDir/01_supervision_meetings}
\\subsection{Actionable Items Recap}
\\input{../$weekDir/02_actionables_recap}
\\subsection{Additional Project Updates}
\\input{../$weekDir/03_additional_updates}
\\subsection{Next Week's Agenda}
\\input{../$weekDir/04_nextweek_agenda}
\\subsection{Comments & Concerns}
\\input{../$weekDir/05_comments_concerns}
\\pagebreak
"""

                        // Append section content to the final content
                        finalContent += sectionContent
                    }

                    // finalContent = finalContent.replaceAll("\\\\end\\{document\\}","")
                    finalContent += "\n\\end{document}"

                    // Write the final content back to the master document
                    writeFile(file: templatePath, text: finalContent)
                }
            }
        }
    }
}
