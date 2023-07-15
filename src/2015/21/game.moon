boss_data = {}

stat_map = ['Hit Points']: 'hp', ['Damage']: 'damage', ['Armor']: 'armor'

parse = (line) ->
    trait, value = line\match '(.+): (%d+)'
    boss_data[stat_map[trait]] = tonumber value if trait and value

create_item = (name, cost, damage, armor) -> { :name, :cost, :damage, :armor }

shop =
    weapons: {
        create_item 'Dagger', 8, 4, 0
        create_item 'Shortsword', 10, 5, 0
        create_item 'Warhammer', 25, 6, 0
        create_item 'Longsword', 40, 7, 0
        create_item 'Greataxe', 74, 8, 0
    }
    armor: {
        create_item 'Naked', 0, 0, 0
        create_item 'Leather', 13, 0, 1
        create_item 'Chainmail', 31, 0, 2
        create_item 'Splintmail', 53, 0, 3
        create_item 'Bandedmail', 75, 0, 4
        create_item 'Platemail', 102, 0, 5
    }
    rings: {
        create_item 'Dummy 1', 0, 0, 0
        create_item 'Dummy 2', 0, 0, 0
        create_item 'Damage +1', 25, 1, 0
        create_item 'Damage +2', 50, 2, 0
        create_item 'Damage +3', 100, 3, 0
        create_item 'Defense +1', 20, 0, 1
        create_item 'Defense +2', 40, 0, 2
        create_item 'Defense +3', 80, 0, 3
    }

calculate_combination = (list) ->
    cost, damage, armor = 0, 0, 0

    with shop.weapons[list[1]]
        cost += .cost
        damage += .damage
        armor += .armor

    with shop.armor[list[2]]
        cost += .cost
        damage += .damage
        armor += .armor

    for i = 3, 4
        with shop.rings[list[i]]
            cost += .cost
            damage += .damage
            armor += .armor

    cost, damage, armor

copy = (tbl) ->
    return tbl unless type(tbl) == 'table'
    { k, copy v for k, v in pairs tbl }

fight = (damage, armor) ->
    player = hp: 100, :damage, :armor
    boss = copy boss_data

    while player.hp > 0 and boss.hp > 0
        hp_change = -player.damage + boss.armor
        hp_change = -1 if hp_change > -1
        boss.hp += hp_change
        hp_change = -boss.damage + player.armor
        hp_change = -1 if hp_change > -1
        player.hp += hp_change

    player.hp > 0 and boss.hp < 1

combinations = -> coroutine.wrap ->
    list = {}

    -- Very dirty and hardcoded way to calculate all possible combinations
    for w_i = 1, #shop.weapons
        list[1] = w_i
        for a_i = 1, #shop.armor
            list[2] = a_i
            for r1_i = 1, #shop.rings
                list[3] = r1_i
                for r2_i = 1, #shop.rings
                    continue if r2_i == r1_i
                    list[4] = r2_i
                    coroutine.yield list

get_lowest_cost = ->
    min_cost = 1e9

    for list in combinations!
        cost, damage, armor = calculate_combination list
        min_cost = cost if fight(damage, armor) and cost < min_cost

    min_cost

get_highest_cost = ->
    max_cost = 0

    for list in combinations!
        cost, damage, armor = calculate_combination list
        max_cost = cost unless fight(damage, armor) or cost < max_cost

    max_cost

{ :parse, :get_lowest_cost, :get_highest_cost }
