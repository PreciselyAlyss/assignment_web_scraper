require 'rubygems'
require 'mechanize'
require 'csv'
require_relative 'jobcsv'

Results = Struct.new(
    :title, 
    :company, 
    :link, 
    :location,
    :date_added
)

class DiceScrape
  attr_accessor :file, :scraper, :results, :page

  def initialize(site: 'dice.com', job: 'developer', location: '78703')
    @uri = site
    @job = job
    @location = location
    @results = []
    @file = JobCsv.new
    @scrape = Mechanize.new { |agent|
      agent.user_agent_alias = 'Windows Chrome'
    }
    @scrape.history_added = Proc.new { sleep 0.5 }
  end

  def get_results
    url = "https://#{@uri}/jobs?q=#{@job}&l=#{@location}"
    @page = @scrape.get(url)

    ##
    # h3 > a > span is the job title
    # h3 > a is the job link
    # ul > li > span > a > span.compName is company
    # ul > li > span > a has a link with the company ID (dice.com/company/ID)
    # ul > li > span > span is location/city
    @page.search('.complete-serp-result-div h3').each do |h3|
      current_job = Results.new
      # @page.search doesn't feel right here
      current_job.title = @page.search('h3 a').attr('title').value
      current_job.company = @page.search('li.employer .hidden-xs').attr('title').value
      current_job.link = @page.search('h3 a').attr('href').value
      current_job.location = @page.search('li.location').attr('title').value
      current_job.date_added = Time.now.getutc

      @results << current_job
    end

    @file.create_csv(@results)
  end

end

jobs = DiceScrape.new
jobs.get_results
