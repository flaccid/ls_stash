# Author:: Chris Fordham (<chris@fordham-nagy.id.au>)
# Copyright:: Copyright (c) 2014-2015 Chris Fordham
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'logger'

class Log
  attr_accessor :log

  def initialize(*args)
    @log_init_msg = 'Initializing Logging using '

    if ENV['LS_STASH_LOG']
      if File.exists?(ENV['LS_STASH_LOG'])
        file = File.open(ENV['LS_STASH_LOG'], File::WRONLY | File::APPEND)
      else
        file = ENV['LS_STASH_LOG']
      end
      @log = ::Logger.new(file)
      @log_init_msg += ENV['LS_STASH_LOG']
    else
      @log = ::Logger.new(STDOUT)
      @log_init_msg += 'STDOUT'
    end
  end

  def init_message()
    @log.info @log_init_msg
  end

  def info(msg)
    @log.info msg
  end
    
  def debug(msg)
    @log.debug msg
  end

  def error(msg)
    @log.error msg
  end
end
