namespace :routing_report do
  task :run => :environment do
    # pre-load all controllers:
    Dir.glob(Rails.root.join('app', 'controllers', '**', '*_controller.rb')).each do |path|
      require_dependency(path)
    end

    RoutingReport::Report.new(
      base_class: ActionController::Base,
      routes: Rails.application.routes.set
    ).print
  end
end
