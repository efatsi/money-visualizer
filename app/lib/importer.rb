require 'csv'

class Importer
  attr_reader :path

  def initialize(path)
    @path = path
    @category_cache = {}
  end

  def import
    rows = CSV.read(path, headers: true)
    row_count = rows.count

    rows.each_with_index do |row, i|
      print "\r#{i + 1} / #{row_count}"

      if row.any?(&:present?)
        # Cache row so it can be inspected in binding.pry
        @row = row

        date = row["Date"]
        title = row["Name"]
        amount = row["Amount"]
        source = row["Source"]
        category_name = row["Type"]

        # Flip day and month so Date.parse can operate on DD/MM/YYYY
        date.match(/(\d+)\/(\d+)\/(\d+)/)
        date = Date.parse("#{$2}/#{$1}/#{$3}")

        # Find category by name
        category = find_category(category_name)

        # Can't use find_or_create here because there are sometimes
        # just duplicates that need to both be imported
        LineItem.create!(
          date: date,
          title: title,
          amount: amount.gsub('$', '').gsub(',', ''),
          source: source,
          category: category
        )
      end
    end

    puts " -- Done!"
  # rescue => e
  #   binding.pry
  end

  private

  def find_category(name)
    @category_cache[name] ||= Category.find_or_create_by!(name: name)
  end
end
