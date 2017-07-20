module RoutingReport
  class Railtie < Rails::Railtie
    rake_tasks { load 'tasks/routing_report.rake' }
  end
end
