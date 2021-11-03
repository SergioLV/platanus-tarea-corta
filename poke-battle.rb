require 'json'
require 'rest-client'
#Para lograr el objetivo, hare una request que llenara un array con los nombres de los poke

#2 para hacer pelear 2 y luego agrandar el problema
id_pokemones = 2.times.map { rand(150) }

pokemones = {}
#esto se podria arreglar, pero sirve
i = 0
for id in id_pokemones do
    url = "https://pokeapi.co/api/v2/pokemon/#{id}"
    query = RestClient.get(url)
    res = JSON.parse(query.to_str)
    # puts res["stats"]
    # puts "0"
    # puts res["stats"][0]
    # puts "------------------"

    pokemones["Pokemon #{i}"] = {"name"=>res['forms'][0]['name'], 
                                 "stats"=>res['stats'],
                                 "types"=>res['types']}
    i = i+1
    
    
end

puts JSON.pretty_generate(pokemones["Pokemon 0"])

##Como se pelea
##Se elige quien parte primero
##Que habilidad usa






