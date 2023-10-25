def masterHeading = """
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

def weekHeading(weekName) {
    return """
\\documentclass[11pt]{update}
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
                                finalContent += "\\begin{leveldown}" + weekContent(weekName, weekDir) + "\\end{leveldown}"
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
                        sh "cd templates && /Library/TeX/texbin/pdflatex -interaction=nonstopmode $relativeFilePath || true" // Compile LaTeX to PDF
                    }
                }
            }
        }
        // stage('Create GitHub Release') {
        //     steps {
        //         script {
        //             def githubRelease = githubRelease(
        //                 apiUri: 'https://api.github.com', // GitHub API endpoint
        //                 credentialsId: 'YOUR_GITHUB_CREDENTIALS_ID', // Use your GitHub credentials ID
        //                 tag: 'v1.0', // Tag for the release
        //                 releaseNotes: 'Release Notes',
        //                 target: 'master',
        //                 prerelease: false,
        //                 title: 'Release Title',
        //                 description: 'Release Description'
        //             )

        //             def pdfFiles = findFiles(glob: 'artifacts/*.pdf')

        //             for (pdfFile in pdfFiles) {
        //                 archiveArtifacts artifacts: pdfFile, allowEmptyArchive: true
        //                 githubReleaseUpload(
        //                     server: githubRelease.server,
        //                     releaseId: githubRelease.releaseId,
        //                     asset: pdfFile,
        //                     assetFilename: pdfFile.name
        //                 )
        //             }
        //         }
        //     }
        // }
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
