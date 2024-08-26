$uris = @(
    "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv"
    "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrxrH"
)

$installers = @()
foreach ($uri in $uris) {
    $download = Invoke-WebRequest -Uri $uri -UseBasicParsing

$fileName = ($download.Headers.'Content-Disposition').Split('=')[1].Replace('"','')
    $output = [System.IO.FileStream]::new("$pwd\$fileName", [System.IO.FileMode]::Create)
    $output.write($download.Content, 0, $download.RawContentLength)
    $output.close()
    $installers += $output.Name
}

foreach ($installer in $installers) {
    Unblock-File -Path "$installer"
}

Start-Sleep -Seconds 30

# msiexec /i Microsoft.RDInfra.RDAgent.Installer-x64-1.0.8297.800.msi /quiet REGISTRATIONTOKEN=<RegistrationToken>
msiexec /i Microsoft.RDInfra.RDAgent.Installer-x64-1.0.8297.800.msi /quiet REGISTRATIONTOKEN="eyJhbGciOiJSUzI1NiIsImtpZCI6IkJFMEY2NzBBRDk2Mjc5MUE1NEI1MDQ3MTkyQjY3QTAyRjA1RTYyQzgiLCJ0eXAiOiJKV1QifQ.eyJSZWdpc3RyYXRpb25JZCI6IjllOGY1MmMwLTliOGItNDc0NS05ZTZjLTg3MWY2ZGRmZWU3YSIsIkJyb2tlclVyaSI6Imh0dHBzOi8vcmRicm9rZXItZy1ldS1yMC53dmQubWljcm9zb2Z0LmNvbS8iLCJEaWFnbm9zdGljc1VyaSI6Imh0dHBzOi8vcmRkaWFnbm9zdGljcy1nLWV1LXIwLnd2ZC5taWNyb3NvZnQuY29tLyIsIkVuZHBvaW50UG9vbElkIjoiODlmMGZlZDktN2NhMy00ZDExLWE3YzAtNDE1ZGZmN2NkOGRjIiwiR2xvYmFsQnJva2VyVXJpIjoiaHR0cHM6Ly9yZGJyb2tlci53dmQubWljcm9zb2Z0LmNvbS8iLCJHZW9ncmFwaHkiOiJFVSIsIkdsb2JhbEJyb2tlclJlc291cmNlSWRVcmkiOiJodHRwczovLzg5ZjBmZWQ5LTdjYTMtNGQxMS1hN2MwLTQxNWRmZjdjZDhkYy5yZGJyb2tlci53dmQubWljcm9zb2Z0LmNvbS8iLCJCcm9rZXJSZXNvdXJjZUlkVXJpIjoiaHR0cHM6Ly84OWYwZmVkOS03Y2EzLTRkMTEtYTdjMC00MTVkZmY3Y2Q4ZGMucmRicm9rZXItZy1ldS1yMC53dmQubWljcm9zb2Z0LmNvbS8iLCJEaWFnbm9zdGljc1Jlc291cmNlSWRVcmkiOiJodHRwczovLzg5ZjBmZWQ5LTdjYTMtNGQxMS1hN2MwLTQxNWRmZjdjZDhkYy5yZGRpYWdub3N0aWNzLWctZXUtcjAud3ZkLm1pY3Jvc29mdC5jb20vIiwiQUFEVGVuYW50SWQiOiJmNmI5YjFmYS0xMGRkLTRjNWItOGIxYi00MDQ5MzRiMTczMTMiLCJuYmYiOjE3MTIwNTgzMzksImV4cCI6MTcxNDQ4MDk5MywiaXNzIjoiUkRJbmZyYVRva2VuTWFuYWdlciIsImF1ZCI6IlJEbWkifQ.dVO4OxWzaLh9mVpBVsumzQzRyw5NMDmBfdkrQbophpLqLKQoCnOQAkRk0uEIvDexhG6zvLWiKxfFoJOVDZ7PaUEHMgZ_TGQExQp7CPMKo01LtW1HIiVx4wGouFSb39dw_GSnNchVWWb81EDSmfzPq9NWcT9kj4xafQtQOBqK05Bw4pS7R615iNqL0OyD9LGX6MMIYv-J7BhuhZ8Fg1FqD-gb3Yq7peD8YtPHVH1xUlw5REdXyjKUuW7xE6l6f7Ah2TjWBoOn98D2wTAhs-A-l4fmKLRDMtHHqfq2vZM6EA_I_GBq2nENeHNwahU5FfzN9UlGf132-f51M_yjbiJ9cw"

Start-Sleep -Seconds 30

msiexec /i Microsoft.RDInfra.RDAgentBootLoader.Installer-x64.msi /quiet
