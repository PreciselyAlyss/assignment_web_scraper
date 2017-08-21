require 'rubygems'
require 'mechanize'
require 'csv'
require_relative 'jobcsv'

Results = Struct.new(
    :title, 
    :company, 
    :link, 
    :location, 
    :post_data
)

class DiceScrape
  attr_accessor :file, :scraper, :results, :page

  def initialize(site: 'dice.com', job: "developer", location: 78703)
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
    url = 'https://' + @uri + '/jobs?q=' + @job + '&l=' + @location
    @page = scrape.get(url)

    ##
    # h3 > a > span is the job title
    # h3 > a is the job link
    # ul > li > span > a > span.compName is company
    # ul > li > span > a has a link with the company ID (dice.com/company/ID)
    # ul > li > span > span is location/city
    @page.search('#serp-results-content h3').each do |h3|
      current_job = Results.new
      current_job.title = h3.text.strip
      current_job.company = 

      @results << current_job
    end

    @file.create_csv(@results)
  end

end
