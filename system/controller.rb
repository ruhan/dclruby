
require_relative 'view'
require_relative 'util'


class ControllerBase
end


class Controller < ControllerBase
    def initialize
        view = View.new

        util = Util.new
        util.save_database 1
    end
end


# Only run the following code when this file is the main file being run
# instead of having been required or loaded by another file
if __FILE__ == $0
    # Find the parent directory of this file and add it to the front
    # of the list of locations to look in when using require
    $:.unshift File.join(File.dirname(__FILE__),'..')
    $:.unshift File.join(File.dirname(__FILE__),'.')

    Controller.new
end
