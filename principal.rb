#Tarea Programada 4
#Lenguaje utilizado Ruby
#Estefany Quesada, Esteban Aguilar, Jennifer Barrantes


#Importar las bibliotecas y el archivo Instagram.rb
require 'sinatra'
require 'erb' 
require 'twitter'
require 'rubygems'
require 'instagram'

#Variables globales del sistema
$descrip	#Variable que tiene el paramtro de busqueda
$numero		#Variable que tiene el numero de imagenes a mostrar

#Parametros axiliares en caso de faltar un valor de busqueda
$param_busqueda	= "house"
$param_numero	=  10

$Instagram = Instagram.new() 		#Instancia a la clase Instagram
$Twitter = Twitter.new()	#Instancia a la clase twitter

#Metodo de carga de la pagina principal
#Esta pagina contiene la conexion con Twitter
get '/' do
	erb:Ventana_Conexion
end

#Metodo que envía al usuario a la ventana de busqueda
post '/continuar' do
	redirect '/ventana_busqueda'
end

#Metodo que llama al sistema de conexión de twitter
post '/loguear' do
	if($Twitter.conexion_twitter) == true
		redirect '/ventana_busqueda'
	else
		redirect '/ventana_conexion_fallida'
	end
end

#Metodo que llama a la ventana de conexión si ha fallado
get '/ventana_conexion_fallida' do
	erb :Ventana_Conexion_Fallida
end

#Ventana de busqueda
#Es la que contiene los elementos para realizar la busqueda
get '/ventana_busqueda' do
	erb :Ventana_Busqueda
end

#Clase Helpers

class Helpers  
  def self.find_tweets(default_keyword, extense_keyword = nil)
    base_url = "http://search.twitter.com/search.json?"
    query = (extense_keyword==nil ? default_keyword : default_keyword +"+"+ extense_keyword)
    url = "#{base_url}&rpp=1&page=1&q=#{URI.encode(query)}"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
 
    result = JSON.parse(data)
 
    if result.has_key? 'Error'
      raise "Oops!!"
    end
 
    return result['results']
  end
end


#Clase para buscar en twitter

class Search
def initialize(hash,cant_hash_tags)


# Configurar el cliente
Twitter.configure do |config|
    config.consumer_key = 'consumerKey'
    config.consumer_secret = 'consumerSecret'
    config.oauth_token = 'accessToken'
    config.oauth_token_secret = 'accessSecret'
end
 
# Instanciar
client = Twitter::Client.new
 
 
printf("Utilizando el usuario: %s\n", username)
printf("Buscando la palabra clave: %s\n", keywordSelected)
 
# Encontrar tweets usando el REST API de twitter
tweets = Helpers.find_tweets(keywordSelect,keywordSelect)
 
tweets.each do |tweet|
  	@busqueda = Twitter.search(hash, :count => cant_hash_tags).results.map do |busqueda1|"#{busqueda1.full_text}%&%#{busqueda1.created_at}%&%#{busqueda1.from_user}%&%#{busqueda1.user.profile_image_url}"
end
end 
  


#Se devuelve las respuestas generadas
def retornoBusqueda()
return @busqueda
end

end


# Clase que se encarga de buscar las imágenes en instagram

class BuscarInstagram 
	def initialize(tag,cant_hash_tags)

Instagram.api_key =  "b907fe707248d846c970de37fdf212e0"
Instagram.shared_secret = "d6300bd479506d23"

end

@busqueda1=Instagram.tag_recent_media(tag,options={:count=>cant_hash_tags})
end

def retorno
return @busqueda1
end

end


class ListaTweets
def initialize()
@ListaTweet=[]
end

 def insertar(texto,time,usuario,foto)
templista=[texto,time,usuario,foto]
@Lista+=[templista]
end

def imprimir
x=0
len = @ListaTweet.count
while len>x
 puts @ListaTweet[x]
x=x+1
end
 end
end


def separartweets(tweets,lista)

len=tweets.count
x=0
while x<len do
tweetsparte=tweets[x].split("%&%")
lista.insertar(tweetsparte[0],tweetsparte[1],tweetsparte[2],tweetsparte[3])                               
x=x+1
end
end

 

def separarInstagram(Instagram)
len=Instagram.count
x=0
while x<len do
puts Instagram[x]
end
end





#Metodo que llama al metodo para generar el tweet
post '/twitteo' do
	if($Twitter.twittear($Titulo, $Foto)) == true
		puts "Tweet generado"
		redirect '/ventana_foto'
	else
		redirect '/tweet_error'
	end
end

#Metodo que muesta la imagen si fallo el tweet
get '/tweet_error' do
	erb :Ventana_Tweet_Fallido
end

#Metodo que llama a la pagina de resultado de la aplicacion	
get '/ventana_foto' do   
tag = params[:busqueda].to_s
num = params[:numtag].to_i
if (tag!="#") or(tag!="")or (tag!=" ") or (num>0)

$lista=ListaTweets.new
buscartwitter = Search.new(tag,num)
obtenidos = buscarTwitter.retornoBusqueda
separarelementos(obtenidos,$lista)
$lista.imprimir


hash=tag.delete("#")
buscarInsta = BuscarInstagram.new(hash,num)
obtenidos2=buscarInsta.retorno
separarelementos(obtenidos2)
else
puts 'error'
end	

	erb :Ventana_Foto
end




