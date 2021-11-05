require 'json'
require 'rest-client'
require 'http'

#Para lograr el objetivo, hare una request que llenara 
#un array con los nombres de los Pokemons

#2 para hacer pelear 2 y luego agrandar el problema
id_pokemons = 8.times.map { rand(151) }

#Funcion que mapea el arreglo de tipos de Pokemon y 
#retorna solo el nombre de cada indice
def getPokemonTypeFromTypesObject(types)
    return types.map {|x| x['type']['name']}.compact
end
##La funcion toma un arreglo de objetos y retorna el atributo
## "name" da cada uno de estos
def getTypeUrlFromTypesObject(types)
    return types.map {|x| x['type']['url']}.compact
end

def getDamageRelationFromType(damage_relation)
    ##Double damage, etc... son arreglos de objetos
    double_damage_from = damage_relation['double_damage_from'].map {|x| x['name']}.compact
    double_damage_to = damage_relation['double_damage_to'].map {|x| x['name']}.compact
    half_damage_from = damage_relation['half_damage_from'].map {|x| x['name']}.compact
    half_damage_to = damage_relation['half_damage_to'].map {|x| x['name']}.compact
    no_damage_from = damage_relation['no_damage_from'].map {|x| x['name']}.compact
    no_damage_to = damage_relation['no_damage_to'].map {|x| x['name']}.compact

    return {"double_damage_from" => double_damage_from,
        "double_damage_to" =>double_damage_to,
        "half_damage_from" =>half_damage_from,
        "half_damage_to" =>half_damage_to,
        "no_damage_from" =>no_damage_from,
        "no_damage_to" =>no_damage_to
    }
 
end


pokemons = {}
#esto se podria arreglar, pero sirve
i = 0
for id in id_pokemons do
    poke_url = "https://pokeapi.co/api/v2/pokemon/#{id}"
    poke_query = HTTP.get(poke_url)
    poke_query_res = JSON.parse(poke_query.to_str)
    damage_relations = []

    # types_url = getTypeUrlFromTypesObject(poke_query_res['types'])

    # for type_url in types_url do
    #     type_query =  RestClient.get(type_url)
    #     type_res = JSON.parse(type_query.to_str)
    #     damage_relations.push(getDamageRelationFromType(type_res['damage_relations']))
    #     # puts JSON.pretty_generate(damage_relations)
    #     # 
    # end
    pokemons["Pokemon #{i}"] = {"name"=>poke_query_res['forms'][0]['name'], 
                                 "hp"=>poke_query_res['stats'][0]['base_stat'],
                                 "attack"=>poke_query_res['stats'][1]['base_stat'],
                                 "defense"=>poke_query_res['stats'][2]['base_stat'],
                                 "special-attack"=>poke_query_res['stats'][3]['base_stat'],
                                 "special-defense"=>poke_query_res['stats'][4]['base_stat'],
                                 "speed"=>poke_query_res['stats'][5]['base_stat'],
                                 "types"=>getPokemonTypeFromTypesObject(poke_query_res['types']),
                                 }
    i = i+1                            
end


def fight(pokemon_a, pokemon_b, number)
    puts "-----------------------"
    puts "BATTLE #{number}"
    puts "-----------------------"
    ##The Pokemon who gives the first punch, is the faster
    ##In case the speeds are equal, starter is picked randomly
    pokemon_a_speed = pokemon_a["speed"]
    pokemon_b_speed = pokemon_b["speed"]

    first = pokemon_a
    second = pokemon_b

    if(pokemon_a_speed < pokemon_b_speed)
        first = pokemon_b
        second = pokemon_a
    elsif pokemon_a_speed == pokemon_b_speed
        prob = rand(10)
        if prob >5
            first = pokemon_b
            second = pokemon_a
        else
            first = pokemon_a
            second = pokemon_b
        end
    end
    first_hp = first["hp"]
    second_hp = second["hp"]
    puts first['name']
    puts "VS"
    puts second['name']
    puts "-----------------------"

    def calculateDamage(attack,special_attack,defense,special_defense)
        prob = rand(10)
        if prob > 5 
            damage = attack.to_f/defense 
        else
            damage =  special_attack.to_f/special_defense
        end
        return damage
    end
   

    while first_hp >= 0 and second_hp >= 0

        dmg1 = calculateDamage(first["attack"],first["special-attack"],second["defense"],second["special-defense"])
        second_hp -= dmg1
    
        dmg2 = calculateDamage(second["attack"],second["special-attack"],first["defense"],first["special-defense"])
        first_hp -= dmg2

        if first_hp <= 0 or second_hp <= 0
            if first_hp >= second_hp
                winner = first
            else
                winner = second
            end
        end
    end
    puts "WINNER"
    puts "•••••••••••••••••••••••"
    puts winner['name']
    puts "•••••••••••••••••••••••"
    
    
    return winner
end
def tournament(pokemons)
    puts "ROUND 1"

    def round_1(pokemons)
        w_battle_1 = fight(pokemons["Pokemon 0"],pokemons["Pokemon 1"],1)
        w_battle_2 = fight(pokemons["Pokemon 2"],pokemons["Pokemon 3"],2)
        w_battle_3 = fight(pokemons["Pokemon 4"],pokemons["Pokemon 5"],3)
        w_battle_4 = fight(pokemons["Pokemon 6"],pokemons["Pokemon 7"],4)
        winners_first_round = [w_battle_1,w_battle_2,w_battle_3,w_battle_4]
        return winners_first_round
    end
    winners_first_round = round_1(pokemons)

    def round_2(winners_first_round)
        puts " "
        puts "!!!!!!!!!!!!!!!!!!!!!!"
        puts " "
        puts "ROUND 2"
        w_battle_5 = fight(winners_first_round[0],winners_first_round[1],5)
        w_battle_6 = fight(winners_first_round[2],winners_first_round[3],6)

        winners_second_round = [w_battle_5, w_battle_6]
        return winners_second_round
    end

    winners_second_round = round_2(winners_first_round)

    def final(winners_second_round)
        puts "!!!!!!!!!!!!!!!!!!!!!!"
        puts "TOURNAMENT FINAL"
        w_final = fight(winners_second_round[0],winners_second_round[1],7)
        puts "TOURNAMENT WINNER"
        puts "§§§§§§§§§§§§§§§§§§§§§§§"
        puts w_final["name"]
        puts "§§§§§§§§§§§§§§§§§§§§§§§"

        return w_final
    end
    champion = final(winners_second_round)
end

tournament(pokemons)





