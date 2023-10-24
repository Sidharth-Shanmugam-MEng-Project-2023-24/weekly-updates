pipeline {
    agent any
    stages {
        stage('Update Master Document') {
            steps {
                script {
                    def templatePath = 'templates/master_updates.tex'
                    def weekDirs = sh(script: 'ls -d [0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]', returnStatus: true).trim().split('\n')

                    // Read the template content
                    def templateContent = readFile(templatePath)

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

                    finalContent = finalContent.replaceAll("\\\\end\\{document\\}","")
                    finalContent += "\\\\end{document}"

                    // Write the final content back to the master document
                    writeFile(file: templatePath, text: finalContent)
                }
            }
        }
    }
}
