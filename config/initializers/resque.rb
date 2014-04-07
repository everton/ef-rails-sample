logger_file      = File.open(Rails.root.join('log/resque.log'), 'a+')
logger_file.sync = true
Resque.logger    = Logger.new(logger_file)
