Param(
    [Parameter(HelpMessage = "Project folder", Mandatory = $false)]
    [string] $project = "."
)

try {
    . (Join-Path -Path $PSScriptRoot -ChildPath "..\AL-Go-Helper.ps1" -Resolve)

    $settings = ReadSettings -project $project -baseFolder $ENV:GITHUB_WORKSPACE -workflowName "CI/CD"
    if ([bool]$settings['keepContainer']) {
        Write-Host "keepContainer is set - leaving container $containerName in place for reuse"
        return
    }

    DownloadAndImportBcContainerHelper

    if ($project -eq ".") { $project = "" }

    $containerName = GetContainerName($project)
    Remove-Bccontainer $containerName
}
catch {
    Write-Host "Pipeline Cleanup failed: $($_.Exception.Message)"
}
