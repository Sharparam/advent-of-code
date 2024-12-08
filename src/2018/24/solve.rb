#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

TEAMS = %i[immune_system infection].freeze

def enemy_of(item)
  return enemy_of item.team if item.respond_to? :team
  (TEAMS - [item]).first
end

class Group
  include Comparable

  LINE_REGEX = %r{^
    (?<units>\d+).+?(?<hitpoints>\d+).+?
    (?:\((?<modifications>(?:
      (?:weak|immune)\s+to\s+(?:\w+,\s*)*\w+
      (?:;\s*)?
    )+)\))?
    \s*with.+?
    (?<attack>\d+)\s+(?<element>\w+)
    .+?(?<initiative>\d+)
  $}x

  MODS_REGEX = /^\s*(?<type>weak|immune) to (?<elements>(?:\w+, )*\w+)\s*$/

  attr_reader :id, :team, :unit_count, :element, :initiative

  def initialize(id, team, unit_count, hitpoints, weaknesses, immunities, attack, element, initiative)
    @id = id
    @team = team
    @unit_count = unit_count
    @hitpoints = hitpoints
    @weaknesses = weaknesses
    @immunities = immunities
    @attack = attack
    @element = element
    @initiative = initiative
  end

  def self.parse(line, team, id, boost = 0)
    line_match = LINE_REGEX.match line

    count = line_match[:units].to_i
    hitpoints = line_match[:hitpoints].to_i
    attack = line_match[:attack].to_i + boost
    element = line_match[:element].to_sym
    initiative = line_match[:initiative].to_i

    weaknesses = []
    immunities = []

    unless line_match[:modifications].nil?
      mod_split = line_match[:modifications].split ';'
      mod_split.each do |mod|
        mod_match = MODS_REGEX.match mod
        type = mod_match[:type].to_sym
        elements = mod_match[:elements].split(',').map { |e| e.strip.to_sym }
        if type == :weak
          weaknesses.concat elements
        elsif type == :immune
          immunities.concat elements
        end
      end
    end

    Group.new id, team, count, hitpoints, weaknesses, immunities, attack, element, initiative
  end

  def effective_power
    @attack * @unit_count
  end

  def weak_to?(element)
    @weaknesses.include? element
  end

  def immune_to?(element)
    @immunities.include? element
  end

  def defeated?
    @unit_count <= 0
  end

  def calculate_damage(attacker)
    return 0 if immune_to? attacker.element
    return attacker.effective_power * 2 if weak_to? attacker.element
    attacker.effective_power
  end

  def damage!(attacker)
    amount = calculate_damage attacker
    return [0, 0] if amount == 0
    would_kill = (amount / @hitpoints).floor
    will_kill = would_kill > @unit_count ? @unit_count : would_kill
    [amount, will_kill.tap { |c| @unit_count -= c }]
  end

  def <=>(other)
    eff_comp = other.effective_power <=> effective_power
    return eff_comp unless eff_comp == 0
    other.initiative <=> @initiative
  end

  def to_s
    weak = @weaknesses.join ', '
    immune = @immunities.join ', '
    str = "[#{@team} - #{@id}] #{@unit_count} units each with #{@hitpoints} hit points"

    unless weak.empty? && immune.empty?
      str += ' ('
      strs = []
      strs << "weak to #{weak}" unless weak.empty?
      strs << "immune to #{immune}" unless immune.empty?
      str += strs.join '; '
      str += ')'
    end

    "#{str} with an attack that does #{@attack} #{@element} damage at initiative #{@initiative}"
  end
end

groups = []
team = nil
id = 0

boost = ARGV&.first.to_i

File.readlines('input.txt').each do |line|
  if line =~ /immune system/i
    team = :immune_system
  elsif line =~ /infection/i
    team = :infection
  elsif line !~ /^\r?\n$/
    group = Group.parse line, team, (id += 1), (team == :immune_system ? boost : 0)
    groups << group
  end
end

def fight(groups)
  # key: source (attacker)
  # value: target (defender)
  targets = {}

  puts

  damage_dealers = 0

  groups.sort.each.reject(&:defeated?).each do |group|
    enemy = enemy_of group
    enemies = groups.select { |g| g.team == enemy && !g.defeated? && !targets.values.include?(g.id) }
    damage_arr = enemies.map { |e| [e, e.calculate_damage(group)] }.sort_by(&:last).reverse
    next if damage_arr.empty?
    top_damage = damage_arr.first.last
    top_targets = damage_arr.select { |a| a.last == top_damage }.sort_by(&:first)
    target = top_targets.first
    next if target.last == 0 || targets.values.include?(target.first.id)
    puts "#{group.team} group #{group.id} would deal defending group #{target.first.id} #{target.last} damage"
    targets[group.id] = target.first.id
    damage_dealers += 1
  end

  # unless damage_dealers > 0
  #   puts " !!! STALEMATE !!!"
  #   binding.pry
  # end

  abort ' !!! STALEMATE !!!' unless damage_dealers > 0

  puts

  groups.sort_by(&:initiative).reverse.each do |group|
    next unless targets[group.id] && !group.defeated?
    defender_id = targets[group.id]
    defender = groups.find { |g| g.id == defender_id }
    _dealt, kills = defender.damage! group
    puts "#{group.team} group #{group.id} attacks defending group #{defender.id}, killing #{kills} units"
    puts " -=/!\\=- defending group #{defender.id} died -=/!\\=-" if defender.defeated?
  end
end

def count_alive_teams(groups)
  groups.reject(&:defeated?).map(&:team).uniq.size
end

fight(groups) while count_alive_teams(groups) > 1

def get_alive_units(groups)
  alive = groups.reject(&:defeated?)
  alive.each do |group|
    puts "#{group.team} group #{group.id} alive with #{group.unit_count} units"
  end
  alive.sum(&:unit_count)
end

puts "Part 1: #{get_alive_units groups}"
