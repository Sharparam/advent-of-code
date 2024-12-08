# frozen_string_literal: true
require_relative 'pqueue'

INF = Float::INFINITY

module AStar
  class << self
    def find_path(graph, start, goal, &heuristic)
      heuristic ||= method(:default_heuristic)

      frontier = PriorityQueue.new
      came_from = {}
      cost_so_far = {}

      if start.is_a?(Enumerable) && !start.is_a?(Vector)
        start.each do
          frontier.enqueue _1, 0
          came_from[_1] = nil
          cost_so_far[_1] = 0
        end
      else
        frontier.enqueue start, 0
        came_from[start] = nil
        cost_so_far[start] = 0
      end

      while frontier.any?
        current = frontier.dequeue
        break if current == goal
        graph.neighbors(current).each do |vertex|
          new_cost = cost_so_far[current] + graph.cost(current, vertex)
          if !cost_so_far.key?(vertex) || new_cost < cost_so_far[vertex]
            cost_so_far[vertex] = new_cost
            priority = new_cost + heuristic.call(vertex, goal)
            frontier.enqueue vertex, priority
            came_from[vertex] = current
          end
        end
      end

      [came_from, cost_so_far]
    end

    def reconstruct_path(came_from, start, goal)
      current = goal
      path = []
      while current != start
        path << current
        current = came_from[current]
      end
      path << start
      path.reverse
    end

    private

    def default_heuristic(a, b)
      x1, y1 = a.to_a
      x2, y2 = b.to_a
      (x1 - x2).abs + (y1 - y2).abs
    end
  end
end
