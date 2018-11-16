# Porque...
La conferencia de seguridad Bsides lanzó un Call for Papers (CFP) en el que postulé con un análisis de un Fileless malware que me tocó luchar en la respuesta de un incidente.

# Objetivo
El objetivo de esta charla era compartir lo que aprendí luchando contra este Fileless malware (ya que no soy analista de Malware). El día de ese incidente de ciberseguridad tuve que estudiar mucho para entender como derrotar al bicho. Estudié sobre WMIC, Powershell y otras hierbas que tiene Windows. La idea era que si alguno le tocaba lo mismo, se ahorrara las 5 horas que invertí durante el incidente en entender y preparar una cura.

Adicionalmente programé un fileless malware para mostrar en vivo! Obviamente no tienen ningún mecanismo de Ofuscación ni evasión de AV ya que era para demostrar la prueb a de concepto. Puedes encontrar los codigos en la carpeta Files.
* **injector.ps1**: es la pieza de codigo que injecta el malware.ps1 (en base64) en las clases WMI.
* **malware.ps1**: es la pieza de malware que extrae los usuarios del sistema y los envia mediante POST a un servidor.
* **limpia_malware.ps1**: es la pieza de codigo que limpia este malware.
