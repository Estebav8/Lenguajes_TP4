#Programa de conexión con Twitter
#Gemas
	# rubygems
	# open-uri
	# hpricot
	# twitter_oauth
#Version de Ruby 1.8

#Bibliotecas a importar
require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'twitter_oauth'

class Twitter

	#Variables glovales de la clase
	$Url_acceso		#Contiene el url para accesar a la página de permisos
	$Cliente		#Contiene los codigos de la conexion con el API
	$Token_acceso	#Contiene el Token de acceso a Twitter
	$Estado_conexion = false #verifica el estado de la conexión
	
	#Constructor de la clase
	#Tendra como valores
		# 1- API_KEY
		# 2- Clave_secreta
	def initialize()
		$Cliente = TwitterOAuth::Client.new(
	:consumer_key		=> '59O2NWUX1osOKvQG2sgcWw',
	:consumer_secret	=> 'TjmDO34dPtG2j9S05eufL5s7gleLeplyTeb96Bs85g'
		)
		$Token_acceso = $Cliente.request_token
		$Url_acceso = $Token_acceso.authorize_url
	end
	
	#Metodo para establecer la conexión
	#se debe realizar despues de generar los permisos
	def conexion_twitter()
		begin
		accesar_twitter = $Cliente.authorize(
			$Token_acceso.token,
			$Token_acceso.secret
		)
		$Estado_conexion = true
		return true
		rescue Exception => e
				print e,"\n"
				return false
		end
	end
	
	#Metodo que genera el tweet
	#Recive el título de la fotografia y el url
	def twittear(titulo, foto)
		tweet = "Titulo: " + titulo + " - " + "Url: " + foto
		if($Estado_conexion == false)
			return false
		elsif(tweet.length > 140)
			puts "El tweet sobrepaso los 140 caracteres."
			return false
		else
			begin
				$Cliente.update(tweet)
				return true
			rescue
				puts "Fallo el tweet."
				return false
			end
		end
	end
end
