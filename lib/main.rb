require 'rubygems'
require 'mechanize'
require 'csv'

scrape = Mechanize.new { |agent|
  agent.user_agent_alias = 'Windows Chrome'
}

scrape.history_added = Proc.new { sleep 0.5 }

file = 'job_data.csv'
header = 'title,company,link,location,post_data,company_id,job_id'
File.open(file, 'a' do |csv|
  csv << header
  csv << "\n"
end
