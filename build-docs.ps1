$ErrorActionPreference = "Stop"
$p = "/SelwadLeague/"

$layoutPath = "SelwadLeague\Views\Shared\_Layout.cshtml"
$indexPath  = "SelwadLeague\Views\Home\Index.cshtml"

$layout = Get-Content $layoutPath -Raw -Encoding UTF8
$index  = Get-Content $indexPath  -Raw -Encoding UTF8

# شيل بلوك @{ ... } من أول Index (مثل ViewData)
$index = $index -replace '(?s)^\s*@\{.*?\}', ''

# دمج الـ Layout مع الـ Index
$html = $layout.Replace('@RenderBody()', $index)

# شيل أكواد Razor
$html = $html -replace '(?m)^.*@await RenderSectionAsync.*$', ''
$html = $html -replace '(?m)^.*SelwadLeague\.styles\.css.*$', ''
$html = $html -replace '@ViewData\["[^"]*"\]', ''
$html = $html.Replace(' asp-append-version="true"', '')

# عدّل المسارات لتناسب /SelwadLeague/
$html = $html.Replace('~/', $p)
$html = $html -replace '(href|src)="/(?!SelwadLeague/)(?!/)', ('$1="' + $p)
$html = $html -replace "url\('/(?!SelwadLeague/)", ("url('" + $p)

if (-not (Test-Path docs)) { New-Item docs -ItemType Directory | Out-Null }
Set-Content docs\index.html $html -Encoding UTF8

# انسخ الملفات الثابتة وعدّل مسارات الـ CSS
Copy-Item "SelwadLeague\wwwroot\*" docs\ -Recurse -Force
$c = Get-Content docs\css\site.css -Raw -Encoding UTF8
$c = $c -replace 'url\("/(?!SelwadLeague/)', ('url("' + $p)
Set-Content docs\css\site.css $c -Encoding UTF8

if (-not (Test-Path docs\.nojekyll)) { New-Item docs\.nojekyll -ItemType File | Out-Null }

Write-Host "تم إنشاء docs\index.html" -ForegroundColor Green
