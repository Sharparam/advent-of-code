reindeer = {}

parse = (line) ->
    name, speed, duration, cooldown = line\match '(%w+) can fly (%d+) km/s for (%d+) seconds, but then must rest for (%d+) seconds.'
    reindeer[name] = :speed, :duration, :cooldown

get_winner = (race_duration) ->
    states = { name, {
        speed: data.speed
        duration: data.duration
        cooldown: data.cooldown
        delta: data.speed
        time: data.duration
        distance: 0
        points: 0
    } for name, data in pairs reindeer}

    while race_duration > 0
        max_distance = 0

        for name, data in pairs states
            with data
                .distance += data.delta
                max_distance = .distance if .distance > max_distance
                .time -= 1
                if .time == 0
                    if .delta == 0
                        .delta = .speed
                        .time = .duration
                    else
                        .delta = 0
                        .time = .cooldown

        -- Now give a point to all reindeers that are on max_distance
        for name, data in pairs states
            data.points += 1 if data.distance == max_distance

        race_duration -= 1

    max_distance = 0
    max_points = 0

    for name, data in pairs states
        max_distance = data.distance if data.distance > max_distance
        max_points = data.points if data.points > max_points

    max_distance, max_points

{ :parse, :get_winner }
