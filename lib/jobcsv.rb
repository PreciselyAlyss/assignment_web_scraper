require 'csv'

class JobCsv
  
  def initialize
   @file = 'job_data.csv'
  end

  def create_csv(results)
    # 'a' for append mode
    CSV.open(@file, 'a') do |csv|
      results.each do |item|
        csv << item
      end
    end
  end
end
