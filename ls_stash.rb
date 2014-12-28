#!/usr/bin/env ruby
#
# ./ls_stash.rb - Lists objects from Stash
#
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

require 'rubygems'
require 'thor'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

def rest_request(endpoint, href, user, password, verbose = false, prettify = true)
  uri = URI.join(endpoint, href)
  puts "[GET] #{uri}" if verbose
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  request.basic_auth(user, password)
  if prettify
    JSON.parse(http.request(request).body)
  else
    JSON.pretty_generate(JSON.parse(http.request(request).body))
  end
end

# Main class with Thor
class LsStash < Thor
  class_option :verbose, type: :boolean
  class_option :user, type: :string, required: true
  class_option :password, type: :string, required: true

  desc 'projects STASH_URL', 'Lists all stash projects'
  def projects(stash_url)
    puts rest_request(stash_url, '/rest/api/1.0/projects', options[:user], options[:password], options[:verbose])
  end

  desc 'repos STASH_URL', 'Lists stash repositories'
  options all: :boolean
  option :all, type: :boolean, aliases: :a
  def repos(stash_url)
    projects = JSON.parse(rest_request(stash_url, '/rest/api/1.0/projects', options[:user], options[:password], options[:verbose]))
    repositories = []
    projects['values'].each do |project|
      project_repositories = JSON.parse(rest_request(stash_url, "/rest/api/1.0/projects/#{project['key']}/repos", options[:user], options[:password], options[:verbose]))
      project_repositories['values'].each do |repo|
        clone = repo['links']['clone'][0]['href']
        repositories.push(clone) if clone.include? 'ssh://'
      end
    end
    repositories.each do |repo|
      puts repo.to_s
    end
  end
end

begin
  ENV['THOR_DEBUG'] = '1'
  LsStash.start
rescue Thor::RequiredArgumentMissingError => e
  puts "#{e}"
  LsStash.help(Thor::Base.shell.new)
end
