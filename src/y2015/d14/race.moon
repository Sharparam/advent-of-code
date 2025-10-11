reindeer = {}

parse = (line) ->
    name, speed, duration, cooldown = line\match '(%w+)[^%d]+(%d+)[^%d]+(%d+)[^%d]+(%d+)'
    reindeer[name] = :speed, :duration, :cooldown

get_winner = (race_duration) ->
    states = [{
        speed: data.speed
        duration: data.duration
        cooldown: data.cooldown
        delta: data.speed
        time: data.duration
        distance: 0
        points: 0
    } for name, data in pairs reindeer]

    for n = race_duration, 0, -1
        max_distance = 0

        for data in *states
            with data
                .distance += data.delta
                max_distance = .distance if .distance > max_distance
                .time -= 1
                if .time == 0
                    .time = .delta == 0 and .duration or .cooldown
                    .delta = .delta == 0 and .speed or 0

        for data in *states
            data.points += 1 if data.distance == max_distance

    max_distance = 0
    max_points = 0

    for data in *states
        max_distance = data.distance if data.distance > max_distance
        max_points = data.points if data.points > max_points

    max_distance, max_points

{ :parse, :get_winner }
