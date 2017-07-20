require "spec_helper"

RSpec.describe RoutingReport::Report do
  ActionControllerBase = Class.new

  ApplicationController = Class.new(ActionControllerBase)

  SubController = Class.new(ApplicationController) do
    def show
    end

    def index
    end
  end

  SubSubController = Class.new(SubController) do
    def create
    end
  end

  subject(:report) {
    described_class.new(
      base_class: ActionControllerBase,
      routes: routes
    )
  }

  describe '#print' do
    let(:routes) { [] }

    it 'does not raise an exception' do
      File.open('/dev/null', 'a') do |output|
        expect { report.print(to: output) }.not_to raise_error
      end
    end
  end

  describe '#routes_without_actions' do
    context 'with no routes' do
      let(:routes) { [] }

      it 'returns no routes' do
        expect(report.routes_without_actions).to be_empty
      end
    end

    context 'with a route defined that references a non-existent controller' do
      let(:routes) {
        [
          double(defaults: { controller: 'nope', action: 'show' })
        ]
      }

      it 'returns the route' do
        expect(report.routes_without_actions).to eq ['nope#show']
      end
    end

    context 'with a route defined that is implemented by a superclass' do
      let(:routes) {
        [
          double(defaults: { controller: 'sub_sub', action: 'index' })
        ]
      }

      it 'returns no routes' do
        expect(report.routes_without_actions).to be_empty
      end
    end

    context 'with a route defined that is implemented by a controller' do
      let(:routes) {
        [
          double(defaults: { controller: 'sub', action: 'show' })
        ]
      }

      it 'returns no routes' do
        expect(report.routes_without_actions).to be_empty
      end
    end

    context 'with a route defined that is not implemented by a controller' do
      let(:routes) {
        [
          double(defaults: { controller: 'sub', action: 'non_existent' })
        ]
      }

      it 'returns the route' do
        expect(report.routes_without_actions).to eq ['sub#non_existent']
      end
    end
  end

  describe '#actions_without_routes' do
    context 'with no routes' do
      let(:routes) { [] }

      it 'returns all the actions' do
        expect(report.actions_without_routes).to eq [
          'sub#index',
          'sub#show',
          'sub_sub#create'
        ]
      end
    end

    context 'with one of the routes defined' do
      let(:routes) {
        [
          double(defaults: { controller: 'sub', action: 'index' })
        ]
      }

      it 'returns the other two actions' do
        expect(report.actions_without_routes).to eq [
          'sub#show',
          'sub_sub#create'
        ]
      end
    end

    context 'with all of the routes defined' do
      let(:routes) {
        [
          double(defaults: { controller: 'sub', action: 'show' }),
          double(defaults: { controller: 'sub', action: 'index' }),
          double(defaults: { controller: 'sub_sub', action: 'create' })
        ]
      }

      it 'returns no actions' do
        expect(report.actions_without_routes).to be_empty
      end
    end
  end
end
