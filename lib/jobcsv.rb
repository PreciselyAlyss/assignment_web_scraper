require 'csv'

class JobCsv
  def initialize
    # stuff here
  end

  def create_csv(results)
    file = 'job_data.csv'
    header = 'title,company,link,location'
    CSV.open(file, 'a' do |csv|
      csv << header
      csv << "\n"
      results.each do |item|
        csv << item
      end
    end
  end
end
