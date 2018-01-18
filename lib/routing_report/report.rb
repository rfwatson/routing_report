require 'terminal-table'

module RoutingReport
  class Report
    def initialize(base_class: Object, routes: [])
      @base_class, @routes = base_class, routes
    end

    def print(to: STDOUT)
      print_table('Routes without actions', routes_without_actions, to)
      print_table('Actions without routes', actions_without_routes, to)
    end

    def routes_without_actions
      routes.each_with_object([]) do |route, accum|
        controller_name = route.defaults[:controller]
        action_name = route.defaults[:action]

        if controller_name && action_name
          begin
            controller = "#{controller_name}_controller".classify.constantize
          rescue NameError
            accum << "#{controller_name}##{action_name}"
            next
          end

          # get all superclasses that descend from ActionController::Base
          # this allows us to avoid false positives when routes are fulfilled by
          # actions in a superclass:
          matching_controllers = controller.ancestors.select { |c| c < base_class }

          unless matching_controllers.any? { |c| c.public_instance_methods.include?(action_name.to_sym) }
            accum << "#{controller_name}##{action_name}"
          end
        end
      end.sort
    end

    def actions_without_routes
      base_class.descendants.each_with_object([]) do |controller_class, accum|
        controller_name = controller_class.name.underscore.match(/\A(.*)_controller\z/)[1]

        controller_class.public_instance_methods(false).each do |method|
          unless routes.any? { |r| r.defaults[:controller] == controller_name && r.defaults[:action] == method.to_s }
            accum << "#{controller_name}##{method.to_s}"
          end
        end
      end.sort
    end

    private
    attr_reader :routes, :base_class

    def print_table(title, rows, to)
      count = rows.size
      rows << "No #{title.downcase} detected" if rows.none?

      to.puts Terminal::Table.new(
        headings: ["#{title} (#{count})"],
        rows: rows.map { |r| [r] },
        style: { width: 80 }
      )
      to.puts
    end
  end
end
