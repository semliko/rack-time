require_relative 'middleware/format_time'
require_relative 'app'

use FormatTime

run App.new
