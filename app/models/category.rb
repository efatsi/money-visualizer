class Category < ApplicationRecord
  has_many :line_items

  scope :expenses, -> { where.not(name: ["Mortgage", "Income", "Reimbursements"]) }

  def average(range = 12)
    range ||= 12

    months = LineItem.months.last(range.to_i)

    set = months.map do |month|
      line_items.where(month_year: month).sum(&:amount)
    end

    (set.sum / set.count).round(2)
  end
end
