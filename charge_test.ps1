param(
    [int]$Duration = 60,
    [int]$RequestsPerSec = 10
)

$url = "http://localhost/api/orders"
$headers = @{"Content-Type" = "application/json"}
$body = '{"userId":1,"productDescription":"Test","quantity":5,"totalPrice":100.00}'
$interval = 1000 / $RequestsPerSec
$count = 0

$startTime = [datetime]::Now
$endTime = $startTime.AddSeconds($Duration)

while ([datetime]::Now -lt $endTime) {
    try {
        Invoke-WebRequest -Uri $url -Method POST -Headers $headers -Body $body -ErrorAction SilentlyContinue | Out-Null
    } catch {
    }
    
    $count++
    Write-Host "[$count] Requête envoyée"
    
    Start-Sleep -Milliseconds $interval
}

Write-Host "Test terminé. Total requêtes: $count"