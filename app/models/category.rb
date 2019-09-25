class Category < ApplicationRecord
  has_many :line_items

  def month_average
    set = []

    line_items.group_by(&:month_year).each do |_, items|
      set << items.sum(&:amount)
    end

    if set.any?
      set.sum / LineItem.months.count
    else
      0
    end
  end
end
