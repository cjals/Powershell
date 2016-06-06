# La funcion se llama de la siguiente manera:
#
#		ReadParameters -ConfigurationFilePath "C:\Test\FicheroConfiguracion.ini"
#
# Para obtener la entrada requerida del fichero .ini, se utiliza el siguiente formato:
# $Parameters["<nombre_cabecera>"]["<nombre_entrada>"]
# 	
#		Ej. fichero.ini
# 		[cabecera 1]
# 		entrada1_1 = dato1_1
# 		entrada1_2 = dato1_2
# 		[cabecera 2]
# 		entrada2_1 = dato2_1
# 		entrada2_2 = dato2_2
# 		Obtener la entrada "dato2_2": $Parameters["cabecera 2"]["dato2_2"]
#
 
Function ReadParameters
{
# Parametro de la función que guarda la ruta del fichero .ini
Param([Parameter(Mandatory=$true,Position=0)][string]$ConfigurationFilePath)

# Comprueba si el fichero .ini existe
If(Test-Path $ConfigurationFilePath)
{	
	# Inicicializa un array que contendrá las entradas de fichero .ini
	$script:Parameters=@{} 

	# Aplica un filtro del tipo regex (expresiones regulares) al fichero .ini
	Switch -regex -file $ConfigurationFilePath
	{  
		# Obtiene las cabeceras del fichero .ini
		"^\[(.+)\]$" {$section=$matches[1]; $Parameters[$section]=@{}; $CommentCount=0}
		# Obtiene las entradas del fichero .ini
		"(.+?)\s*=\s*(.*)" {If (!($section)){$section="No-Section"; $Parameters[$section]=@{}} $name,$value=$matches[1..2]; $Parameters[$section][$name]=$value}	
	}
}
Else
{
	# Escribe log si no encuentra el fichero
}

}
