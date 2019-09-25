require 'csv'

class Importer
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def import
    CSV.read(path).each do |row|
      if row.any?(&:present?)
        @row = row
        date,
        title,
        amount,
        source,
        category_name = row

        date.match(/(\d+)\/(\d+)\/(\d+)/)
        date = "#{$2}/#{$1}/#{$3}"

        LineItem.create!(
          date: date,
          title: title,
          amount: amount.gsub('$', ''),
          source: source,
          category_name: category_name
        )
      end
    end
  rescue => e
    binding.pry
  end
end
