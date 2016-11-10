#\ -s puma
require './main_controller'

# run Rack::URLMap.new('/' => MainController)
run MainController
